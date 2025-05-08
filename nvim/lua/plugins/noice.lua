return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    'rcarriga/nvim-notify',
  },
  config = function()
    vim.notify = require('noice').notify
    require('notify').setup {
      background_colour = '#000000',
    }
    require('noice').setup {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
      },

      views = {
        popup = {
          position = {
            row = '100%',
            col = '100%',
          },
          border = {
            style = 'rounded',
          },
        },
        mini = {
          position = {
            row = -1, -- 화면 아래
            col = '100%', -- 오른쪽 끝
          },
        },
      },

      routes = {
        {
          filter = {
            event = 'msg_show',
            kind = '',
          },
          view = 'mini', -- 또는 "popup"
        },
      },
    }
    -- require('notify').setup {
    --   timeout = 2000,
    --   stages = 'static',
    -- }
    vim.keymap.set('n', '<Esc><Esc>', function()
      require('notify').dismiss()
      vim.cmd 'nohlsearch'
    end, { noremap = true, silent = true, desc = 'Dismiss notify popup and clear hlsearch on double Esc' })
  end,
}
