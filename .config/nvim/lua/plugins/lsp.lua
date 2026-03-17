local uv = vim.uv or vim.loop

local function warn_once(message)
  if vim.notify_once then
    vim.notify_once(message, vim.log.levels.WARN, { title = "LSP" })
    return
  end

  vim.notify(message, vim.log.levels.WARN, { title = "LSP" })
end

local function has_executable(command)
  return vim.fn.executable(command) == 1
end

local function resolve_java_home()
  if vim.env.JAVA_HOME and vim.env.JAVA_HOME ~= "" and uv.fs_stat(vim.env.JAVA_HOME) then
    return vim.env.JAVA_HOME
  end

  if vim.fn.has("mac") == 1 and has_executable("/usr/libexec/java_home") then
    local detected = vim.trim(vim.fn.system("/usr/libexec/java_home"))
    if vim.v.shell_error == 0 and detected ~= "" and uv.fs_stat(detected) then
      return detected
    end
  end

  local java_executable = vim.fn.exepath("java")
  if java_executable ~= "" then
    local resolved_java = vim.fn.resolve(java_executable)
    local java_bin_dir = vim.fs.dirname(resolved_java)
    local maybe_home = vim.fs.dirname(java_bin_dir)
    if uv.fs_stat(maybe_home) then
      return maybe_home
    end
  end

  local java_home_candidates = {
    "/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home",
    "/usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home",
    "/usr/lib/jvm/default-java",
    "/usr/lib/jvm/java-21-openjdk",
    "/usr/lib/jvm/java-17-openjdk",
  }

  for _, candidate in ipairs(java_home_candidates) do
    if uv.fs_stat(candidate) then
      return candidate
    end
  end
end

local requested_servers = {
  lua_ls = "lua-language-server",
  pylsp = "pylsp",
  rust_analyzer = "rust-analyzer",
}

if vim.g.enable_java_lsp then
  requested_servers.jdtls = "jdtls"
end

local function detect_enabled_servers()
  local enabled_servers = {}
  local missing_servers = {}

  for server, command in pairs(requested_servers) do
    if has_executable(command) then
      table.insert(enabled_servers, server)
    else
      table.insert(missing_servers, string.format("%s (%s)", server, command))
    end
  end

  table.sort(enabled_servers)
  table.sort(missing_servers)

  if #missing_servers > 0 then
    warn_once("Disabled LSP servers (missing binaries): " .. table.concat(missing_servers, ", "))
  end

  return enabled_servers
end

return {
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    opts = {
      ensure_installed = {},
      automatic_enable = false,
    },
    config = function(_, opts)
      local enabled_servers = detect_enabled_servers()

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_blink, blink = pcall(require, "blink.cmp")
      if ok_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      local java_home = resolve_java_home()

      local server_overrides = {}
      if vim.g.enable_java_lsp and vim.tbl_contains(enabled_servers, "jdtls") then
        server_overrides.jdtls = {
          cmd_env = java_home and {
            JAVA_HOME = java_home,
            PATH = java_home .. "/bin:" .. vim.env.PATH,
          } or nil,
          root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            local root = vim.fs.root(fname, {
              "mvnw",
              "gradlew",
              "settings.gradle",
              "settings.gradle.kts",
              "build.gradle",
              "build.gradle.kts",
              "pom.xml",
              ".git",
              "package.bluej",
            })
            on_dir(root or vim.fs.dirname(fname))
          end,
        }
      end

      for _, name in ipairs(enabled_servers) do
        local config = vim.tbl_deep_extend("force", {
          capabilities = capabilities,
        }, server_overrides[name] or {})

        if vim.lsp.config then
          vim.lsp.config(name, config)
        else
          require("lspconfig")[name].setup(config)
        end

        if vim.lsp.enable then
          vim.lsp.enable(name)
        end
      end

      if #enabled_servers == 0 then
        warn_once("No language servers are available on PATH. Install one via Mason or your package manager.")
      end

      require("mason-lspconfig").setup(opts)
    end,
  },
}
