local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Initialize Lazy.nvim with an empty plugin setup
require("lazy").setup({})
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {"*.odin"},
  callback = function()
    vim.cmd("setlocal syntax=OFF")
  end
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {"*.cpp", "*.h"},
  callback = function()
    vim.cmd("setlocal syntax=OFF")
  end
})
