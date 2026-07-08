return { -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- new rewrite; see :help nvim-treesitter
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      local nts = require 'nvim-treesitter'

      local ensure_installed = {
        'lua',
        'python',
        'javascript',
        'typescript',
        'vimdoc',
        'vim',
        'regex',
        'terraform',
        'sql',
        'dockerfile',
        'toml',
        'json',
        'java',
        'groovy',
        'go',
        'gitignore',
        'graphql',
        'yaml',
        'make',
        'cmake',
        'markdown',
        'markdown_inline',
        'bash',
        'tsx',
        'css',
        'html',
        'c_sharp',
        'cpp',
        'prisma',
      }

      -- Install any missing parsers (async, non-blocking).
      local installed = nts.get_installed()
      local to_install = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, ensure_installed)
      if #to_install > 0 then
        nts.install(to_install):await(function()
          -- Enable highlighting on already-open buffers once install finishes.
          vim.schedule(function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= '' then
                pcall(vim.treesitter.start, buf)
              end
            end
          end)
        end)
      end

      -- Filetypes where treesitter indentation stays disabled.
      local no_indent = {
        ruby = true,
        html = true,
        css = true,
        cpp = true,
        go = true,
        markdown = true,
      }

      -- Highlight + indent are now enabled per-buffer (main branch removed the
      -- `highlight`/`indent` modules). See `:help treesitter-highlight`.
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf = args.buf
          local ft = vim.bo[buf].filetype

          -- Highlighting: no-op (pcall) if the parser isn't installed yet.
          if not pcall(vim.treesitter.start, buf) then
            return
          end

          -- Some languages (ruby) still rely on vim's regex highlighting.
          if ft == 'ruby' then
            vim.bo[buf].syntax = 'on'
          end

          -- Treesitter-based indentation (experimental).
          if not no_indent[ft] then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      vim.g.skip_ts_context_commentstring_module = true
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }
    end,
  },
}
