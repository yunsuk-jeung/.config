return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- mason: LSP 서버 설치만 담당
      require('mason').setup {
        registries = {
          'github:mason-org/mason-registry',
          'github:crashdummyy/mason-registry',
        },
        build = function()
          vim.cmd 'MasonInstall roslyn'
          vim.cmd 'MasonInstall rzls'
        end,
      }

      -- mason-lspconfig: 설치할 서버 목록 관리
      local servers = {
        basedpyright = {},
        ts_ls = {},
        emmet_ls = {},
        html = { filetypes = { 'html', 'twig', 'hbs' } },
        cssls = {},
        tailwindcss = { filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' } },
        prismals = {},
        dockerls = {},
        jsonls = {},
        yamlls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              runtime = { version = 'LuaJIT' },
              workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file('', true) },
              diagnostics = { disable = { 'missing-fields' } },
              format = { enable = false },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              staticcheck = true,
              analyses = {
                unusedparams = true,
                unusedwrite = true,
                nilness = true,
                shadow = true,
                fieldalignment = false,
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
          flags = { debounce_text_changes = 150 },
        },
      }

      -- -- mason-lspconfig: 설치할 서버 목록만 지정
      -- require('mason-lspconfig').setup {
      --   ensure_installed = vim.tbl_keys(servers or {}),
      -- }
      --
      -- -- mason-tool-installer: 추가 툴 설치 (필요시)
      -- require('mason-tool-installer').setup {
      --   ensure_installed = vim.tbl_keys(servers or {}),
      -- }

      -- nvim-lspconfig: 실제 서버 설정(on_attach, capabilities 등 직접 처리)
      local lspconfig = require 'lspconfig'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local on_attach = require 'plugins.lspattach'

      for server_name, server_opts in pairs(servers) do
        server_opts = vim.tbl_deep_extend('force', {
          capabilities = capabilities,
          on_attach = on_attach,
        }, server_opts or {})
        lspconfig[server_name].setup(server_opts)
      end
    end,
  },
  -- {
  --   'jay-babu/mason-null-ls.nvim',
  --   dependencies = {
  'nvimtools/none-ls.nvim',
  --   'williamboman/mason.nvim',
  -- },
  config = function()
    -- require('mason-null-ls').setup {
    --   ensure_installed = { 'sqlfluff' },
    --   automatic_installation = true,
    -- }
    local null_ls = require 'null-ls'
    null_ls.setup {
      sources = {
        null_ls.builtins.diagnostics.sqlfluff,
        null_ls.builtins.formatting.sqlfluff,
      },
      on_attach = require 'plugins.lspattach',
    }
  end,
  -- },
}
