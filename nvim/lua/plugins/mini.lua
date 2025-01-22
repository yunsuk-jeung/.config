return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    require('mini.icons').setup()
    require('mini.jump').setup()
    require('mini.jump2d').setup()

    require('mini.move').setup {
      mappings = {
        down = '<M-s>', -- Shift + j
        up = '<M-d>', -- Shift + k
        line_down = '<M-s>',
        line_up = '<M-d>',
      },
    }
    -- require('mini.surround').setup()
    require('mini.snippets').setup()
    require('mini.cursorword').setup()

    require('mini.files').setup()
    vim.keymap.set('n', '<C-e>', function()
      require('mini.files').open()
    end, { noremap = true, silent = true })
  end,
}
