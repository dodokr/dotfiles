-- Enable persistent undo so history survives across Neovim sessions
vim.o.undofile = true
vim.o.undodir = vim.fn.expand("~/.local/share/nvim/undo")
vim.o.undolevels = 10000

