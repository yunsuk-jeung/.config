return {
  'kndndrj/nvim-dbee',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require('dbee').install()
  end,
  config = function()
    require('dbee').setup(--[[optional config]])
    -- local nmap = function(keys, func, desc)
    --   if desc then
    --     desc = 'LSP: ' .. desc
    --   end
    --
    --   vim.keymap.set('n', keys, func, { desc = desc })
    -- end
    -- nmap('ls', require('dbee').open, '[D]bee [O]pen')
    -- nmap('lc', require('dbee').close, '[D]bee [C]pen')
  end,
  vim.keymap.set('n', '<leader>la', function()
    require('dbee').open()
  end, { desc = 'Dbee Open', noremap = true, silent = true }),
  vim.keymap.set('n', '<leader>lb', function()
    require('dbee').close()
  end, { desc = 'Dbee Close', noremap = true, silent = true }),
}
