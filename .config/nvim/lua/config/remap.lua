vim.keymap.set("n", "<leader>e", vim.cmd.Ex)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, { desc = "Open diagnostic quickfix list" })

local function warn_use_hjkl()
  vim.notify("Use hjkl instead of arrow keys for navigation", vim.log.levels.WARN, { title = "Navigation" })
end

for _, key in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
  vim.keymap.set({ "n", "v", "x", "o" }, key, warn_use_hjkl, {
    silent = true,
    desc = "Use hjkl",
  })

  vim.keymap.set("i", key, function()
    warn_use_hjkl()
    return ""
  end, {
    expr = true,
    silent = true,
    desc = "Use hjkl",
  })
end
