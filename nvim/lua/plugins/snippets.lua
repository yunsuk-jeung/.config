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
  end,
}
