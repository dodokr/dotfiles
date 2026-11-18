vim.g.mapleader = ' '

vim.opt.guicursor = ''

-- Paste from system clipboard
-- Instead, now I use <leader>y to use system clipboard
-- vim.opt.clipboard = "unnamedplus"

-- Enable relative line numbers
vim.opt.relativenumber = true

-- Show absolute number on current line
vim.opt.number = true

vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 4 -- Number of spaces for each step of indent
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> counts for
vim.opt.softtabstop = -1 -- Automatically mirrors shiftwidth value
vim.opt.smartindent = true -- Do smart autoindenting when starting a new line

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true -- Case-insensitive search...
vim.opt.smartcase = true -- ...unless the pattern contains an uppercase letter

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append '@-@'

vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "80"
