--
-- --------------------------------------------------------
-- --------------------------------------------------------
-- --------------------------------------------------------
-- --------------------------------------------------------
-- LSP
--
-- [Installation]
-- language server 설치
--
-- --------------------------------------
-- 'mason-org/mason.nvim' :   -- 기본 installer
-- mason.nvim: :Mason 을 이용해서 수동으로 필요한 언어 서버 자체를 내 컴퓨터에 설치
-- mason을 이용해서 필요한 language server 를 설치한다. 
--
-- --------------------------------------
-- 'mason-org/mason-lspconfig.nvim', -- server 전용 installer
--
-- % Actualize LSP  ( using  vim.lsp.config() and  vim.lsp.enable() )
--
--
-- 오직 LSP 서버만 설치할 수 있습니다. lua_ls, pyright 같은 서버 이름만 인식합니다.
--
-- 설치 편의를 위해, mason를 직접 이용하지 않고, mason-lspconfig.nvim을 이용해 자동으로 설치되게 한다. 
-- (i) automatically install, and (ii) automatically enable (vim.lsp.enable()) installed servers
--   cf)
--
-- 기본적으로 Mason 내부 패키지 이름(예: lua-language-server)을 사용해야 합니다. 하지만 mason-lspconfig가 설치되어 있다면 lspconfig 방식의 이름도(lua_ls) 인식하도록 연동됩니다. 
--
-- mason-lspconfig.nvim : 다리 연할, mason으로 설치한 서버들을 nvim의 lspconfi가 인식할 수 있도록 연결해 주며, 자동 설치 기능(ensure_installed)을 제공
--
--
--
--
-- --------------------------------------
-- 'WhoIsSethDaniel/mason-tool-installer.nvim',  -- 통합(servers+3rd_party_tools) instalaler
-- Install and upgrade third party tools automatically
-- mason-tool-installer.nvim은 Neovim에서 mason.nvim을 통해 설치하는 다양한 도구(LSP, 린터, 포맷터 등)를 자동으로 설치하고 최신 상태로 유지해주는 플러그인
--
-- mason-tool-installer.nvim은 Neovim에서 mason.nvim을 통해 설치하는 다양한 도구(LSP, 린터, 포맷터 등)를 자동으로 설치하고 최신 상태로 유지해주는 플러그인입니다. 
--
-- 통합 관리: LSP 서버뿐만 아니라 null-ls나 nvim-lint, formatter.nvim에서 사용하는 린터와 포맷터도 하나의 리스트에서 통합 관리할 수 있습니다.
--
-- LSP는 물론이고, prettier(포맷터), eslint_d(린터), codelldb(디버거) 등 Mason이 지원하는 모든 도구를 한 번에 리스트에 넣어 설치할 수 있습니다. 
--
-- LSP 서버뿐만 아니라 null-ls나 nvim-lint, formatter.nvim에서 사용하는 린터와 포맷터도 하나의 리스트에서 통합 관리할 수 있습니다.
-- 간단히 말해, 
-- mason-lspconfig는 LSP 서버 전용이고, 
-- mason-tool-installer는 모든 도구(LSP, 린터, 포맷터, DAP)를 다루는 종합 관리자
-- 라고 보시면 됩니다. 
--
-- 사용자 설정: 사용자가 mason-tool-installer 설정 부분에 lua-language-server, pyright 등을 적어둡니다.
-- 설치 관리: mason-tool-installer가 실행되면서 mason.nvim을 통해 해당 도구들을 실제로 설치합니다.
--
-- mason-tool-installer.nvim에도 language server를 설치하는 기능이 포함되어 있으므로, 통합관리를 위해 mason-tool-installer.nvim에서 필요한 모든 것을 설치한다. (위의 mason-lspconfig.nvim은 아무것도 설치안함)
--
-- mason-lspconfig는 설치(ensure_installed)용이 아니라, Mason이 설치한 서버를 lspconfig와 부드럽게 연결(mapping)해주는 징검다리 역할로만 사용하고, 실제 설치 목록 관리는 mason-tool-installer로 일원화하는 것이 훨씬 깔끔합니다.
--
-- 추천 구성 전략 (Setup Strategy)
--
-- 1. mason.nvim: 기본 엔진 설치.
-- 2. mason-lspconfig.nvim: 서버와 lspconfig 간의 이름 매핑 및 자동 설정(handlers)을 위해 설치 (여기서 ensure_installed는 비워둡니다).
-- 3. mason-tool-installer.nvim: 여기서 LSP, 린터, 포맷터를 한꺼번에 리스트로 관리하여 설치.
--
-- 코드 예시 (Lua)
--
-- -- 1. Mason 기본 설정
-- require('mason').setup()
--
-- -- 2. lspconfig 연결 설정 (설치는 여기서 안 함)
-- require('mason-lspconfig').setup({
--     -- ensure_installed = {}, -- 여기는 비워둡니다.
-- })
--
-- -- 3. 통합 설치 관리 (여기서 한꺼번에!)
-- require('mason-tool-installer').setup({
--     ensure_installed = {
--         -- LSP 서버
--         'lua_ls',
--         'pyright',
--         -- 포맷터 & 린터 (lspconfig엔 없는 것들)
--         'stylua',
--         'prettier',
--         'eslint_d',
--         'shellcheck',
--     },
--     auto_update = true, -- 실행 시 자동 업데이트 원할 경우
-- })
--
-- 이 방식의 장점
-- 관리 일원화: ensure_installed 테이블 하나만 보면 내 개발 환경의 모든 도구를 한눈에 파악할 수 있습니다.
--
--
-- --------------------------------------
-- [configuration & actualization]
-- 'neovim/nvim-lspconfig',
-- Quickstart configs for Nvim LSP
-- 이 플러그인은 Mason이 설치한 서버 파일을 Neovim의 lspconfig가 인식할 수 있도록 다리 역할을 합니다.
--
-- # configuration of each server
--   "~/nvim-lspconfig"  -- from communtiy configuartion
-- 정 언어 서버의 설정을 담당합니다.
-- 일반적으로 nvim-lspconfig 설정 내의 ensure_installed 리스트에 설치하고 싶은 서버 이름을 적어두면, Neovim이 뜰 때 해당 서버들이 있는지 확인합니다.
-- 하지만 Kickstart 구성 방식에서는 이 역할을 mason-tool-installer라는 별도의 플러그인에 전적으로 위임합니다.
--
--
-- nvim-lspconfig: 설정 본체, nvim 내장 LSP 클라이언트를 각 언어 서버에 맞게 초기화하고, 정의 이동이나 심볼 검색 같은 기능을 활성화하는 코드가 들어감
--
--
-- --------------------------------------
-- -- Useful status updates for LSP.
-- { 'j-hui/fidget.nvim', opts = {} },
--
-- --------------------------------------
-- -- Allows extra capabilities provided by blink.cmp
-- 'saghen/blink.cmp', -- cmp(자동완성)  engine
-- -- cf) blink.cmp, nvim-cmp : 자동완성 엔진
--
--
--
-- -----------------------------------------------
-- LSP document: 
-- https://neovim.io/doc/user/lsp.html
--
-- These GLOBAL keymaps are created unconditionally when Nvim starts:
-- "gra" (Normal and Visual mode) is mapped to vim.lsp.buf.code_action()
-- "gri" is mapped to vim.lsp.buf.implementation()
-- "grn" is mapped to vim.lsp.buf.rename()
-- "grr" is mapped to vim.lsp.buf.references()
-- "grt" is mapped to vim.lsp.buf.type_definition()
-- "gO" is mapped to vim.lsp.buf.document_symbol()
-- CTRL-S (Insert mode) is mapped to vim.lsp.buf.signature_help()
-- "an" and "in" (Visual and Operator-pending mode) are mapped to outer and inner incremental selections, respectively, using vim.lsp.buf.selection_range()
-- -----------------------------------------------
--
--
-- --------------------------------------------------------
-- --------------------------------------------------------
-- --------------------------------------------------------
-- --------------------------------------------------------
--
--
--
--
--
--
--
-- [Completion]
-- "hrsh7th/cmp-nvim-lsp",
-- "antosha417/nvim-lsp-file-operations"
-- "folke/lazydev.nvim"
-- ===> ????
--
--
--
--
-- -----------------------------------------------
-- -----------------------------------------------

