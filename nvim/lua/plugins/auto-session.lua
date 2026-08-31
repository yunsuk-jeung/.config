return {
  'rmagatti/auto-session',
  lazy = false,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
    -- log_level = 'debug',

    post_restore_cmds = {
      function()
        pcall(function()
          require('lazy').load { plugins = { 'nvim-lspconfig' } }
        end)
        vim.schedule(function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.fn.buflisted(buf) == 1 and vim.api.nvim_buf_get_name(buf) ~= '' then
              if not vim.api.nvim_buf_is_loaded(buf) then
                vim.fn.bufload(buf)
              end
              if vim.bo[buf].filetype == '' then
                vim.api.nvim_buf_call(buf, function()
                  vim.cmd 'filetype detect'
                end)
              end
              if vim.bo[buf].filetype ~= '' then
                vim.api.nvim_exec_autocmds('FileType', { buffer = buf, modeline = false })
              end
            end
          end
        end)
      end,
    },
  },
}
