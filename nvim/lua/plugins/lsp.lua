return {
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    -- event = 'VeryLazy',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- -- Useful status updates for LSP.
      -- -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      -- { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      require('mason').setup {
        registries = {
          'github:mason-org/mason-registry',
          'github:crashdummyy/mason-registry',
        },
        build = function()
          vim.cmd 'MasonInstall roslyn' -- Mason을 통해 roslyn 설치
          vim.cmd 'MasonInstall rzls'
        end,
      }
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- vtsls = {},
        ts_ls = {},
        -- ts_ls = {
        --   root_dir = require('lspconfig.util').root_pattern 'tsconfig.sjon',
        --   filetypes = { 'typescript', 'typescriptreact', 'tsx', 'javascript' },
        -- }, -- tsserver is deprecated
        -- vtsls = {},
        emmet_ls = {},
        -- eslint_d = {
        --   root_dir = require('lspconfig.util').root_pattern('eslint.config.js', '.git'),
        --   filetypes = { 'typescript', 'typescriptreact', 'tsx', 'javascript', 'javascriptreact' },
        -- },
        html = { filetypes = { 'html', 'twig', 'hbs' } },
        cssls = {},
        tailwindcss = { filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' } },
        prismals = {},
        dockerls = {},
        -- sqlls = {
        --   -- root_dir = function()
        --   --   return vim.loop.cwd()
        --   -- end,
        -- },
        jsonls = {},
        yamlls = {},
        -- omnisharp = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              runtime = { version = 'LuaJIT' },
              workspace = {
                checkThirdParty = false,
                library = {
                  '${3rd}/luv/library',
                  unpack(vim.api.nvim_get_runtime_file('', true)),
                },
              },
              diagnostics = { disable = { 'missing-fields' } },
              format = {
                enable = false,
              },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              staticcheck = true,
              analyses = {
                unusedparams = true, -- ???? ??
                unusedwrite = true,
                nilness = true,
                shadow = true,
                fieldalignment = false, -- ??? ?? ??
              },
              codelenses = {
                gc_details = true,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              semanticTokens = true,
            },
          },
          flags = {
            debounce_text_changes = 150,
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = require 'plugins.lspcapabilities'
            server.on_attach = require 'plugins.lspattach'
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  {
    'jay-babu/mason-null-ls.nvim',
    dependencies = {
      'nvimtools/none-ls.nvim',
      'williamboman/mason.nvim',
    },
    config = function()
      require('mason-null-ls').setup {
        ensure_installed = { 'sqlfluff' },
        automatic_installation = true,
      }

      local null_ls = require 'null-ls'
      null_ls.setup {
        sources = {
          null_ls.builtins.diagnostics.sqlfluff,
          -- null_ls.builtins.diagnostics.sqlfluff.with {
          --   extra_args = { '--dialect', 'postgres' }, -- ??? SQL dialect? ??? ?
          -- },
          null_ls.builtins.formatting.sqlfluff,
        },
        on_attach = require 'plugins.lspattach',
      }
    end,
  },
}