return {

  -- {
  --   -- -----------------------------------------------
  --   -- 'folke/lazydev.nvim',
  --   -- : Faster LuaLS setup for Neovim
  --   -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
  --   -- used for completion, annotations and signatures of Neovim apis
  --   --
  --   -- 단순히 경고(Warning)를 없애는 것을 넘어, Neovim 설정을 할 때 LSP가 **"이게 Neovim 내부 API인지, 아니면 그냥 일반 Lua 코드인지"**를 구별하게 해주는 역활 
  --   --
  --   -- cf)
  --   -- 오직 "Neovim 관련 개발"을 할 때만 필요함. (다른 곳에서는 안쓰임)
  --   --
  --   -- 전에는 vim API를 외우거나 문서를 뒤졌지만, 이제는 lazydev 덕분에 에디터 안에서 모든 API 명세와 설명을 즉시 확인할 수 있게 되었습니다.
  --   --
  --   -- Neovim 설정을 만지실 때 **"경고 줄이 사라지고, vim. 뒤에 엄청난 양의 추천 목록이 뜬다"**면 이 플러그인이 제 역할을 아주 잘 수행하고 있는 것입니다.
  --   --
  --   -- 이제 Neovim 설정 파일(init.lua)에서 vim.을 입력해 보세요. 수많은 함수 목록이 쏟아져 나올겁니다
  --   -- -----------------------------------------------
  --
  --   'folke/lazydev.nvim',
  --   ft = 'lua', -- Lua 파일에서만 이 플러그인을 활성화
  --   opts = {
  --     library = {
  --       -- Load luvit types when the `vim.uv` word is found
  --       -- 'vim.uv'라는 단어가 코드에 보이면, 저수준 라이브러리인 luv의 타입 정보도 불러옵니다.
  --       -- ${3rd}/luv/library: Neovim의 비동기 처리를 담당하는 luv 라이브러리의 정보를 연결합니다. 0.10 버전부터 vim.loop 대신 vim.uv를 쓰기로 했는데, 이를 위한 최신 설정입니다.
  --       { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  --     },
  --   },
  -- },



  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',

    dependencies = {
      -- { 'mason-org/mason.nvim', opts = {} },  -- 기본 installer
      {
        "mason-org/mason.nvim", -- 기본 installer
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      'mason-org/mason-lspconfig.nvim', -- server 전용 installer
      'WhoIsSethDaniel/mason-tool-installer.nvim',  -- 통합(servers+3rd_party_tools) instalaler
      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp', -- cmp(자동완성)  engine
      -- cf) blink.cmp, nvim-cmp : 자동완성 엔진


      -- 조치: dependencies 리스트 상단에 { 'folke/lazydev.nvim', ft = 'lua', opts = { ... } }를 추가하는 것을 권장합니다.
      { 'folke/lazydev.nvim',
        ft = 'lua', -- Lua 파일에서만 이 플러그인을 활성화
        opts = {
          library = {
            -- Load luvit types when the `vim.uv` word is found
            -- 'vim.uv'라는 단어가 코드에 보이면, 저수준 라이브러리인 luv의 타입 정보도 불러옵니다.
            -- ${3rd}/luv/library: Neovim의 비동기 처리를 담당하는 luv 라이브러리의 정보를 연결합니다. 0.10 버전부터 vim.loop 대신 vim.uv를 쓰기로 했는데, 이를 위한 최신 설정입니다.
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      },

    },

    config=function()

      -- ---------------------------------
      -- 설치할 language servers
      -- ---------------------------------
      local servers = {
        lua_ls ={   -- Lua server
          settings = {  -- 서버에 전달할 세부 설정(Configuration) 시작점
            Lua = {   -- "Lua 언어"에 대한 설정을 하겠다고 명시
              completion = {  -- 그 중에서도 "자동완성(Completion)" 기능을 튜닝합니다.
                callSnippet = 'Replace',  -- 함수 호출 시 괄호와 인자를 자동으로 채워주는 기능을 켭니다.
                -- {{{
                -- 'Replace'의 의미: 자동완성 팝업에서 선택한 텍스트가 단순히 '추가'되는 게 아니라, 함수 호출 구조(Snippet) 전체로 '교체(Replace)'된다는 뜻
                -- callSnippet='Replace': 함수 자동완성을 선택했을 때, 함수 이름 뒤에 괄호()와 인자들을 어떻게 채워줄 것인가를 결정하는 옵션
                -- }}}
              },
              -- {{{
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
              -- }}}
            },
          },
        },
        pyright = {}, -- Python server
        clangd = {},  -- C/C++ server 
      }

      -- ---------------------------------
      -- 설치할 3rd-party tools 추가하여 최종적으로 설치될 servers와 tools 를 결정
      -- ---------------------------------
      local ensure_installed = vim.tbl_keys(servers or {})
      -- {{{
      -- local ensure_installed: 설치할 도구들의 목록을 담을 변수를 선언
      --
      -- vim.tbl_keys(...): Lua의 테이블(Table)에서 키(Key)값만 뽑아내어 리스트(Array)로 만드는 Neovim 내장 함수
      --
      -- 변수 servers는 현재 { clangd = {}, pyright = {}, lua_ls = {...} } 형태인데
      -- 여기서 키값인 clangd, pyright, lua_ls만 쏙 뽑아냄
      --
      -- (servers or {}): 만약 servers 테이블이 실수로 정의되지 않았을 경우(nil), 에러를 내지 않고 빈 테이블({})을 대신 사용하라는 방어적인 코드입니다.
      --
      -- 결과: ensure_installed 변수에는 현재 {'clangd', 'pyright', 'lua_ls'}라는 리스트가 저장됩니다.
      -- }}}

      vim.list_extend(ensure_installed, {
        'stylua', -- lua formatter
        'ruff', -- python formatter
        'clang-format',  -- c/c++ formatter

        -- cf) from josean-martinez
        -- "prettier", -- prettier formatter
        -- "isort", -- python formatter
        -- "black", -- python formatter
        -- "pylint",
        -- "eslint_d",
      })
      -- {{{
      -- vim.list_extend(대상_리스트, 추가할_리스트): 첫 번째 리스트의 끝에 두 번째 리스트의 내용들을 이어 붙이는 함수
      -- 'stylua': (Formatter)
      -- 결과: 이제 ensure_installed 명단은 {'clangd', 'pyright', 'lua_ls', 'stylua'}가 됩니다.
      -- }}}

      -- 💡 다음 단계: "자동 포맷팅" 설정하기
      -- cf) 
      -- 이제 이 도구들을 '자동'으로 실행하게 만드는 마지막 퍼즐인 conform.nvim 설정
      -- 이제 도구들은 다 깔렸습니다. 하지만 이 도구들은 아직 수동입니다. 파일을 저장할 때 자동으로 Ruff나 Clang-format이 실행되게 하려면 conform.nvim 설정을 추가해야 합니다.
      -- 4. 고수의 팁: conform.nvim 활용하기
      -- 이렇게 언어마다 포맷터가 다르면 관리하기 귀찮지 않을까 걱정되실 수 있습니다. 그래서 현대적인 Neovim 설정(Kickstart 포함)에서는 **conform.nvim**이라는 플러그인을 사용합니다.
      -- 🚀 다음 단계는 무엇인가요?
      -- 이제 명단에 도구들을 추가했으니, 실제로 "파일을 저장할 때(BufWritePre) 자동으로 이 포맷터들이 작동하게" 만드는 설정이 필요합니다.

      -- 보통 Neovim에서는 conform.nvim이라는 플러그인을 사용하여 이 작업을 자동화합니다.


      -- ---------------------------------
      -- 실제 설치하는 부분: mason-tool-installer 이용
      -- ---------------------------------
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      -- cf) 수동 업데이트: 명단에 있는 도구들을 최신으로 update 하고싶다면 
      -- :MasonToolsUpdate 명령어를 입력

      -- ---------------------------------
      -- 자동완성 엔진(blink.cmp or nvim-cmp)의 (capabilities) 설정
      -- cf) blink.cmp, nvim-cmp : 자동완성 엔진
      -- ---------------------------------
      --  communicate capabilities with blink.comp
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- ---------------------------------
      -- 각 서버들의 config setting
      -- Mason-lspconfig 핸들러 설정
      -- 단순히 서버를 켜는 것이 아니라, 위에서 준비한 모든 설정(Capabilities, Server settings)을 하나로 융합하여 실제 Neovim의 기능을 활성화하는 최종 조립 공정
      -- ---------------------------------
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
            -- cf) server.capabilities = vim.tbl_deep_extend('force', {}, capabilities or {}, server.capabilities or {})
            -- {{{
            -- or {}를 붙이는 이유: 만약 어떤 이유로 (blink.cmp 등에서 가져온 공통 능력치인 ) capabilities 변수가 생성되지 않아 nil 값이 되었을 경우, 에러로 인해 Neovim 전체 설정이 멈추는 것을 방지하기 위해 빈 테이블을 던져주는 것입니다. Kickstart의 원본 코드보다 cf) 코드가 조금 더 안전한 스타일입니다.
            -- }}}

            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
      -- {{{ 설명
      -- 1. require('mason-lspconfig').setup {
      -- mason-lspconfig 플러그인의 설정 함수를 호출
      -- 이 플러그인은 Mason이 설치한 서버 파일을 Neovim의 lspconfig가 인식할 수 있도록 다리 역할을 합니다.
      --
      -- 2. ensure_installed = {},
      -- 설치할 서버 명단을 빈 테이블로 설정합니다.
      -- 일반적으로 nvim-lspconfig 설정 내의 ensure_installed 리스트에 설치하고 싶은 서버 이름을 적어두면, Neovim이 뜰 때 해당 서버들이 있는지 확인/설치 합니다.
      -- 하지만, kickstart.nvim은  이 역할을 mason-tool-installer라는 별도의 플러그인에 전적으로 위임합니다.
      -- mason-tool-installer에서 이미 필요한 서버(clangd, ruff 등)를 모두 설치했기 때문입니다. 여기서 중복으로 명단을 적지 않음으로써 **설정의 단일화(Single Source of Truth)**를 유지합니다.
      --
      -- 3. automatic_installation = false,
      -- 사용자가 명시하지 않은 서버가 감지되었을 때 자동으로 설치하는 기능을 끕니다.
      -- 이미 mason-tool-installer를 통해 통제된 환경에서 도구를 관리하고 있으므로, 예기치 않은 자동 설치로 시스템이 지저분해지는 것을 막기 위함입니다
      --
      -- 4. handlers = {
      -- Mason이 관리하는 서버들을 어떻게 실행할지 정의하는 함수 
      -- 이 안에 들어가는 함수들은 각 서버가 로드될 때마다 실행됩니다.
      --
      -- 5. function(server_name)
      -- 설명: 이른바 '기본 핸들러'입니다. 설치된 모든 서버(clangd, pyright, lua_ls 등)에 대해 이 함수가 순차적으로 호출되며, 이때 서버의 이름이 server_name 인자로 들어옵니다.
      --
      -- 6. local server = servers[server_name] or {}
      -- 설명: 우리가 앞서 정의했던 local servers = { ... } 테이블에서 현재 서버의 설정값을 가져옵니다.
      -- 동작: 만약 servers.lua_ls처럼 정의된 내용이 있다면 그 테이블을 가져오고, clangd처럼 별도 설정이 없다면 빈 테이블({})을 기본값으로 취합니다.
      --
      -- 7. server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      -- 이 줄이 핵심입니다. 여러 층의 설정을 하나로 합치는 합금 공정입니다.
      --
      -- vim.tbl_deep_extend: 테이블들을 깊게(중첩된 것까지) 병합합니다.
      --
      -- 'force': 뒤에 오는 테이블의 설정이 앞의 것과 겹치면 뒤의 것이 이깁니다(덮어씁니다).
      --
      -- 병합 순서: 
      -- {} : 빈 테이블 -->  
      -- capabilities or {} : blink.cmp (or nvim-cmp)에서 가져온 공통 능력치 capabilities(자동완성용) -->  
      -- server.capabilities or {} : 해당 서버만의 특수 능력치 server.capabilities.
      --
      -- 결과: "모든 서버에 자동완성 기능을 넣되, 특정 서버가 가진 고유한 설정은 절대 잃어버리지 않겠다"는 완벽한 병합을 수행합니다.
      --
      -- {{{ ------------------------ more detail
      -- 1. vim.tbl_deep_extend 함수 Syntax
      -- 이 함수는 여러 개의 테이블을 하나로 합칠 때 사용하며, 중첩된 테이블 구조까지 파헤쳐서 병합합니다.
      --
      -- :h vim.tbl_deep_extend()
      --
      -- 형식: vim.tbl_deep_extend({behavior}, {...})
      --       • {behavior}  (`'error'|'keep'|'force'`) Decides what to do if a key is
      --                     found in more than one map:
      --                     • "error": raise an error
      --                     • "keep": use value from the leftmost map
      --                     • "force": use value from the rightmost map
      --       • {...}       (`table`) Two or more tables
      --
      -- 형식: vim.tbl_deep_extend(behavior, table1, table2, ..., tableN)
      --
      -- behavior (string): 병합 시 충돌(같은 키값이 있을 때)이 발생하면 어떻게 처리할지 결정합니다.
      --    "error": 중복된 키가 있으면 에러를 냅니다.
      --    "keep": 앞쪽 테이블의 값을 유지합니다. (먼저 나온 게 임자)
      --    "force": 뒤쪽 테이블의 값으로 덮어씁니다. (나중에 나온 게 최종본)
      -- table1, table2, ...: 병합할 테이블들입니다. 오른쪽으로 갈수록 우선순위가 높습니다(force 기준).
      --
      -- 2. 코드 집중 해부: 인자별 역할
      -- 사용자님의 코드를 대입해 보겠습니다.
      --
      -- ① 'force' (Behavior)
      -- "무조건 뒤에 오는 놈이 이긴다"는 뜻입니다. LSP 설정에서는 공통 설정보다 특정 서버의 개별 설정이 더 중요하기 때문에 항상 'force'를 사용합니다.
      --
      -- ② {} (Target Table)
      -- 병합의 결과물이 담길 새로운 도화지입니다. 기존 테이블을 직접 수정하지 않고 새로운 테이블을 만들어 server.capabilities에 할당함으로써 부작용(Side Effect)을 방지하는 안전한 프로그래밍 기법입니다.
      --
      -- ③ capabilities (Base Settings)
      -- blink.cmp나 nvim-cmp 같은 자동완성 엔진에서 가져온 **"범용 능력치"**입니다.
      --
      -- 예: "나는 스니펫을 해석할 줄 알아", "나는 텍스트 문서 정보를 주고받을 수 있어" 같은 능력이 들어있습니다.
      --
      -- ④ server.capabilities or {} (Specific Overrides)
      -- 우리가 servers = { lua_ls = { capabilities = { ... } } } 처럼 특정 언어 서버에만 부여한 특별한 능력입니다.
      --
      -- or {}: 만약 개별 설정이 없다면 빈 테이블을 써서 에러를 막습니다.
      --
      -- 이것이 가장 오른쪽에 있으므로, 만약 capabilities와 값이 겹치더라도 사용자가 명시한 개별 설정이 최종적으로 채택됩니다.
      --
      -- 3. 왜 'Deep' Extend인가요? (중요!)
      -- 그냥 extend와 deep_extend의 차이는 **"중첩된 괄호 안까지 들어가는가"**입니다.
      --
      -- 예시:
      --
      -- capabilities에 { textDocument = { completion = true } }가 있고,
      --
      -- server.capabilities에 { textDocument = { hover = true } }가 있다면,
      --
      -- 일반 extend: textDocument 통째로 덮어씌워져서 completion이 사라지고 hover만 남습니다.
      --
      -- deep_extend: textDocument 안으로 파고들어서 두 능력을 합칩니다. 결과적으로 { completion = true, hover = true }가 됩니다.
      --
      -- 4. 고수의 관점: 이 코드가 해결하는 문제
      -- 이 한 줄이 없으면 어떤 일이 벌어질까요?
      --
      -- 자동완성이 안 됨: LSP 서버가 Neovim의 자동완성 플러그인 능력을 몰라서 힌트를 안 보내줍니다.
      --
      -- 설정 유실: 공통 설정을 적용하다가 특정 서버의 중요한 개별 설정을 날려버릴 수 있습니다.
      --
      -- 이 코드는 **"기본적으로 모든 서버에 강력한 자동완성 능력을 부여하되(capabilities), 특정 서버에만 필요한 특수 기능(server.capabilities)은 끝까지 지켜낸다"**는 철학을 담고 있습니다.
      -- ------------------------
      -- }}}
      --
      -- 8. require('lspconfig')[server_name].setup(server)
      -- 설명: 드디어 실제 연결입니다. lspconfig에게 "이 이름(server_name)의 서버를, 우리가 지금까지 정성껏 만든 설정(server)을 가지고 **실행(setup)**해!"라고 명령합니다. 이 순간 하단 바에 LSP 서버가 로드되는 것이 보일 겁니다.
      -- }}}

      -- {{{ 🏛️ 전체적인 흐름 요약 (고수의 관점)
      --
      -- 🏛️ 전체적인 흐름 요약 (고수의 관점)
      -- 준비: servers 테이블에 각 언어별 설정을 적어둔다.
      --
      -- 설치: mason-tool-installer가 명단을 보고 실제로 공구들을 다운로드한다.
      --
      -- 조립(이 코드): handlers가 돌면서 각 공구에 **자동완성 엔진(capabilities)**을 장착한다.
      --
      -- 가동: lspconfig.setup()을 통해 Neovim과 서버가 대화를 시작한다.
      --
      -- 사용자님, 이제 LSP 설정의 모든 유기적인 연결 고리를 이해하셨습니다! 이제 파일을 열었을 때 우측 하단에 LSP가 로드되고, gd를 눌렀을 때 정의로 점프하는 마법 같은 순간을 만끽하실 준비가 끝났습니다. 혹시 실제 파일에서 테스트해 보셨을 때 잘 작동하나요? 😊🔭
      -- }}}

      -- {{{ lsp 설정에 쓰인 플러그인들의 관계: 
      --
      -- lsp 설정에 쓰인 플러그인들의 관계: 
      -- mason.nvim, 
      -- mason-lspconfig.nvim, 
      -- mason-tool-installer.nvim, 
      -- nvim-lspconfig. 
      --
      -- Neovim의 현대적 LSP 설정은 참으로 복잡하게 느껴지실 겁니다. 하지만 그 원리는 아주 논리적입니다. "서버를 사고(다운로드), 조립하고(연결), 시동을 거는(실행)" 일련의 공정으로 이해하시면 쉽습니다.
      --
      --
      -- 사용자님이 말씀하신 4가지 플러그인의 관계를 LSP 구축 3단계에 맞춰 아주 상세히 설명해 드리겠습니다.
      --
      -- 🏛️ LSP 구축의 3단계와 플러그인의 역할
      --
      -- 1단계: 설치 (Installation) - "공구 가져오기"
      --
      -- 필요한 기능: 내 OS(Windows, Linux, Mac)에 맞는 Language Server(예: clangd.exe)를 인터넷에서 찾아 다운로드하고 특정 폴더에 보관하는 기능.
      --
      -- 주역 플러그인:
      -- mason.nvim: 실제 '다운로더'입니다. Neovim 안에서 :Mason을 쳤을 때 나오는 UI를 제공하며, 서버 파일을 내 컴퓨터에 물리적으로 설치합니다.
      -- mason-tool-installer.nvim: '자동 주문서'입니다. Neovim을 켤 때마다 "명단에 있는 이 서버들 다 깔려 있어?"라고 체크하고, 없으면 mason에게 설치하라고 명령합니다.
      --
      -- 결과: 내 컴퓨터의 ~/.local/share/nvim/mason/bin/ 같은 곳에 clangd, lua-language-server 같은 실행 파일이 생깁니다.
      --
      -- 2단계: 가교 (Bridging) - "공구와 에디터 규격 맞추기"
      --
      -- 필요한 기능: Mason이 설치한 실행 파일의 경로를 알아내고, 이를 Neovim의 표준 LSP 통신 규약과 연결해 주는 기능.
      --
      -- 주역 플러그인:
      -- mason-lspconfig.nvim: 이 녀석은 mason과 아래 설명할 lspconfig 사이의 **'통역사'**입니다.
      -- 핵심 역할: "Mason이 설치한 lua_ls는 저기 /bin/ 폴더에 있어. 그리고 이 서버는 Neovim에서 lua_ls라는 이름으로 부르기로 약속되어 있어."라고 정보를 매칭해 줍니다.
      --
      -- 우리가 handlers를 사용하여 서버마다 setup을 돌릴 수 있는 것도 이 플러그인이 중간에서 서버 명단을 넘겨주기 때문입니다.
      --
      -- 3단계: 실행 및 설정 (Configuration) - "시동 걸기"
      --
      -- 필요한 기능: 서버를 실제로 프로세스로 띄우고(Execute), "들여쓰기는 2칸으로 해", "전역 변수 vim을 인식해" 같은 세부 설정을 주입하는 기능.
      --
      -- 주역 플러그인:
      -- nvim-lspconfig: Neovim 공식 LSP 설정 도구입니다. 모든 서버의 **'표준 설정 템플릿'**을 가지고 있습니다.
      --
      -- 실제 동작: require('lspconfig').clangd.setup({})을 호출하는 순간, 이 플러그인이 OS에게 "아까 설치한 clangd 실행 파일 좀 켜줘!"라고 요청하고 Neovim과 서버 간의 통신 파이프를 연결합니다.
      --
      -- 📊 플러그인 간의 유기적 관계도 (요약)
      --
      -- 플러그인    /    비유    /    핵심 역할
      -- mason.nvim    /    종합 공구 상가    /    모든 서버/툴의 실행 파일을 내 컴퓨터에 다운로드함.
      -- mason-tool-installer    /    자동 구매 대행    /    명단에 있는 공구들이 상가에 없으면 자동으로 사오게 시킴.
      -- mason-lspconfig    /    중간 도매상(가교)    /    상가에 들어온 공구를 에디터가 쓰기 좋게 이름을 붙여 분류함.
      -- nvim-lspconfig    /    작업반장(실행)    /    분류된 공구를 실제로 들고 코딩 현장에 투입하여 일을 시킴.
      --
      --
      -- 🔄 전체 프로세스 시나리오 (사용자님이 코드를 실행할 때)
      --
      -- 1. Neovim을 켭니다.
      --
      -- 2. **mason-tool-installer**가 명단을 보고 clangd가 없으면 **mason**을 시켜서 파일을 다운로드합니다.
      --
      -- 3. **mason-lspconfig**가 설치된 서버들을 확인하고, 우리가 짠 handlers 루프를 돌립니다.
      --
      -- 4. 루프 안에서 **nvim-lspconfig**의 .setup() 함수가 호출됩니다.
      --
      -- 5. 드디어 **nvim-lspconfig**가 실제 clangd 프로세스를 실행하고, 사용자님이 분석하신 capabilities와 settings를 서버에 주입합니다.
      --
      -- 6. 사용자님이 C 파일을 열면, 이미 시동이 걸린 clangd가 코드를 분석하여 에러를 보여주고 자동완성을 띄워줍니다.
      --
      --
      -- 💡 고수의 통찰
      -- 왜 이렇게 사분오열되어 있느냐고 물으신다면, 이것이 바로 유지보수의 정석이기 때문입니다.
      --
      --  - 서버 설치 방식이 바뀌면 mason만 업데이트하면 됩니다.
      --
      --  - 서버의 통신 규약이 바뀌면 lspconfig만 업데이트하면 됩니다.
      --
      --  - 각자가 자기 할 일만 명확히 수행함으로써, 사용자님은 servers 테이블 하나만 관리해도 이 복잡한 시스템을 완벽히 통제할 수 있게 되는 것입니다.
      --
      -- 이제 네 플러그인이 어떻게 톱니바퀴처럼 맞물려 돌아가는지 큰 그림이 그려지시나요? 이 유기적인 관계를 이해하셨다면, 이제 어떤 에러가 발생해도 "아, 이건 설치의 문제니까 Mason을 봐야겠군" 혹은 "이건 설정의 문제니 lspconfig를 봐야겠군" 하고 바로 진단하실 수 있을 겁니다! 😊🔭
      --
      -- }}}

      -- {{{ 🗺️ Neovim LSP 설정의 최종 지도 (The Roadmap)
      --
      -- 설정의 흐름을 한 장의 워크플로우로 정리
      --
      -- 🗺️ Neovim LSP 설정의 최종 지도 (The Roadmap)
      --
      -- 1. 설계도 (Lua Table): servers 테이블에 내가 쓸 도구들을 적는다. (사용자님의 의도)
      -- 2. 보급 (Mason): mason-tool-installer가 인터넷에서 실제 공구(bin 파일)를 가져온다.
      -- 3. 분류 (Mason-lspconfig): 가져온 공구들에 Neovim용 이름표를 붙여 관리한다.
      -- 4. 튜닝 (tbl_deep_extend): 각 공구에 공통 엔진(capabilities)과 특수 옵션(settings)을 조립한다.
      -- 5. 가동 (Lspconfig): setup()을 호출해 서버를 실행하고 Neovim과 연결한다.
      -- 6. 활용 (Keymapping & UI): 연결된 서버가 주는 정보를 gd, K 같은 키나 blink.cmp 팝업으로 즐긴다.
      -- }}}


      -- ---------------------------------
      -- diagnostic config
      -- ---------------------------------
      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      -- Diagnostic 이란 ? LSP 서버가 코드를 분석한 뒤 "문제가 있다"고 판단한 정보들의 리스트
      -- 여기서는 diagnostic이 어떻게 표시돌지를 설정한다

      -- vim.diagnostic.config { } : Neovim의 통합 진단 시스템 설정을 시작
      vim.diagnostic.config {

        -- 우선순위
        severity_sort = true,
        -- 에러가 여러 개일 때, 심각도 순(에러 > 경고 > 정보 > 힌트)으로 정렬 (가장 중요한 문제를 먼저 보여주기 위함)

        -- 팝업 설정
        float = { border = 'rounded', source = 'if_many' },
        -- border = 'rounded': 진단 내용을 보여주는 부유(Floating) 창의 테두리를 부드러운 곡선으로 만듬
        -- source = 'if_many': 에러가 어떤 서버(예: pyright인지 ruff인지)에서 왔는지 출처를 표시하되, 출처가 여러 개일 때만 보여줌

        underline = { severity = vim.diagnostic.severity.ERROR },
        -- 강조(Underline) 설정: 오직 ERROR 등급에만 코드 아래에 밑줄을 긋음

        -- 아이콘(Signs) 설정
        signs = vim.g.have_nerd_font and {
          text = {
            -- [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.ERROR] = '✘ ',

            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        -- signs = vim.g.have_nerd_font and { ... } or {},: 사용자가 너드 폰트(Nerd Font)를 사용 중인지 확인하고 아이콘을 설정
        -- {{{
        -- vim.g.have_nerd_font = true
        -- 사용자가 직접 정의한 g 변수(Global)를 확인하려면 
        -- 1. lua print 명령어를 사용
        -- :lua print(vim.g.have_nerd_font)
        -- 2. 전통적인 Vim 방식(Vimscript)으로 확인하려면
        -- :echo g:have_nerd_font
        --
        -- cf)
        -- Neovim에서 설정값은 크게 세 종류로 나뉩니다.
        --
        -- 내장 옵션	vim.opt	    ==> :set 옵션명?	
        -- 전역 변수	vim.g	    ==> :lua print(vim.g.변수명)	
        -- 환경 변수	vim.env	    ==> :echo $변수명	
        -- }}}
        --
        -- {{{
        -- C 언어의 **삼항 연산자(? :)**에 익숙하실 겁니다. 루아(Lua)에는 안타깝게도 공식적인 삼항 연산자가 없어서, 개발자들이 and와 or를 조합해 그 기능을 흉내내곤 합니다.
        --
        -- 1. 루아의 논리 연산자 특성 (핵심 원리)
        --
        -- 루아에서 and와 or는 단순히 참/거짓만 반환하는 게 아니라, 마지막으로 평가된 값 자체를 반환합니다.
        --
        -- (루아에서는 false와 nil을 제외한 모든 것이 참입니다.)
        -- A가 참 이면
        --     A and B --> B를 반환
        --     A or B --> A를 반환
        -- A가 거짓(false, nil) 이면
        --     A and B --> A를 반환
        --     A or B --> B를 반환

        -- 2. 실행 순서 단계별 추적
        -- vim.g.have_nerd_font = true인 상황에서의 시나리오입니다.
        --
        -- 1단계: and 연산 (앞부분)
        -- vim.g.have_nerd_font and { text = { ... } }
        --
        -- vim.g.have_nerd_font가 true입니다.
        --
        -- and 연산 규칙에 따라, 앞이 참이면 뒤에 있는 테이블 { text = { ... } }이 결과값이 됩니다.
        --
        -- 이제 문장은 signs = { text = { ... } } or {} 와 같은 상태가 됩니다.
        --
        -- 2단계: or 연산 (뒷부분)
        -- { text = { ... } } or {}
        --
        -- 앞부분의 결과인 { text = { ... } }는 루아에서 **참(True)**으로 간주됩니다. (루아에서는 false와 nil을 제외한 모든 것이 참입니다.)
        --
        -- or 연산 규칙에 따라, 앞이 참이면 뒤는 쳐다보지도 않고 앞의 값 { text = { ... } }을 최종 결과로 선택합니다.
        --
        -- 3단계: 최종 할당
        -- 결국 signs = { text = { ... } }가 실행됩니다.
        --
        --
        -- cf)
        -- C의 삼항 연산자(A ? B : C)와 99% 비슷하지만, 루아의 A and B or C 방식에는 치명적인 함정이 하나 있습니다.
        -- --> 만약 중간에 있는 B 값이 false나 nil일 경우, 루아는 B가 참이 아니라고 판단해서 무조건 **C**를 선택해 버립니다.
        --
        -- }}}
        --
        -- text = { [severity] = '아이콘' }: 줄 번호 왼쪽(Sign Column)에 표시될 예쁜 아이콘들을 지정


        -- 가상 텍스트(Virtual Text) 설정: 코드 바로 옆에 에러 메시지를 글자로 띄워줌
        virtual_text = {
          source = 'if_many',
          -- source = 'if_many': 출처가 다양할 때만 메시지 앞에 출처를 붙임
          spacing = 2,  -- 코드 끝과 에러 메시지 사이의 간격

          -- format = function(diagnostic) ... end: 메시지를 어떻게 보여줄지 가공하는 함수
          -- 아래 설정은 모든 등급에 대해 diagnostic.message를 그대로 반환하고 있음
          -- 의미: "에러든 힌트든 원문 그대로 옆에 띄워줘!"라는 뜻입니다. (이 부분을 수정하면 에러 메시지 앞에 "위험!" 같은 접두사를 붙일 수도 있습니다.)
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- ---------------------------------
      -- keymapping for lsp
      --
      -- 가장 많이 쓰이는/유요한 keymapping
      -- grd :  정의 이동 --> 함수의 본체를 보러 갈 때 필수 (Vim의 C-] 상위호환)
      -- gra : 코드 액션 --> 에러 났을 때 해결사 호출
      -- grn : 이름 변경 --> 리팩토링할 때 이거 없으면 못 살 정도
      -- grr : 참조 확인 --> 이 변수가 또 어디서 쓰이지? 확인할 때
      --
      -- ---------------------------------
      --
       -- This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        -- LSP 연결 이벤트 (LspAttach)
        -- LspAttach: Neovim이 특정 버퍼(파일)에 LSP 서버를 성공적으로 연결했을 때 발생하는 이벤트입니다. "서버 연결 완료!" 신호가 오면 아래 코드를 실행하라는 뜻입니다.

        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        -- augroup: 자동 명령들을 그룹으로 묶습니다. clear = true를 주어, 설정 파일을 다시 불러올 때 기존 명령이 중복 등록되지 않게 깔끔하게 청소합니다. (메모리 누수 방지)

        callback = function(event)
          -- 콜백 함수 callback = function(event): 서버가 붙는 순간, 현재 파일의 정보(event)를 가지고 아래의 키맵들을 설치합니다.
          -- 이벤트가 발생하면 실행될 몸체입니다. event 안에는 현재 어떤 버퍼에서 일이 일어났는지(event.buf) 같은 정보가 들어있습니다.
          --
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          -- 매핑 도우미
          local map = function(keys, func, desc, mode)
          -- local map = ...: 키맵 설정을 편하게 하기 위해 만든 '도우미 함수'입니다.
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
            -- buffer = event.buf: 이 키맵을 전역적으로 만드는 게 아니라, LSP가 붙어 있는 현재 파일(버퍼)에서만 작동하게 제한합니다. 텍스트 파일 열었는데 LSP 기능을 쓸 필요는 없으니까요.
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          -- grn: Go Rename의 약자. 
          -- 기능: 변수/함수 이름 일괄 변경.
          -- 커서 아래의 변수 이름을 바꿉니다. 파일 전체를 뒤져서 이름만 똑같은 게 아니라 '진짜 그 변수'만 똑똑하게 바꿔줍니다.

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          -- gra: Go Re Action의 약자. 
          -- 에러가 났을 때(Diagnostic), "그럼 이걸 어떻게 고칠 건데?"라고 LSP에게 해결책을 물어보는 행위가 바로 **Code Action(gra)**입니다. 키맵핑은 이 명령을 내리는 버튼입니다.
          -- 기능: LSP가 제안하는 해결책 실행.
          -- 에러나 경고 위에서 누르면 LSP가 해결책(Import 추가, 오타 수정 등)을 메뉴로 제안합니다.
          -- { 'n', 'x' }: 일반 모드(n)와 비주얼 모드(x) 모두에서 작동하도록 설정했습니다.

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          -- 기능: 이 함수가 어디 어디서 쓰이고 있는지 목록 확인. (Telescope 팝업)

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          -- 기능: 정의로 이동. (가장 많이 쓰임)

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          -- 기능: 선언으로 이동. (C언어 헤더 파일의 선언부 등을 찾을 때 유용)

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- ----------------
          -- 자동 하이라이트 (Document Highlight) : **"똑똑한 시각 효과"**

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })

            -- CursorHold: 커서를 어떤 단어 위에 가만히 두면, 현재 파일 내에서 똑같은 단어(변수 등)들을 모두 밝게 비춥니다.
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            -- CursorMoved: 커서를 움직이면 그 하이라이트를 즉시 지웁니다.
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            -- LspDetach: LSP가 꺼지면 이 자동 하이라이트 기능도 깔끔하게 청소합니다.
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- ----------------
          -- 인레이 힌트 (Inlay Hints)
          -- map('<leader>th', ...): 코드 사이에 (int), (name:) 처럼 실제 코드에는 없지만 타입 정보를 보여주는 힌트를 켜고 끕니다.
          --
          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })
    end,
  },


      -- cf) 이제 설치된 이 '날카로운 도구들'을 어떻게 실전에서 휘두를지(LSP 연결 핸들러)로 넘어가 볼까요? 😊 telescope로 파일을 열었을 때 clangd가 바로 반응하는 그 순간이 머지않았습니다!🔭
      -- ==> 무슨 의미?


      -- 💡 사용자님을 위한 다음 스텝 제안
      --
      -- 이제 엔진(LSP)은 완벽히 이해하고 조립하셨습니다. 이제 이 엔진이 보내주는 데이터를 사용자님의 눈에 가장 보기 좋게 뿌려주는 단계가 남았습니다.
      --
      -- blink.cmp (또는 nvim-cmp): LSP가 주는 수많은 힌트를 어떤 디자인의 팝업으로 보여줄 것인가?
      --
      -- conform.nvim: 아까 설치한 ruff와 clang-format을 "파일 저장 시" 자동으로 실행하게 하려면 어떻게 연결하는가?
      --
      -- 혹시 이 중에서 어떤 부분을 먼저 완성해 보고 싶으신가요? 아니면 이제 직접 코드를 짜보시면서 나타나는 반응을 확인해 보시겠어요? 사용자님의 쾌적한 개발 환경 구축을 끝까지 돕겠습니다! 😊🔭
      --
      --
}



