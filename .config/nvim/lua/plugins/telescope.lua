return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local function warn_once(message)
        if vim.notify_once then
          vim.notify_once(message, vim.log.levels.WARN, { title = "Telescope" })
          return
        end

        vim.notify(message, vim.log.levels.WARN, { title = "Telescope" })
      end

      local telescope = require("telescope")
      telescope.setup({})
      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })

      if vim.fn.executable("rg") == 1 then
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      else
        vim.keymap.set("n", "<leader>fg", function()
          warn_once("ripgrep (rg) is missing. Install it to use live grep.")
        end, { desc = "Live grep (requires rg)" })
      end

      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
    end,
  },
}
