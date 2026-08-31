return { -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function(_, opts)
      local ts = require 'nvim-treesitter'
      ts.setup {
        install_dir = opts.install_dir,
      }

      if opts.ensure_installed and #opts.ensure_installed > 0 then
        pcall(ts.install, opts.ensure_installed)
      end

      if opts.auto_install then
        local pending_install = {}
        local parsers = require 'nvim-treesitter.parsers'
        vim.api.nvim_create_autocmd('FileType', {
          group = vim.api.nvim_create_augroup('user-treesitter-auto-install', { clear = true }),
          callback = function(args)
            local ft = vim.bo[args.buf].filetype
            if ft == '' then
              return
            end

            local lang = vim.treesitter.language.get_lang(ft) or ft
            if not parsers[lang] then
              return
            end
            if pending_install[lang] then
              return
            end

            local installed = ts.get_installed()
            if not vim.list_contains(installed, lang) then
              pending_install[lang] = true
              pcall(ts.install, lang)
              pending_install[lang] = nil
            end
          end,
        })
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('user-treesitter-highlight', { clear = true }),
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      local ok = pcall(vim.treesitter.query.get, 'vim', 'highlights')
      if not ok then
        local query_files = vim.api.nvim_get_runtime_file('queries/vim/highlights.scm', false)
        local query_path = query_files[1]
        if query_path then
          local parser_info = vim.treesitter.language.inspect 'vim'
          local parser_symbols = parser_info and parser_info.symbols or {}
          local lines = vim.fn.readfile(query_path)
          local filtered_lines = {}
          for _, line in ipairs(lines) do
            local token = line:match '^%s*"(.-)"%s*$'
            if token then
              local symbol = string.format('"%s"', token)
              if parser_symbols[symbol] ~= nil then
                table.insert(filtered_lines, line)
              end
            else
              table.insert(filtered_lines, line)
            end
          end
          vim.treesitter.query.set('vim', 'highlights', table.concat(filtered_lines, '\n'))
          local query_still_invalid = not pcall(vim.treesitter.query.get, 'vim', 'highlights')
          if query_still_invalid then
            vim.treesitter.query.set('vim', 'highlights', '')
          end
        end
      end
    end,
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      install_dir = vim.fn.stdpath 'data' .. '/site',
      ensure_installed = {
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
        'xml',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby', 'html', 'css', 'cpp', 'go', 'markdown' } },
      -- indent = { enable = false },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
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