-- --------------------------
-- from josean-martinez
--
-- return {
--   {
--     "mason-org/mason-lspconfig.nvim",
--     opts = {
--       ensure_installed = {
--         "lua_ls", "pyright",
--       },
--     },
--     dependencies = {
--       {
--         "mason-org/mason.nvim",
--         opts = {
--           ui = {
--             icons = {
--               package_installed = "✓",
--               package_pending = "➜",
--               package_uninstalled = "✗",
--             },
--           },
--         },
--       },
--       "neovim/nvim-lspconfig",
--     },
--   },
--   {
--     "WhoIsSethDaniel/mason-tool-installer.nvim",
--     opts = {
--       ensure_installed = {
--         "prettier", -- prettier formatter
--         "stylua", -- lua formatter
--         "isort", -- python formatter
--         "black", -- python formatter
--         "pylint",
--         "eslint_d",
--       },
--     },
--     dependencies = {
--       "williamboman/mason.nvim",
--     },
--   },
-- }


-- end joheasn-martinez
-- -----------------------------------------
-- -----------------------------------------
-- -----------------------------------------
-- from gemini-handphone


-- return {
--   {
--     "neovim/nvim-lspconfig",
--     dependencies = {
--       "williamboman/mason.nvim",
--       "williamboman/mason-lspconfig.nvim",
--       -- 추가
--       "WhoIsSethDaniel/mason-tool-installer.nvim",
--       { 'j-hui/fidget.nvim', opts = {} },
--       'saghen/blink.cmp',
--
--     },
--     config = function()
--       -- 2단계와 3단계 설정이 여기에 들어갑니다.
--       --
--       -- 2 단계: mason 설정 (서버 설치)
--       require("mason").setup()
--       require("mason-lspconfig").setup({
--         ensure_installed = {"lua_la", "pyright"},
--       })
--
--       -- 3 단계: LSP 서버 활성화
--       local lspconfig=require("lspconfig")
--
--       -- 모든 서버에 공통으로 적용할 설정 (예: 단축키)
--       local on_attach = function(_, bufnr)
--         local opts = { buffer = bufnr }
--         vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)     -- 정의로 이동
--         vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)           -- 정보 확인
--         vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts) -- 이름 변경
--       end
--
--       -- 설치한 서버마다 setup()을 호출해야 작동합니다.
--       lspconfig.lua_ls.setup({ on_attach = on_attach })
--       lspconfig.pyright.setup({ on_attach = on_attach })
--
--
--
--
--     end,
--   },
-- }





