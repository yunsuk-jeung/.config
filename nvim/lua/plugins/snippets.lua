return {
  'L3MON4D3/LuaSnip',
  -- dependencies = { 'rafamadriz/friendly-snippets' },
  config = function()
    local ls = require 'luasnip'
    ls.filetype_extend('javascript', { 'javascriptreact' })
    ls.filetype_extend('javascript', { 'html' })
    ls.filetype_extend('typescript', { 'javascript' })
    ls.filetype_extend('typescriptreact', { 'javascriptreact' })
    ls.filetype_extend('typescript', { 'typescriptreact' })
    require('luasnip.loaders.from_vscode').lazy_load()

    local s = ls.snippet
    local i = ls.insert_node
    local t = ls.text_node
    ls.add_snippets('javascriptreact', {
      s('sfc', {
        t 'const ',
        i(0, 'ComponentName'),
        t ' = (',
        i(1, 'props'),
        t ') => {',
        t { '', '\treturn (' },
        i(2),
        t { ');', '};', '', 'export default ' },
        t ';',
      }),
    })
  end,
}
