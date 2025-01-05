-- Core configuration
require 'core.options'
require 'core.keymaps'

-- Lazy.nvim setup
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

if vim.g.vscode then
  return {}
end

-- Plugin setup using lazy.nvim
require('lazy').setup {
  require 'plugins.neotree',
  require 'plugins.colortheme',
  require 'plugins.bufferline',
  require 'plugins.lualine',
  require 'plugins.treesitter',
  require 'plugins.telescope',
  require 'plugins.lsp',
  require 'plugins.autocompletion',
  -- require 'plugins.none-ls',
  require 'plugins.conform',
  require 'plugins.gitsigns',
  require 'plugins.indent-blankline',
  require 'plugins.comment',
  require 'plugins.misc',
  require 'plugins.lazygit',
  -- require 'plugins.auto-session',
  require 'plugins.ufo',
  require 'plugins.cmake-tools',
  require 'plugins.rosyln',
  require 'plugins.obsidian',
  require 'plugins.noice',
}