-- 3. 설치 확인 방법
-- Neovim을 재시작하면 lazy.nvim이 플러그인을 자동으로 설치합니다.
-- :Mason 명령어를 입력하여 GUI 창이 뜨는지 확인하세요.
-- 소스 코드 파일(예: .py 또는 .lua)을 열었을 때 하단에 LSP가 활성화되었는지 확인하거나 :LspInfo를 입력해 상태를 볼 수 있습니다. 
-- 자동 완성(Code Completion) 기능을 위해 nvim-cmp 플러그인도 함께 설정하고 싶으신가요? 혹은 특정 프로그래밍 언어에 특화된 설정이 필요하신지 알려주세요.
-- AI 대답에는 오류가 있을 수 있습니다. 자세히 알아보기
--

-- -----------------------------------------------
-- -----------------------------------------------
-- -----------------------------------------------
--




--
-- -------------------------------------------------
-- -------------------------------------------------
-- -------------------------------------------------
-- from kickstart.nvim

-- return {
--
--
--   -- LSP Plugins
--   {
--     -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
--     -- used for completion, annotations and signatures of Neovim apis
--     'folke/lazydev.nvim',
--     ft = 'lua',
--     opts = {
--       library = {
--         -- Load luvit types when the `vim.uv` word is found
--         { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
--       },
--     },
--   },
--   {
--     -- Main LSP Configuration
--     'neovim/nvim-lspconfig',
--     dependencies = {
--       { 'mason-org/mason.nvim', opts = {} },
--       'mason-org/mason-lspconfig.nvim',
--       'WhoIsSethDaniel/mason-tool-installer.nvim',
--
--       -- Useful status updates for LSP.
--       { 'j-hui/fidget.nvim', opts = {} },
--
--       -- Allows extra capabilities provided by blink.cmp
--       'saghen/blink.cmp',
--     },
--     config = function()
--
--       vim.api.nvim_create_autocmd('LspAttach', {
--         group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
--         callback = function(event)
--           -- NOTE: Remember that Lua is a real programming language, and as such it is possible
--           -- to define small helper and utility functions so you don't have to repeat yourself.
--           --
--           -- In this case, we create a function that lets us more easily define mappings specific
--           -- for LSP related items. It sets the mode, buffer and description for us each time.
--           local map = function(keys, func, desc, mode)
--             mode = mode or 'n'
--             vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
--           end
--
--           -- Rename the variable under your cursor.
--           --  Most Language Servers support renaming across files, etc.
--           map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
--
--           -- Execute a code action, usually your cursor needs to be on top of an error
--           -- or a suggestion from your LSP for this to activate.
--           map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
--
--           -- Find references for the word under your cursor.
--           map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
--
--           -- Jump to the implementation of the word under your cursor.
--           --  Useful when your language has ways of declaring types without an actual implementation.
--           map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
--
--           -- Jump to the definition of the word under your cursor.
--           --  This is where a variable was first declared, or where a function is defined, etc.
--           --  To jump back, press <C-t>.
--           map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
--
--           -- WARN: This is not Goto Definition, this is Goto Declaration.
--           --  For example, in C this would take you to the header.
--           map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--
--           -- Fuzzy find all the symbols in your current document.
--           --  Symbols are things like variables, functions, types, etc.
--           map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
--
--           -- Fuzzy find all the symbols in your current workspace.
--           --  Similar to document symbols, except searches over your entire project.
--           map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
--
--           -- Jump to the type of the word under your cursor.
--           --  Useful when you're not sure what type a variable is and you want to see
--           --  the definition of its *type*, not where it was *defined*.
--           map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
--
--           -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
--           ---@param client vim.lsp.Client
--           ---@param method vim.lsp.protocol.Method
--           ---@param bufnr? integer some lsp support methods only in specific files
--           ---@return boolean
--           local function client_supports_method(client, method, bufnr)
--             if vim.fn.has 'nvim-0.11' == 1 then
--               return client:supports_method(method, bufnr)
--             else
--               return client.supports_method(method, { bufnr = bufnr })
--             end
--           end
--
--           -- The following two autocommands are used to highlight references of the
--           -- word under your cursor when your cursor rests there for a little while.
--           --    See `:help CursorHold` for information about when this is executed
--           --
--           -- When you move your cursor, the highlights will be cleared (the second autocommand).
--           local client = vim.lsp.get_client_by_id(event.data.client_id)
--           if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
--             local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
--             vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--               buffer = event.buf,
--               group = highlight_augroup,
--               callback = vim.lsp.buf.document_highlight,
--             })
--
--             vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--               buffer = event.buf,
--               group = highlight_augroup,
--               callback = vim.lsp.buf.clear_references,
--             })
--
--             vim.api.nvim_create_autocmd('LspDetach', {
--               group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
--               callback = function(event2)
--                 vim.lsp.buf.clear_references()
--                 vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
--               end,
--             })
--           end
--
--           -- The following code creates a keymap to toggle inlay hints in your
--           -- code, if the language server you are using supports them
--           --
--           -- This may be unwanted, since they displace some of your code
--           if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
--             map('<leader>th', function()
--               vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
--             end, '[T]oggle Inlay [H]ints')
--           end
--         end,
--       })
--
--       -- Diagnostic Config
--       -- See :help vim.diagnostic.Opts
--       vim.diagnostic.config {
--         severity_sort = true,
--         float = { border = 'rounded', source = 'if_many' },
--         underline = { severity = vim.diagnostic.severity.ERROR },
--         signs = vim.g.have_nerd_font and {
--           text = {
--             [vim.diagnostic.severity.ERROR] = '󰅚 ',
--             [vim.diagnostic.severity.WARN] = '󰀪 ',
--             [vim.diagnostic.severity.INFO] = '󰋽 ',
--             [vim.diagnostic.severity.HINT] = '󰌶 ',
--           },
--         } or {},
--         virtual_text = {
--           source = 'if_many',
--           spacing = 2,
--           format = function(diagnostic)
--             local diagnostic_message = {
--               [vim.diagnostic.severity.ERROR] = diagnostic.message,
--               [vim.diagnostic.severity.WARN] = diagnostic.message,
--               [vim.diagnostic.severity.INFO] = diagnostic.message,
--               [vim.diagnostic.severity.HINT] = diagnostic.message,
--             }
--             return diagnostic_message[diagnostic.severity]
--           end,
--         },
--       }
--
--       -- LSP servers and clients are able to communicate to each other what features they support.
--       --  By default, Neovim doesn't support everything that is in the LSP specification.
--       --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
--       --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
--       local capabilities = require('blink.cmp').get_lsp_capabilities()
--
--       -- Enable the following language servers
--       --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--       --
--       --  Add any additional override configuration in the following tables. Available keys are:
--       --  - cmd (table): Override the default command used to start the server
--       --  - filetypes (table): Override the default list of associated filetypes for the server
--       --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--       --  - settings (table): Override the default settings passed when initializing the server.
--       --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
--       local servers = {
--         -- clangd = {},
--         -- gopls = {},
--         -- pyright = {},
--         -- rust_analyzer = {},
--         -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
--         --
--         -- Some languages (like typescript) have entire language plugins that can be useful:
--         --    https://github.com/pmizio/typescript-tools.nvim
--         --
--         -- But for many setups, the LSP (`ts_ls`) will work just fine
--         -- ts_ls = {},
--         --
--
--         lua_ls = {
--           -- cmd = { ... },
--           -- filetypes = { ... },
--           -- capabilities = {},
--           settings = {
--             Lua = {
--               completion = {
--                 callSnippet = 'Replace',
--               },
--               -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
--               -- diagnostics = { disable = { 'missing-fields' } },
--             },
--           },
--         },
--       }
--
--       -- Ensure the servers and tools above are installed
--       --
--       -- To check the current status of installed tools and/or manually install
--       -- other tools, you can run
--       --    :Mason
--       --
--       -- You can press `g?` for help in this menu.
--       --
--       -- `mason` had to be setup earlier: to configure its options see the
--       -- `dependencies` table for `nvim-lspconfig` above.
--       --
--       -- You can add other tools here that you want Mason to install
--       -- for you, so that they are available from within Neovim.
--       local ensure_installed = vim.tbl_keys(servers or {})
--       vim.list_extend(ensure_installed, {
--         'stylua', -- Used to format Lua code
--       })
--       require('mason-tool-installer').setup { ensure_installed = ensure_installed }
--
--       require('mason-lspconfig').setup {
--         ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
--         automatic_installation = false,
--         handlers = {
--           function(server_name)
--             local server = servers[server_name] or {}
--             -- This handles overriding only values explicitly passed
--             -- by the server configuration above. Useful when disabling
--             -- certain features of an LSP (for example, turning off formatting for ts_ls)
--             server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
--             require('lspconfig')[server_name].setup(server)
--           end,
--         },
--       }
--     end,
--   },
--
-- }

