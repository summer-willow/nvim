return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  -- lazy = false, -- by stc

  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    -- Mason must be loaded before its dependents so we need to set it up here.
    -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
    {
      'mason-org/mason.nvim',
      ---@module 'mason.settings'
      ---@type MasonSettings
      ---@diagnostic disable-next-line: missing-fields
      opts = {},
    },
    -- Maps LSP server names between nvim-lspconfig and Mason package names.
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    -- Brief aside: **What is LSP?**
    --
    -- LSP is an initialism you've probably heard, but might not understand what it is.
    --
    -- LSP stands for Language Server Protocol. It's a protocol that helps editors
    -- and language tooling communicate in a standardized fashion.
    --
    -- In general, you have a "server" which is some tool built to understand a particular
    -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
    -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
    -- processes that communicate with some "client" - in this case, Neovim!
    --
    -- LSP provides Neovim with features like:
    --  - Go to definition
    --  - Find references
    --  - Autocompletion
    --  - Symbol Search
    --  - and more!
    --
    -- Thus, Language Servers are external tools that must be installed separately from
    -- Neovim. This is where `mason` and related plugins come into play.
    --
    -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
    -- and elegantly composed help section, `:help lsp-vs-treesitter`

    --  This function gets run when an LSP attaches to a particular buffer.
    --    That is to say, every time a new file is opened that is associated with
    --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --    function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/documentHighlight', event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client:supports_method('textDocument/inlayHint', event.buf) then
          map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --  See `:help lsp-config` for information about keys and how to configure
    --  -----------------
    --  by stc
    --  lsp server를 설치하기 위해선,
    --  가장 좋은 위치는 local servers = { ... } 테이블 안에 
    --  빈 테이블({}) 형태로 추가해 두면, 
    --  아래쪽의 ensure_installed와 mason-tool-installer 설정에 의해 
    --  Neovim을 켰을 때 자동으로 설치되고 활성화까지 매끄럽게 진행됩니다.
    --  by stc, end
    --  -----------------
    ---@type table<string, vim.lsp.Config>
    local servers = {
      -- clangd = {},
      -- gopls = {},
      -- pyright = {},
      -- rust_analyzer = {},
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`ts_ls`) will work just fine
      -- ts_ls = {},

      stylua = {}, -- Used to format Lua code

      -- Special Lua Config, as recommended by neovim help docs
      lua_ls = {
        on_init = function(client)
          client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
              path = { 'lua/?.lua', 'lua/?/init.lua' },
            },
            workspace = {
              checkThirdParty = false,
              -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
              --  See https://github.com/neovim/nvim-lspconfig/issues/3189
              library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                '${3rd}/luv/library',
                '${3rd}/busted/library',
              }),
            },
          })
        end,
        ---@type lspconfig.settings.lua_ls
        settings = {
          Lua = {
            format = { enable = false }, -- Disable formatting (formatting is done by stylua)
          },
        },
      },

      -- ----------
      -- by stc
      -- 여기에 다른 서버 추가
      -- by stc, end
      -- ----------

      -- ----------
      -- by stc
      -- markdown server: marksman 추가
      marksman = {},
      -- by stc, end
      -- ----------

    } -- servers 테이블 끝

    -- Ensure the servers and tools above are installed
    --
    -- To check the current status of installed tools and/or manually install
    -- other tools, you can run
    --    :Mason
    --
    -- You can press `g?` for help in this menu.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      -- You can add other tools here that you want Mason to install
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    -- ==================================================
    -- by stc
    -- blink.cmp  ==>   nvim-cmp
    --
    -- kickstart.nvim에서 자동완서기능을 위해 기본적으로 설정된
    -- blink.cmp를 nvim-cmp로 바꿨을 때,
    -- capabilities 변수가 nvim-cmp를 지원하도록 설정하기
    --
    -- cf) 복구할 때: 나중에 다시 `blink.cmp`로 돌아가고 싶다면, 이 뭉치 코드만 찾아 지우거나 주석 처리하면 됩니다.
    --
    -- cf) Lua 언어는 위에서 아래로 코드를 읽어 내려갑니다. 
    -- ----------------------------------------

    -- capabilities 변수가 nvim-cmp를 지원하도록 설정 하는 구성 순서:
    --
    -- 1.  서버 목록(`servers`) 먼저 정의하고,
    -- 준비 단계 (servers 테이블): 어떤 서버를 쓸지 목록을 먼저 만듭니다. (이때까지는 capabilities가 주입되지 않은 상태)
    -- 서버 목록 정의 (기존 kickstart 코드)
    -- ervers 테이블 설정
        -- local servers = {
        --   lua_ls = { ... },
        --   -- 여기에 추가한 다른 서버들...
        -- }
        -- 위에서, kickstart.nvim의 기본 코드에 의해 이미 설정됨
    --
    -- 2. 능력치(`capabilities`)를 만든 뒤,
    -- 생성 단계 (local capabilities): nvim-cmp용 명세서를 새로 만듭니다.
    --
    -- 3. 모든 서버 설정에 nvim-cmp용 capabilities 주입
    -- 결합 단계 (첫 번째 for 루프): 준비된 servers 목록을 하나씩 꺼내서 방금 만든 명세서(capabilities)를 합칩니다(Merge).
    -- 여기서 vim.tbl_deep_extend를 쓰기 때문에, 기존 lua_ls 설정은 그대로 유지되면서 명세서만 추가됩니다.
    --
    -- 4. 최종 서버 활성화 
    -- 실행 단계 (두 번째 for 루프): 명세서가 완벽히 주입된 최종 servers를 Neovim에 등록하고 활성화합니다.
        -- 루프(Loop, for ~ do ~ end)를 돌면서 두 가지를 합쳐서 최종적으로 활성화 합니다.
        -- for name, server in pairs(servers) do
        --   vim.lsp.config(name, server)
        --   vim.lsp.enable(name)
        -- end
        -- 이미 kickstart.nvim 코드에 있믐
    --
    -- ==> 따라서, 위의 2, 3 번의 설정이 필요함 !

    -- ----------------------------------------

    -- 구성단계 2 번 설정
    -- nvim-cmp 지원을 위한 capabilities 생성
    --
    -- cf) 💡 blink.cmp에서는 이 부분이 필요 없는 이유
    -- blink.cmp는 nvim-cmp와 설정 방식이 다릅니다. nvim-cmp는 보통 LSP 설정 파일 내부에서 각 서버마다 capabilities를 명시적으로 주입해 주어야 하지만, blink.cmp는 자체 설정(blink.cmp 플러그인 설정 파일)에서 LSP 설정을 알아서 확장(extend)하는 구조를 지원합니다.
    --
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- -- nvim-cmp를 설치했다면 이 패키지를 통해 '나 nvim-cmp 쓴다'는 명세를 추가함
    -- local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    -- if has_cmp then
    --   capabilities = vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
    --   -- merge: 여러 설정값을 하나로 합치는 과정. `vim.tbl_deep_extend` 함수가 이 역할을 수행
    -- end

    -- 구성단계 3 번 설정
    -- 모든 서버 설정에 nvim-cmp용 capabilities 주입
    -- iterative: 순차적으로 하나씩 처리하는 방식. `for` 루프를 통해 여러 LSP 서버를 하나씩 설정하는 것이 이에 해당
    --
    -- for name, config in pairs(servers) do
    --   -- 기존 config에 위에서 만든 capabilities를 합칩니다.
    --   servers[name] = vim.tbl_deep_extend('force', {
    --     capabilities = capabilities, -- 여기서 capabilities 주입!
    --   }, config)
    -- end

    -- by stc, end
    -- ==================================================

    -- 4. 서버 활성화
    for name, server in pairs(servers) do
      vim.lsp.config(name, server)
      vim.lsp.enable(name)
    end
  end,
}




-- vim: set foldmethod=marker foldmarker={{{,}}}:
