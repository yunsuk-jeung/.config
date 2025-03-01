return {
  {
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
      -- vim.cmd.colorscheme 'kanagawa'
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    -- priority = 1000,

    config = function()
      require('catppuccin').setup {
        flavour = 'auto', -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = true, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window
          shade = 'dark',
          percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { 'italic' }, -- Change the style of comments
          conditionals = { 'italic' },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
          -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {},
        custom_highlights = function(colors)
          return {
            MiniCursorword = { bg = colors.surface1, underline = false },
          }
        end,
        default_integrations = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = {
            enabled = true,
            indentscope_color = '',
          },
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      }
      -- Load the colorscheme
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require('tokyonight').setup {
        transparent = true,
      }
      -- vim.cmd.colorscheme 'tokyonight'
    end,
  },
}
