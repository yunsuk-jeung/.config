return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    require('mini.icons').setup()
    require('mini.jump').setup()
    -- require('mini.jump2d').setup()

    require('mini.move').setup {
      mappings = {
        down = '<M-s>', -- Shift + j
        up = '<M-d>', -- Shift + k
        line_down = '<M-s>',
        line_up = '<M-d>',
      },
    }
    -- require('mini.surround').setup()
    local gen_loader = require('mini.snippets').gen_loader
    require('mini.snippets').setup {
      snippets = {
        -- Load custom file with global snippets first (adjust for Windows)
        gen_loader.from_file '~/.config/nvim/snippets/global.json',

        -- Load snippets based on current language by reading files from
        -- "snippets/" subdirectories from 'runtimepath' directories.
        gen_loader.from_lang(),
      },
    }
    require('mini.cursorword').setup()
    require('mini.comment').setup {
      mappings = {
        comment_line = '<C-_>',
        comment_visual = '<C-_>',
      },
    }
    require('mini.statusline').setup {
      use_icons = vim.g.have_nerd_font,
      content = {
        active = function()
          local check_macro_recording = function()
            if vim.fn.reg_recording() ~= '' then
              return 'Recording @' .. vim.fn.reg_recording()
            else
              return ''
            end
          end

          local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
          local git = MiniStatusline.section_git { trunc_width = 40 }
          local diff = MiniStatusline.section_diff { trunc_width = 75 }
          local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
          -- local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
          local filename = MiniStatusline.section_filename { trunc_width = 140 }
          local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
          local location = MiniStatusline.section_location { trunc_width = 200 }
          local search = MiniStatusline.section_searchcount { trunc_width = 75 }
          local macro = check_macro_recording()

          return MiniStatusline.combine_groups {
            { hl = mode_hl, strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFilename', strings = { macro } },
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = mode_hl, strings = { search, location } },
          }
        end,

        inactive = function()
          local filename = vim.fn.expand '%:~:.' -- ✅ 비활성화된 윈도우: 상대 경로 유지
          return MiniStatusline.combine_groups {
            { hl = 'MiniStatuslineFilename', strings = { filename } },
          }
        end,
      },
    }
    require('mini.tabline').setup()
    require('mini.files').setup()
    vim.keymap.set('n', '<C-e>', function()
      require('mini.files').open()
    end, { noremap = true, silent = true })
  end,
}
