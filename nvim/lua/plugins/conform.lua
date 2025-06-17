return {
  'stevearc/conform.nvim',
  opts = {},
  config = function()
    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'black' },
        rust = { 'rustfmt', lsp_format = 'fallback' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        yaml = { 'prettier' },
        cs = { 'csharpier' },
        -- markdown = { 'prettier' },
        -- html = { 'prettier' },
        prisma = { 'prettier' },
      },
      formatters = {
        black = {
          prepend_args = { '--skip-string-normalization' },
        },
      },
      default_format_opts = {
        lsp_format = 'fallback',
      },
      -- -- If this is set, Conform will run the formatter on save.
      -- -- It will pass the table to conform.format().
      -- -- This can also be a function that returns the table.
      -- format_on_save = {
      --   -- I recommend these options. See :help conform.format for details.
      --   lsp_format = 'fallback',
      --   timeout_ms = 500,
      -- },
      format_after_save = {
        lsp_format = 'fallback',
      },
    }
  end,
}
