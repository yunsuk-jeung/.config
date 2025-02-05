return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  -- event = 'VeryLazy',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', opts = {} },

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
      ts_ls = {
        root_dir = require('lspconfig.util').root_pattern 'tsconfig.sjon',
        filetypes = { 'typescript', 'typescriptreact', 'tsx', 'javascript' },
      }, -- tsserver is deprecated
      eslint = {
        root_dir = require('lspconfig.util').root_pattern('eslint.config.js', '.git'),
        filetypes = { 'typescript', 'typescriptreact', 'tsx', 'javascript' },
      },
      emmet_ls = {--[[  filetypes = { 'typescript', 'typescriptreact', 'tsx', 'javascript' } ]]
      },
      html = { filetypes = { 'html', 'twig', 'hbs' } },

      cssls = {},
      tailwindcss = { filetypes = { 'javascript, javascriptreact', 'typescript', 'typescriptreact' } },
      prismals = {},
      dockerls = {},
      sqlls = {},
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
}
