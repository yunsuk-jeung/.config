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
      local ft = require 'Comment.ft'
      local ts_pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()

      -- Keep XML-family buffers on an explicit HTML-style commentstring.
      ft.set('xml', { '<!-- %s -->', '<!-- %s -->' })
      ft.set('xsd', { '<!-- %s -->', '<!-- %s -->' })
      ft.set('xslt', { '<!-- %s -->', '<!-- %s -->' })

      local pre_hook = function(ctx)
        local ok, cstr = pcall(ts_pre_hook, ctx)
        if ok and type(cstr) == 'string' and cstr:find '%%s' then
          return cstr
        end

        return ft.get(vim.bo.filetype, ctx.ctype) or vim.bo.commentstring
      end

      require('Comment').setup {
        pre_hook = pre_hook,
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
