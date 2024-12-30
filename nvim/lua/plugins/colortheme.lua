return {
  'rebelot/kanagawa.nvim',
  config = function()
    require('kanagawa').setup {
      compile = false, -- Enable compiling the colorscheme
      undercurl = true, -- Enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = true, -- Do not set background color
      dimInactive = false, -- Dim inactive window `:h hl-NormalNC`
      terminalColors = true, -- Define vim.g.terminal_color_{0,17}
      colors = { -- Add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      overrides = function(colors) -- Add/modify highlights
        return {}
      end,
      theme = 'wave', -- Load "wave" theme when 'background' option is not set
      background = { -- Map the value of 'background' option to a theme
        dark = 'wave', -- Try "dragon" !
        light = 'lotus',
      },
    }

    -- Load the colorscheme
    vim.cmd 'colorscheme kanagawa'
  end,
}
