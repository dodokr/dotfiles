vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('i', 'jj', '<Esc>', { silent = true })

-- Many taken from ThePrimeagen
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-i>', '<C-i>zz')
vim.keymap.set('n', '<C-o>', '<C-o>zz')

vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- greatest remap ever
vim.keymap.set('x', '<leader>p', [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])

vim.keymap.set('n', 'Q', '<nop>')

-- Quickfix and Location lists
vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next quickfix item and center" })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item and center" })
vim.keymap.set("n", "]l", "<cmd>lnext<CR>zz", { desc = "Next loclist item and center" })
vim.keymap.set("n", "[l", "<cmd>lprev<CR>zz", { desc = "Previous loclist item and center" })

vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })

vim.keymap.set('n', '<leader>w', '<Cmd>update<CR>', { desc = 'Save file' })

--- Drop this when done with downloading plugins (not necessary)
vim.keymap.set('n', '<leader>ms', '<cmd>Lazy sync<cr>', { desc = 'Lazy Sync Plugins' })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

    vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
        vim.lsp.buf.format { async = true }
    end, { desc = '[lsp] format buffer' })

    -- vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)
    -- Live search that queries your LSP client while typing
    vim.keymap.set(
      'n',
      '<leader>ws',
      require('fzf-lua').lsp_live_workspace_symbols,
      { desc = 'LSP Workspace Symbols' }
    )
    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

    -- Enabled in cmp.lua
    -- vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { desc = "Signature Help" })

    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)

    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'See line diagnostic' })

    vim.keymap.set(
      'n',
      '[d',
      function() vim.diagnostic.jump { count = -1, float = true } end,
      { desc = 'Previous diagnostic' }
    )
    vim.keymap.set(
      'n',
      ']d',
      function() vim.diagnostic.jump { count = 1, float = true } end,
      { desc = 'Next diagnostic' }
    )
  end,
})

-- Toggle comment on selection in Visual mode
vim.keymap.set('x', '<C-_>', 'gc', { remap = true, desc = 'Toggle comment selection' })

-- Helper function to toggle comment and shift cursor dynamically
-- Normally, gcc takes cursor to the beginning of a line
local function toggle_comment_shift_cursor()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local old_len = string.len(vim.api.nvim_get_current_line())

    vim.cmd('normal gcc')

  local new_len = string.len(vim.api.nvim_get_current_line())
  local len_diff = new_len - old_len

  cursor_pos[2] = math.max(0, cursor_pos[2] + len_diff)
  vim.api.nvim_win_set_cursor(0, cursor_pos)
end

-- (Ctrl + /)
vim.keymap.set('n', '<C-_>', toggle_comment_shift_cursor, { desc = 'Toggle comment and shift cursor' })
vim.keymap.set('i', '<C-_>', toggle_comment_shift_cursor, { desc = 'Toggle comment and shift cursor' })