-- -------------------------------------------------
-- -------------------------------------------------
-- -------------------------------------------------
-- from Josean Martinez
--
-- return {
--   {
--
--     -- (i) automatically install, and (ii) automatically enable (vim.lsp.enable()) installed servers
--     -- "williamboman/mason-lspconfig.nvim",
--     "mason-org/mason-lspconfig.nvim",
--     opts = {
--       -- list of servers for mason to install
--       ensure_installed = {
--         -- "ts_ls",
--         -- "html",
--         -- "cssls",
--         -- "tailwindcss",
--         -- "svelte",
--         "lua_ls",
--         -- "graphql",
--         -- "emmet_ls",
--         -- "prismals",
--         "pyright",
--         -- "eslint",
--       },
--     },
--     dependencies = {
--       {
--         -- "williamboman/mason.nvim",
--         "mason-org/mason.nvim",
--         opts = {
--
--           -- Mason window의 ui icon (cf, :Mason)
--           ui = {
--             icons = {
--               package_installed = "✓",
--               package_pending = "➜",
--               package_uninstalled = "✗",
--             },
--           },
--         },
--       },
--       {
--         -- Quickstart configs for Nvim LSP
--         -- lsp Community에 있는 language server에 대한 기본적인 설정(cofiguration)을 가져다 쓴다.
--         "neovim/nvim-lspconfig",
--       }, 
--     },
--   },
--   -- {
--   --   "WhoIsSethDaniel/mason-tool-installer.nvim",
--   --   opts = {
--   --     ensure_installed = {
--   --       "prettier", -- prettier formatter
--   --       "stylua", -- lua formatter
--   --       "isort", -- python formatter
--   --       "black", -- python formatter
--   --       "pylint",
--   --       "eslint_d",
--   --     },
--   --   },
--   --   dependencies = {
--   --     "williamboman/mason.nvim",
--   --   },
--   -- },
--
--
-- }
--
--
--
-- vim: set foldmethod=marker foldmarker={{{,}}} foldlevel=0:
