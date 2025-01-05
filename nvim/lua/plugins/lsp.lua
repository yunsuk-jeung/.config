return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
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
    -- Define a global variable to control diagnostic display
    _G.diagnostics_enabled = true

    -- Define a global function to toggle diagnostics
    _G.toggle_diagnostics = function()
      _G.diagnostics_enabled = not _G.diagnostics_enabled
      if _G.diagnostics_enabled then
        print 'Diagnostics enabled'
      else
        print 'Diagnostics disabled'
      end
    end
    -- Create an autocmd for CursorHold, but check the toggle
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = vim.api.nvim_create_augroup('float_diagnostic', { clear = true }),
      callback = function()
        if _G.diagnostics_enabled then
          vim.diagnostic.open_float(nil, { focus = false })
        end
      end,
    })

    -- Map a key to toggle diagnostics
    vim.api.nvim_set_keymap('n', '<leader>gw', '<cmd>lua toggle_diagnostics()<CR>', { noremap = true, silent = true })
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
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`tsserver`) will work just fine
      ts_ls = {
        root_dir = require('lspconfig.util').root_pattern 'tsconfig.sjon',
        filetypes = { 'typescript', 'typescriptreact', 'tsx', 'javascript' },
      }, -- tsserver is deprecated
      eslint = {
        root_dir = require('lspconfig.util').root_pattern('eslint.config.js', '.git'),
        filetypes = { 'typescript', 'typescriptreact', 'tsx', 'javascript' },
      },
      ruff = {},
      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              pyflakes = { enabled = false },
              pycodestyle = { enabled = false },
              autopep8 = { enabled = false },
              yapf = { enabled = false },
              mccabe = { enabled = false },
              pylsp_mypy = { enabled = false },
              pylsp_black = { enabled = false },
              pylsp_isort = { enabled = false },
            },
          },
        },
      },
      html = { filetypes = { 'html', 'twig', 'hbs' } },
      cssls = {},
      tailwindcss = {},
      dockerls = {},
      sqlls = {},
      terraformls = {},
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
