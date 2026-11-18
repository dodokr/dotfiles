-- https://github.com/brianhuster/live-preview.nvim
-- Serves the cwd over HTTP, so relative links between .md files work in the browser.
-- The plugin uses the cwd as webroot (fixed at server start) and builds the URL relative
-- to it, so a file outside the cwd opens `/nil` (404). <leader>mp therefore starts the
-- server from the file's git root (fallback: the file's dir) and restores the cwd after.

local function start_preview()
  local lp = require 'livepreview'
  -- Stop a running server ourselves: the plugin's close() prints "Server closed"
  -- asynchronously, which stacks with the start message into a hit-enter prompt.
  if lp.serverObj then
    lp.serverObj:stop()
    lp.serverObj = nil
  end

  local root = vim.fs.root(0, '.git') or vim.fn.expand '%:p:h'
  local prev = vim.fn.getcwd()
  vim.cmd('noautocmd cd ' .. vim.fn.fnameescape(root))
  local ok, err = pcall(vim.cmd, 'silent LivePreview start')
  vim.cmd('noautocmd cd ' .. vim.fn.fnameescape(prev))
  if not ok then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end
  local port = require('livepreview.config').config.port
  vim.api.nvim_echo({ { ('Live preview: http://127.0.0.1:%d'):format(port) } }, false, {})
end

return {
  'brianhuster/live-preview.nvim',
  cmd = 'LivePreview',
  keys = {
    { '<leader>mp', start_preview, ft = 'markdown', desc = 'Markdown Preview start' },
    { '<leader>mP', '<cmd>LivePreview close<cr>', ft = 'markdown', desc = 'Markdown Preview close' },
  },
  config = function()
    -- One port per nvim instance: with a fixed port, a second nvim can't bind and the
    -- browser ends up on the other instance's server (different webroot → broken paths).
    local function free_port()
      local tcp = vim.uv.new_tcp()
      tcp:bind('127.0.0.1', 0)
      local port = tcp:getsockname().port
      tcp:close()
      return port
    end

    require('livepreview.config').set {
      port = free_port(),
      -- 'default' goes through xdg-open → kde-open/KIO: ~4.7 s until the tab shows.
      -- Calling Chrome directly hands the URL to the running instance in ~0.2 s.
      browser = 'google-chrome-stable',
      dynamic_root = false,
      sync_scroll = true,
    }
  end,
}
