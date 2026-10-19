-- Right now only used for prettier LSP hover + inital loading progress of LSP
return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
      },
    },
    -- explicitly disable everything else
    cmdline = { enabled = false }, -- Keeps default Vim command line
    messages = { enabled = false }, -- Keeps default Vim messages/echoes
    popupmenu = { enabled = false }, -- Keeps default select menus
    notify = { enabled = false }, -- Disables custom notifications

    -- filter noisy notifications
    routes = {
      {
        filter = {
          event = 'lsp',
          kind = 'progress',
          any = {
            { find = 'pyright' },
          },
        },
        opts = { skip = true },
      },
    },

    presets = {
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    -- "rcarriga/nvim-notify",
  },
}
