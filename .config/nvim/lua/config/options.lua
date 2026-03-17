if vim.g.have_nerd_font == nil then
  vim.g.have_nerd_font = false
end

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.scrolloff = 10

vim.o.list = true
vim.opt.listchars = { tab = "> ", trail = ".", nbsp = "+" }

vim.o.breakindent = true
vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.smartindent = true

vim.o.updatetime = 250
vim.o.timeoutlen = 400

vim.o.confirm = true
if vim.fn.has("clipboard") == 1 then
  vim.o.clipboard = "unnamedplus"
end

vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  virtual_text = true,
  jump = { float = true },
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
