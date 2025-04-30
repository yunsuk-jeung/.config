return {
  'L3MON4D3/LuaSnip',
  version = 'v2.*',
  dependencies = { 'rafamadriz/friendly-snippets' },
  config = function()
    require('luasnip.loaders.from_vscode').lazy_load()

    local ls = require 'luasnip'
    local extras = require 'luasnip.extras'

    ls.filetype_extend('javascript', { 'javascriptreact' })
    ls.filetype_extend('javascript', { 'typescript' })
    ls.filetype_extend('javascript', { 'typescriptreact' })

    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local rep = extras.rep

    ls.add_snippets('typescriptreact', {
      s('sfc', {
        t 'const ',
        i(1, 'ComponentName'),
        t ' = (',
        i(2),
        t ') => {',
        t { '', '\treturn (<>' },
        rep(1),
        t { '</>);', '};', '', 'export default ' },
        rep(1),
        t ';',
      }),
    })
    ls.add_snippets('go', {
      s('errnil', {
        t { 'if err != nil {', '\t' },
        i(1, 'check err'),
        t { '', '}' },
      }),
    })
    ls.add_snippets('go', {
      s('errasg', {
        t { 'if err := ' },
        i(1, 'asign err'),
        t { '; err != nil {', '\t' },
        i(2, 'check err'),
        t { '', '}' },
      }),
    })
    ls.add_snippets('go', {
      s('querystring', {
        t { 'query := `', '\t' },
        i(1, 'query'),
        t { '\t', '`' },
      }),
    })
    vim.keymap.set('v', 'p', function()
      if ls.in_snippet() then
        vim.api.nvim_feedkeys('p', 'n', false)
      else
        vim.api.nvim_feedkeys('"_dP', 'n', false)
      end
    end, { noremap = true, silent = true })
  end,
}
