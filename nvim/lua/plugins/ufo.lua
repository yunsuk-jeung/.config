return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      -- 기본 폴딩 설정
      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- 폴딩 관련 단축키 설정
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      for i = 0, 9 do
        vim.keymap.set('n', 'zf' .. i, function()
          if i == 0 then
            vim.o.foldlevel = 99
            print 'Fold Level set to 99'
          else
            vim.o.foldlevel = i
            print('Fold Level set to ' .. i)
          end
        end, { noremap = true, silent = true })
      end

      require('ufo').setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' } -- Treesitter를 우선 사용
        end,
      }
    end,
  },
}
