return {
  -- {
  --   'MeanderingProgrammer/render-markdown.nvim',
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'nvim-tree/nvim-web-devicons',
  --   },
  --   ft = 'markdown',
  --   event = 'VeryLazy',
  --   opts = function()
  --     vim.api.nvim_set_hl(0, 'RMdH1', { fg = '#8ebf6b', bg = '#486335' })
  --     vim.api.nvim_set_hl(0, 'RMdH2', { fg = '#6abfb5', bg = '#36635e' })
  --     vim.api.nvim_set_hl(0, 'RMdH3', { fg = '#6893bf', bg = '#354c63' })
  --     vim.api.nvim_set_hl(0, 'RMdH4', { fg = '#bf8267', bg = '#634335' })
  --     vim.api.nvim_set_hl(0, 'RMdH5', { fg = '#bf6969', bg = '#643636' })
  --     vim.api.nvim_set_hl(0, 'RMdH6', { fg = '#be687d', bg = '#623540' })
  --     vim.api.nvim_set_hl(0, 'RMdCodeBlock', { bg = '#434343' })
  --
  --     return {
  --       heading = {
  --         sign = false,
  --         icons = { '✱ ', '✲ ', '✤ ', '✣ ', '✸ ', '✳ ' },
  --         backgrounds = {
  --           'RMdH1',
  --           'RMdH2',
  --           'RMdH3',
  --           'RMdH4',
  --           'RMdH5',
  --           'RMdH6',
  --         },
  --       },
  --       code = {
  --         sign = false,
  --         left_pad = 1,
  --         highlight = 'RMdCodeBlock',
  --       },
  --       quote = {
  --         icon = '┃',
  --       },
  --     }
  --   end,
  -- },
  {
    'OXY2DEV/markview.nvim',
    lazy = false, -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway

    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local presets = require('markview.presets').headings
      require('markview').setup {
        markdown = {
          headings = {
            org_indent = true,
            org_shift_width = 2,
          },
        },
        headings = presets.glow,
      }
    end,
  },
}
