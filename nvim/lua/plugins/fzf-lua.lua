return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },

  config = function()
    require('fzf-lua').setup {
      -- Key mappings for fzf-lua
      vim.keymap.set('n', '<leader>ff', function()
        require('fzf-lua').files()
      end, { desc = 'Find Files' }),

      vim.keymap.set('n', '<leader>fg', function()
        require('fzf-lua').live_grep()
      end, { desc = 'Live Grep' }),

      vim.keymap.set('n', '<leader>fb', function()
        require('fzf-lua').buffers()
      end, { desc = 'Buffers' }),

      vim.keymap.set('n', '<leader>fh', function()
        require('fzf-lua').help_tags()
      end, { desc = 'Help Tags' }),
    }
  end,
}
