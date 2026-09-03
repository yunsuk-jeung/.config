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
      -- NOTE: mason.setup 에는 `build` 옵션이 없다. roslyn/rzls 설치는
      -- 아래 mason-tool-installer 의 ensure_installed 에서 처리한다.
      require('mason').setup {
        registries = {
          'github:mason-org/mason-registry',
          'github:crashdummyy/mason-registry',
        },
      }

      -- mason-lspconfig: 설치할 서버 목록 관리
      local servers = {
        clangd = {
          cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--header-insertion=iwyu',
            '--completion-style=detailed',
          },
        },
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

      -- mason-lspconfig v2: ensure_installed 는 lspconfig 서버명을 그대로 받는다.
      -- 서버 활성화(vim.lsp.enable)는 아래에서 직접 하므로 automatic_enable 은 끈다.
      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_enable = false,
      }

      -- mason-tool-installer: LSP 가 아닌 포매터/린터 등 추가 툴
      local has_dotnet = function()
        return vim.fn.executable 'dotnet' == 1
      end

      require('mason-tool-installer').setup {
        ensure_installed = {
          'stylua', -- lua formatter (conform)
          'prettier', -- js/ts/yaml/prisma formatter (conform)
          -- NOTE: black / sqlfluff 는 mason 이 python>=3.10 을 요구하는데
          -- PATH 의 python 이 3.9 라서 제외했다. `brew install python` 후 되살릴 것.
          -- 'black', -- python formatter (conform)
          -- 'sqlfluff', -- sql linter/formatter (none-ls)
          { 'csharpier', condition = has_dotnet }, -- cs formatter (conform)
          { 'roslyn', condition = has_dotnet }, -- roslyn.nvim
          { 'rzls', condition = has_dotnet }, -- roslyn.nvim (razor)
        },
        run_on_start = true,
      }

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local on_attach = require 'plugins.lspattach'

      -- Neovim 0.11+ API
      if vim.lsp.config and vim.lsp.enable then
        for server_name, server_opts in pairs(servers) do
          server_opts = vim.tbl_deep_extend('force', {
            capabilities = capabilities,
            on_attach = on_attach,
          }, server_opts or {})
          vim.lsp.config(server_name, server_opts)
          vim.lsp.enable(server_name)
        end
      else
        -- Backward compatibility for older Neovim versions
        local lspconfig = require 'lspconfig'
        for server_name, server_opts in pairs(servers) do
          server_opts = vim.tbl_deep_extend('force', {
            capabilities = capabilities,
            on_attach = on_attach,
          }, server_opts or {})
          lspconfig[server_name].setup(server_opts)
        end
      end
    end,
  },
  {
    'nvimtools/none-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local null_ls = require 'null-ls'
      null_ls.setup {
        sources = {
          -- NOTE: sqlfluff 는 python>=3.10 이 필요해 현재 설치 대상에서 제외.
          -- `brew install python` 후 lsp.lua 의 ensure_installed 와 함께 되살릴 것.
          -- null_ls.builtins.diagnostics.sqlfluff,
          -- null_ls.builtins.formatting.sqlfluff,
        },
        on_attach = require 'plugins.lspattach',
      }
    end,
  },
}
