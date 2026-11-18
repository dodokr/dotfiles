return {
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    ---@module "fzf-lua"
    ---@type function|fzf-lua.Config|{}
    opts = {
      files = {
        -- include gitignored files, but still skip the .git directory
        fd_opts = '--color=never --hidden --no-ignore --type f --type l --exclude .git',
        rg_opts = '--color=never --hidden --no-ignore --files -g "!.git"',
      },
    },
    keys = {
      -- Find files in the project
      { '<C-p>', '<cmd>FzfLua git_files<cr>', desc = 'Find Git Files' },
      {
        '<leader>pf',
        '<cmd>FzfLua files<cr>',
        desc = 'Find Files (including git ignored ones)',
      },
      -- Live grep text search across the project
      { '<leader>ps', '<cmd>FzfLua live_grep<cr>', desc = 'Live Grep' },
      -- View recent files history
      { '<leader>ph', '<cmd>FzfLua oldfiles<cr>', desc = 'Recent Files' },
    },
  },
}
