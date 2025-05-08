return {
  'lukas-reineke/indent-blankline.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    local highlight = {
      'RainbowBlue',
    }
    vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#59c5f0' })
    vim.api.nvim_set_hl(0, 'IndentChar', { fg = '#6d6f70' })
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = '*',
      callback = function()
        vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#59c5f0' })
        vim.api.nvim_set_hl(0, 'IndentChar', { fg = '#6d6f70' })
      end,
    })
    require('ibl').setup {
      exclude = { filetypes = { 'markdown' } },
      indent = {
        char = '▎',
        highlight = 'IndentChar', -- Use custom highlight group for non-scope indents
      },
      scope = {
        --   -- enabled = false,
        char = '▎',
        show_start = true,
        show_end = true,
        injected_languages = true,
        highlight = highlight,
        include = {
          node_type = {
            ['*'] = { '*' },
          },
        },
      },
    }
  end,
}
