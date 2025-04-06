return {
  -- {
  --   'folke/ts-comments.nvim',
  --   opts = {},
  --   event = 'VeryLazy',
  --   enabled = vim.fn.has 'nvim-0.10.0' == 1,
  -- },
  {
    'numToStr/Comment.nvim',
    -- event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    opts = {},
    config = function()
      local comment = require 'Comment'
      local ts_comment_integration = require 'ts_context_commentstring.integrations.comment_nvim'

      require('Comment').setup {
        pre_hook = function(ctx)
          local filetype = vim.bo.filetype
          if filetype == 'typescriptreact' or filetype == 'javascriptreact' then
            return ts_comment_integration.create_pre_hook()(ctx)
          end
        end,
      }
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<C-_>', require('Comment.api').toggle.linewise.current, opts)
      -- -- vim.keymap.set('n', 'gl', require('Comment.api').toggle.blockwise.current, opts)
      -- -- vim.keymap.set('n', '<C-c>', require('Comment.api').toggle.linewise.current, opts)
      -- -- vim.keymap.set('n', '<C-/>', require('Comment.api').toggle.linewise.current, opts)
      vim.keymap.set('v', '<C-_>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
      -- -- vim.keymap.set('v', '<C-c>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
      -- -- vim.keymap.set('v', '<C-/>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
      vim.keymap.set('n', '<C-B>', require('Comment.api').toggle.blockwise.current, opts)
      vim.keymap.set('v', '<C-B>', "<esc><cmd>lua require('Comment.api').toggle.blockwise(vim.fn.visualmode())<cr>", opts)
    end,
  },
}
