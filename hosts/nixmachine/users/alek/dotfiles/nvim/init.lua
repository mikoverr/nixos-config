-- 1. Basic appearance and behavior settings
vim.opt.number = true             -- show absolute line numbers
vim.opt.relativenumber = true     -- relative line numbers for easy navigation (j/k)
vim.opt.mouse = 'a'               -- enable mouse support everywhere
vim.opt.clipboard = 'unnamedplus' -- use the system clipboard (works via wl-clipboard)
vim.opt.tabstop = 4               -- tab size (in spaces)
vim.opt.shiftwidth = 4            -- the size of the margin
vim.opt.termguicolors = true      -- enable True Color support in the terminal
vim.opt.wrap = false              -- disable hyphenation of long lines

-- 2. configuring the Leader key (prefix for many commands)
vim.g.mapleader = ' '             -- assign the Space bar as the Leader key.

-- 3. custom shortcuts (as in "regular" editors)
local keymap = vim.keymap

-- Save by Ctrl+S (works in normal, insert and visual mode)
keymap.set({'n', 'i', 'v'}, '<C-s>', '<Esc>:w<CR>', { desc = 'Сохранить файл' })

-- Exit by Ctrl+Q
keymap.set('n', '<C-q>', ':q<CR>', { desc = 'Закрыть редактор' })

-- De-highlighting the found text by double-pressing Esc
keymap.set('n', '<Esc>', ':nohlsearch<CR>', { desc = 'Убрать подсветку поиска' })

-- Switch between open windows (splits) via Ctrl + arrows
keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Перейти в левый сплит' })
keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Перейти в нижний сплит' })
keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Перейти в верхний сплит' })
keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Перейти в правый сплит' })

-- 4. Loading the lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Подключение всех плагинов из папки lua/plugins
require("lazy").setup("plugins")
