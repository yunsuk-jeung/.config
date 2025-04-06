return {
  {
    'OXY2DEV/markview.nvim',
    lazy = false, -- Recommended
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      vim.defer_fn(function()
        require('markview').setup {
          markdown = {
            headings = {
              -- org_indent = true,
              -- org_shift_width = 1,
            },
          },
        }
      end, 200)
    end,
  },
}
