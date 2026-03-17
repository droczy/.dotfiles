-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop

local function warn_once(message)
  if vim.notify_once then
    vim.notify_once(message, vim.log.levels.WARN, { title = "Neovim config" })
    return
  end

  vim.notify(message, vim.log.levels.WARN, { title = "Neovim config" })
end

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

if not uv.fs_stat(lazypath) then
  if vim.fn.executable("git") ~= 1 then
    warn_once("git was not found. Starting Neovim without plugins.")
    return
  end

  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    warn_once("Failed to clone lazy.nvim. Starting without plugins.\n" .. out)
    return
  end
end

vim.opt.rtp:prepend(lazypath)
local ok, lazy = pcall(require, "lazy")
if not ok then
  warn_once("lazy.nvim could not be loaded. Starting without plugins.")
  return
end

lazy.setup({
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = false },
})
