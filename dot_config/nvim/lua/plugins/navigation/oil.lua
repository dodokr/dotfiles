-- Directory as an editable buffer: rename = edit line, delete = dd, create = o + name (trailing / for dir), then :w
-- `-` goes to parent dir, <CR> opens, g? shows help
return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false, -- must load at startup to hijack directory buffers (nvim ., :e dir/)
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    -- keep hidden oil buffers alive so <C-o>/<C-i> can jump back into them
    cleanup_delay_ms = false,
    view_options = { show_hidden = true },
    -- oil's defaults (<C-h> = horizontal split, <C-l> = refresh) shadow vim-tmux-navigator
    keymaps = {
      ['<C-h>'] = false,
      ['<C-l>'] = false,
    },
  },
  keys = {
    { '<leader>pv', '<cmd>Oil<cr>', desc = 'File explorer (parent dir of current file)' },
    { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
  },
}
