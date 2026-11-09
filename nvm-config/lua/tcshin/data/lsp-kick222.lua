
  -- LSP Plugins
return  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    -- (1)
    -- 필요한 dependencies
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },

    config = function()

      -- (2)
      -- 키뱁핑 부분
      -- keymapping for lsp .... on 'LspAttach' event

      -- (3)
      -- diagnostic config 부분

      --  (4)
      --  compabilities 설정
      --  communicate capabilities with blink.comp
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- (5)
      -- 설치할 서버 열거
      -- 필요하면 각각의 서버에 필요한 설정 세팅
      local servers = {
        clangd = {},
        pyright = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      -- (6)
      -- 설치할 tool 열거
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })

      -- (7) 
      -- 실제 설치하는 부분: mason-tool-installer 이용
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- (8)
      -- 각 서버들의 config 세팅
      -- 기본적으로 community 설정 이용 
      -- 그리고 위에서 설치할 서버(servers)에서 설정한 각각의 서버에 대한 설정을 적용
      -- 모든 서버에 capabilities 적용
      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
