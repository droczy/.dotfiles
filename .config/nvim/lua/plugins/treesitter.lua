return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = function()
      local has_compiler = vim.fn.executable("cc") == 1
        or vim.fn.executable("clang") == 1
        or vim.fn.executable("gcc") == 1
      if vim.fn.executable("git") == 1 and has_compiler then
        pcall(vim.cmd, "TSUpdate")
      end
    end,
    cmd = { "TSInstall", "TSUpdate", "TSUninstall", "TSLog" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local function warn_once(message)
        if vim.notify_once then
          vim.notify_once(message, vim.log.levels.WARN, { title = "Treesitter" })
          return
        end

        vim.notify(message, vim.log.levels.WARN, { title = "Treesitter" })
      end

      local has_compiler = vim.fn.executable("cc") == 1
        or vim.fn.executable("clang") == 1
        or vim.fn.executable("gcc") == 1
      local has_parser_toolchain = vim.fn.executable("git") == 1 and has_compiler

      local ensured_languages = {}
      if has_parser_toolchain then
        ensured_languages = {
          "lua",
          "python",
          "java",
          "rust",
          "vim",
          "vimdoc",
          "query",
          "markdown",
          "markdown_inline",
          "bash",
          "json",
          "yaml",
        }
      else
        warn_once("Parser auto-install is disabled because git or a C compiler is missing.")
      end

      require("nvim-treesitter.configs").setup({
        ensure_installed = ensured_languages,
        auto_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
