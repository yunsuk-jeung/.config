return {
  'karb94/neoscroll.nvim',
  event = 'VeryLazy',
  opts = {
    duration_multiplier = 0.3,
    mappings = (function()
      local mappings = { -- Keys to be mapped to their corresponding default scrolling animation
        '<C-u>',
        '<C-d>',
        '<C-b>',
        '<C-y>',
        'zt',
        'zz',
        'zb',
      }

      if not vim.g.vscode then
        table.insert(mappings, 4, '<C-f>')
      end

      return mappings
    end)(),
  },
}
