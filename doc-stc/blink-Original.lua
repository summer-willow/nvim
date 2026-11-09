
-- Autocompletion

-- ----------------------------------------------
-- kickstart.nvim의 origianl + stc가 조금 덧붙인 설정
--
return  {
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',

  -- 플러그인이 로드되기 전에 필수 스니펫 엔진과 LaTeX 확장 팩을 먼저 설치합니다.
  dependencies = {
    -- Snippet Engine
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          -- 스니펫 컬렉션
          'rafamadriz/friendly-snippets',
          config = function()
            -- -----------------------------------------------------------------
            -- snippet 로드 : friendly-snippets 제공 snippets
            -- friendly-snippets가 제공하는 VS Code 양식의 스니펫들을 LuaSnip으로 로드.
            -- cf) lazy_load: 인자(괄호 안의 내용) 유무에 따라 전혀 다른 대상을 가져오는 서로 독립된 명령어입니다.
            -- -----------------------------------------------------------------
            require('luasnip.loaders.from_vscode').lazy_load()

            -- -----------------------------------------------------------------
            -- snippet 로드 : custom JSO snippets 
            -- 커스텀 JSON 스니펫들을 로드
            -- 나만의 커스텀 JSON 스니펫 폴더 위치를 LuaSnip에 알려주기
            -- vim.fn.stdpath('config') 구문이 자동으로 AppData\Local\nvim 경로를 찾아주기 때문에, 그 뒤에 /snippets 폴더를 연결해 준 것입니다.
            -- -----------------------------------------------------------------
            local snippet_path = vim.fn.stdpath('config') .. '/snippets'

            require('luasnip.loaders.from_vscode').lazy_load({
              paths = { snippet_path }
            })

            -- -----------------------------------------------------------------
            -- snippet 로드 : lua snippets
            -- 루아 스니펫(*.lua) 폴더 로드
            -- -----------------------------------------------------------------
            require("luasnip.loaders.from_lua").lazy_load({
              paths = { snippet_path }
            })
            -- --------------------------

          end,
        },



        -- -- ---------------------------------------
        -- -- summer_willow, 2026-06-28 11:40:56
        -- --
        -- -- [핵심] Gilles Castel 스타일의 초고속 LaTeX 자동 트리거 플러그인
        -- {
        --   "iurimateus/luasnip-latex-snippets.nvim",
        --
        --   -- tex 파일이 열릴 때만 로드 (성능 최적화)
        --   ft = { "tex", "markdown" },
        --
        --   -- Neovim이 수식 모드를 정확히 감지(Tree-sitter 기반)할 수 있도록 로드 시점 설정
        --   config = function()
        --     require("luasnip-latex-snippets").setup({
        --
        --       -- 오직 수식 모드($, $$ 안)에서만 작동하도록 보장
        --       use_treesitter = true, -- 오직 LaTeX 수식($...$) 내부에서만 작동하도록 구문분석기 활성화
        --     })
        --     -- LuaSnip에게 "자동 트리거(Autotrigger) 기능을 전역으로 켜라"고 명령합니다.
        --     require("luasnip").config.setup({ enable_autosnippets = true })
        --   end,
        -- },
        --
        -- -- summer_willow, 2026-06-28 11:40:56, end
        -- -- ---------------------------------------





      },
      -- opts = {},
      -- ----------------------------------------------------
      -- by stc
      opts = {
        -- ----------------------------------------------------
        -- LuaSnip 의 자동 스니펫 기능 활성황 
        -- ----------------------------------------------------
        -- LuaSnip이 로드될 때 이 옵션이 가장 먼저 주입됩니다.
        enable_autosnippets = true, -- 자동스니펫 활성화, 
        -- lazy.nvim 환경에서 LuaSnip은 opts = { ... } 형태로 옵션을 넘겨주면 내부적으로 setup(opts)을 호출하면서 config.set_config를 자동으로 처리해 준다
        -- 따라서, snippet 로더가 (ex, require("luasnip.loaders.from_lua").lazy_load()) 실행되기 전에, 전역 자동 스니펫 옵션을 (enable_autosnippets = true) 활성화합니다.
        -- ----------------------------------------------------
      },
      -- by stc, end
      -- ----------------------------------------------------

      -- ----------------------------------------------------
      -- by stc
      --
      -- -----------------------------------------------------------------
      -- [STC 추가] LuaSnip 자체의 초기화 가동 단계에서 파일타입 확장을 실행합니다.
      -- -----------------------------------------------------------------
      config = function(_, opts)
        require("luasnip").setup(opts)

        -- -----------------------------------------------------------------
        -- 적용될 snippets 확장
        -- -----------------------------------------------------------------
        --`requre("luasnip").filetype_extend(ft, extend_fts)
        -- ft: 현재 편집하고 있는 파일타입
        -- extend_fts: 가져올 파일타입 목록
        -- cf) lazy.nvim에서 opts 테이블은 단순히 값을 전달하는 곳이기 때문에, 함수 형태의 명령어인 filetype_extend는 opts에 놓으면 안된다. config 함수를 따로 만들어서 그 안에 배치하는 것이 Neovim 설정의 정석입니다.
        --
        -- 마크다운 파일에서 tex(LaTeX) 스니펫을 공유하도록 강제 연결
        require("luasnip").filetype_extend("markdown", { "tex" })

        -- 만약 나중에 다른 언어 결합이 필요하다면 이 아래에 똑같이 한 줄씩 추가하면 됩니다.
        -- require("luasnip").filetype_extend("python", { "matlab" })

      end,
      -- by stc, end
      -- ----------------------------------------------------

    },
    --
    -- for obsidian.nvim
    -- "saghen/blink.cmp-obsidian", -- 이 의존성을 추가하세요
    --
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- -------------------------------
    -- kickstart original keymap

    keymap = {
      -- 'default' (recommended) for mappings similar to built-in completions
      --   <c-y> to accept ([y]es) the completion.
      --    This will auto-import if your LSP supports it.
      --    This will expand snippets if the LSP sent a snippet.
      -- 'super-tab' for tab to accept
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- For an understanding of why the 'default' preset is recommended,
      -- you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      --
      -- All presets have the following mappings:
      -- <tab>/<s-tab>: move to right/left of your snippet expansion (by LuaSnip plugin)
      -- <C-y>: 선택한 아이템 확정(Accept)
      -- <c-space>: Open menu or open docs if already open, 자동완성 및 문서 창 토글
      -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- <c-e>: Hide menu, 자동완성 창 닫기
      -- <c-k>: Toggle signature help
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      --
      preset = 'default', -- 기본 default 프리셋 구조를 베이스로 가져갑니다.

      -- ---------------------------------------
      -- by stc
      -- default 프리셋 중 변경하고 싶은 키만 명시적으로 지정해서 덮어씀(override).

      -- {{{
      -- 엔터 키 동작 제어
      -- cf) 스니펫이 발동되어 자동완성 목록이 나올 때, 기본적으로 목록의 아무것도 선택(아이라이트) 안 된 상태로 열린상태이다. (completion.list.selection.preselect = false)
      -- 자동완성 목록이 없을때는 일반적인 엔터 역활,
      -- 자동완성 옥록이 있고, 목록의 하나에 하이라이트 된 상태에서는 그 목록 선택
      -- ['<CR>'] = {
      --   function(cmp)
      --     -- 목록에서 사용자가 무언가를 선택(하이라이트)한 상태인지 확인
      --     -- cmp.get_selected_item() 검사: 엔터를 눌렀을 때, 목록 중 하나가 하이라이트 된 상태인지
      --     -- (명확히 '선택'되었는지) 감지.
      --     if cmp.is_visible() and cmp.get_selected_item() then
      --       -- 선택했다면 스니펫 확장 또는 완성 실행
      --       return cmp.accept()
      --     else
      --       -- 아무것도 선택하지 않은 상태(단순 목록만 뜬 상태)라면 일반 줄바꿈 실행
      --       return false
      --     end
      --   end,
      --   'fallback', -- fallback을 넣어두어야 일반 입력 모드에서 줄바꿈이 작동합니다.
      -- },
      -- 위의 <CR> 동작 제어코드와 완전히 동일한 단툭 문자열 설정 방식
      -- }}}
      ["<CR>"] = { "accept_and_enter", "fallback" },
      --
      -- {{{
      -- cf) ["<CR>"] = { "accept", "fallback" },
      -- ==> 미세하게 다르게 동작하여 원치않는 지뢰가 될 수 있다.
      -- <CR>에 대한 함수 형태의 설정과 문자열 설정은, 겉보기엔 비슷해 보여도 내부 동작이 전혀 다릅니다.
      --
      -- ## 함수 방식
      -- if cmp.is_visible() and cmp.get_selected_item() then return cmp.accept() ...
      -- 이 방식은 창이 열려 있더라도 "사용자가 수동으로 방향키나 <C-j>를 눌러서 어떤 단어에 하이라이트를 직접 씌웠을 때만" 완성을 승인합니다. 아무것도 안 고른 상태면 줄바꿈(fallback)이 됩니다.
      -- 긴 함수 방식 대신, 가장 최근 버전의 blink.cmp가 제공하는 공식 안전 문자열을 쓰시면 됩니다.
      -- ["<CR>"] = { "accept_and_enter", "fallback" },
      -- "accept_and_enter" : 자동완성 목록의 후보가 선택(하이라이트) 되었는 때는 그것을 accept 하고, 아무것도 선택 안 했을 때는 완성 안 되고 그냥 엔터 수행
      -- 즉, 
      -- 내가 위아래 키(<C-j/k>)로 직접 후보를 골랐을 때만 완성이 되고, 아무것도 안 고른 상태(preselect = false 상태)일 때는 첫 번째 항목을 강제로 가로채지 않고, 깔끔하게 엔터 본연의 기능(줄바꿈 또는 명령 실행)으로 바로 탈출합니다.
      --
      -- ## 단축 문자열 방식: ["<CR>"] = { "accept", "fallback" }
      -- 이 방식은 창이 열려 있기만 하면, 설령 아무것도 하이라이트 되어 있지 않더라도 목록의 가장 첫 번째 랭크된 단어를 무조건 강제로 집어넣으려고 시도(accept)합니다.
      -- cf) blink.cmp의 "accept"는 내부적으로 다음과 같이 작동
      --   - 목록에 무언가 하이라이트가 되어 있다면 ➡️ 그 단어를 완성한다.
      --   - 목록에 아무것도 하이라이트가 안 되어 있다면 ➡️ '첫 번째 항목'을 강제로 하이라이트 시킨 뒤 완성한다.
      --
      -- 결론: 
      -- "아무것도 선택 안 되었을 때는 그냥 엔터 본연의 기능이 실행되게 해줘"를 
      -- 만족하려면 문자열 방식("accept")을 쓰면 안 되고, 
      -- 기존에 쓰던 주석 처리된 긴 함수 형태나 
      -- ["<CR>"] = { "accept_and_enter", "fallback" },
      -- 를야 한다.
      -- }}}
      -- fallback: 내 앞에 지정한 자동완성 명령들이 실행될 조건이 아닐 때, 에디터 본래의 기본 키 동작 으로 넘겨주는 탈출 메커니즘입니다.
      -- 배열 안에 문자열을 순서대로 나열하면 앞의 조건이 안 맞을 때 뒤의 명령으로 순차 토스하는 시스템
      -- cf)  <C-y>: 선택한 아이템 확정(Accept)

      -- ---------------------------------------
      -- <Tab> 키 동작 설정
      -- test 용
      -- cf) preset = 'super-tab',
      -- "상황에 맞게 알아서 작동" 즉, 자동완성 창이 떠 있으면 다음 항목으로 이동하고, 스니펫이 확장된 상태라면 다음 입력 위치(점프 플레이스홀더)로 이동하며, 둘 다 아니라면 일반적인 탭 들여쓰기를 수행.

      -- {{{
      -- [[ 탭(Tab) 키: 이동, 스니펫 점프, 일반 탭 ]]
      -- ['<Tab>'] = {
      --   function(cmp)
      --     if cmp.is_visible() then return cmp.select_next() end
      --     if cmp.snippet_active() then return cmp.snippet_forward() end
      --     -- 동작 우선순위: 스니펫 점프 중이라도 자동완성 목록(cmp.is_visible())이 뜨면 Tab은 이동을 우선
      --   end,
      --   'fallback',
      -- },
      -- }}}
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },

      -- {{{
      -- [[ 역탭(Shift-Tab): 역이동, 역점프 ]]
      -- ['<S-Tab>'] = {
      --   function(cmp)
      --     if cmp.is_visible() then return cmp.select_prev() end
      --     if cmp.snippet_active() then return cmp.snippet_backward() end
      --   end,
      --   'fallback',
      -- },
      -- }}}
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

      -- <Tab> 키 동작 설정, end
      -- ---------------------------------------

      -- 자동완성창 이동은 C-n, C-p ==> C-j, C-k로
      ['<C-j>'] = { 'select_next', 'fallback' }, -- 아래로 이동
      ['<C-k>'] = { 'select_prev', 'fallback' }, -- 위로 이동

      -- 기존 default 프리셋에 묶여있던 <C-n>, <C-p>의 기능을 명시적으로 해제.
      -- 결과적으로, 이제 <C-n>과 <C-p>는 vanilla nvim의 기능인 단어완성 기능만 후행한다.
      ['<C-n>'] = {},
      ['<C-p>'] = {},
      -- {{{ ['<C-n>'] = {}, ['<C-p>'] = {}을 넣은 이유:
      -- ['<C-n>'] = {}, ['<C-p>'] = {}을 넣은 이유:
      -- Blink.cmp는 덮어쓰기를 할 때 기존 프리셋의 키를 자동으로 지워주지 않음으로
      -- 만약 ['<C-n>'] = {}, ['<C-p>'] = {}을 하지 않으면,
      -- 원래 매핑되어 있던 <C-n>과 <C-p>도 여전히 자동완성 이동 키로 작동하게 된다.
      -- 완벽하게 <C-j>/<C-k>로만 움직이게 통제하기 위해 기존 키를 청소해 준 것이다.
      -- }}}
      -- {{{ 'fallback'의 역할:
      -- fallback: 특정 조건에서 플러그인 기능 대신 원래 Neovim이나 다른 플러그인의 기능을 수행하도록 권한을 넘겨주는 규칙입니다.
      -- }}}
      -- {{{ :h i_CTRL-N, :h i_CTRL-P
      -- 자동완성창 이동이 해제 되었으므로, vanilla nvim:의 (순정 상태의 nvim) 기본 기능인,
      -- 현재 버퍼(파일)와 열려 있는 다른 버퍼에 있는 단어들을 기반으로 단어를 완성해 주는 기능이 수행된다.
      -- <C-p>: previous completion (이전 완성 후보)
      -- <C-n>: next completion (다음 완성 후보)
      -- :h i_CTRL-N, :h i_CTRL-P
      --
      -- vaniila nvim 내장 자동완성 전체 시스템과 더 다양한 완성 옵션(경로 완성, 사전 완성 등)에 대해 깊게 알아보고 싶다면
      -- :help ins-completion
      -- }}}

      -- -------------------------------------
      -- snippet placehold jump :  <Tab>, <S-Tab>, <C-h/l>, <C-f/b>가 모두 동작
      --
      -- snippet placehold jump:
      -- <Tab>, <S-Tab>, <C-h/l>, <C-f/b>가 모두 동작
      --
      -- <Tab> / <S-Tab>가 작동하는 이유: 코드 상단에 preset = 'default'를 선언하셨기 때문에, Blink.cmp가 기본적으로 내장하고 있는 프리셋 규칙에 따라 <Tab>과 <S-Tab>이 자동으로 스니펫 앞/뒤 점프 기능을 부여받습니다.
      --
      -- <C-l> / <C-h> 및 <C-f> / <C-b>가 작동하는 이유: 아래에 사용자가 명시적으로 중복 할당(Redundant Mapping)을 해주었기 때문에, 프리셋 키와 상관없이 이 키들 역시 동일한 스니펫 이동 명령을 병렬로 수행하게 됩니다.
      -- -------------------------------------
      --
      -- 만약 스니펫 안이 아니라면 원래 Neovim 기능(글자 입력 등)으로 fallback.
      -- C-l/h>과 c-f/b과 <Tab><S-Tab> 모두 다 스닛펫 다음/이전  칸 이동
      ['<C-l>'] = { 'snippet_forward', 'fallback' },  -- 다음 입력 칸으로 이동
      ['<C-h>'] = { 'snippet_backward', 'fallback' }, -- 이전 입력 칸으로 이동
      -- Or
      -- 추천 1위: Ctrl + f (앞으로 점프) / Ctrl + b (뒤로 점프)
      ['<C-f>'] = { 'snippet_forward', 'fallback' },
      ['<C-b>'] = { 'snippet_backward', 'fallback' },

      -- documentation window 관련 keymapping
      --
      -- -----------------------
      -- {{{ 문서 창 (documenation window)
      --
      -- Telescope의 프리뷰 창을 스크롤하는 것과 정확히 같은 개념
      -- cf) telescope에서도 default로 <C-u> (up), <C-d> (down)이 preview window 내용을 스크롤 한다.
      --
      -- opts.keymap.preset='default'에는
      -- 이 스크롤 단축키가 완전히 누락되어 있습니다.
      -- 따라서, 사용자가 직접 명시적으로 추가해 두어야 한다.
      --
      -- cf) Blink.cmp 공식 명세를 보면, `preset = 'default'` 가 기본으로 제공하는 키는 오직 아래의 기능들뿐입니다.
      --
      -- * `<C-space>`: 자동완성 및 문서 창 토글
      -- * `<C-e>`: 창 닫기
      -- * `<C-y>`: 선택 확정
      -- * `<C-n>` / `<C-p>`: 위아래 이동
      -- * `<C-k>`: 시그니처 헬프(매개변수 가이드) 토글
      --}}}
      -- -----------------------
      --
      -- 자동완성 문서 설명창이 길 때 위/아래로 스크롤하는 단축키
      -- 창이 열려있지 않을 때는 원래 Neovim의 반 페이지 스크롤(fallback)로 정직하게 작동합니다.
      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
      -- {{{
      -- 원래 <C-Space>가 동작되어 documentation window가 toggle 되어야 하나, 뭔지 모를 원인 때문에, 동작하지 않는다.
      -- 그래서 <C-Space> 대신 <C-o>로 문서 창을 토글한다.
      -- documentation window에 관련된 스크롤 키(<C-u>, <C-d>)와 완벽한 대칭을 이루도록, <C-o>를 누르면 문서 창이 열리고 닫히도록 명시적으로 설정
      -- 자동완성 메뉴가 켜져 있을 때 <C-o>를 누르면 설명서 창이 시원하게 툭 튀어나옵니다.
      -- }}}
      ['<C-o>'] = { 'show_documentation', 'hide_documentation' },


      -- 자동완성 창을 수동으로 열거나 닫고 싶을 때를 위한 추가 권장 키맵
      -- 기본 <C-Space> 자리는 혹시 모르니 원래 순정 기능 세트로 안전하게 복구해 둡니다.
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      -- ['<C-space>'] = { 'show', 'show_documentation', 'hide' },
      ['<C-e>'] = { 'hide' },
      ["<Esc>"] = { "hide", "fallback" },

      -- by stc end
      -- ---------------------------------------

      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    },


    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    -- 4. UI 및 디자인 설정
    completion = {
      -- -----------------
      -- by stc
      -- 목록이 처음 나왔을 때 자동으로 첫 번째 항목이 선택(하이라이트)되지 않도록 하고,
      -- 자동완성 목록 후보들을 위/아래로 탐색할 때, 해당 후보 글자가 입력창에 보이게/안보이게 설정 하기
      list = {
        selection = {
          -- --------------
          -- 목록이 처음 나왔을 때 자동으로 첫 번째 항목이 선택(하이라이트)되지 않도록 합니다.
          -- preselect = false: 스니펫 키워드를 입력해 목록이 팝업되었을 때, 첫 번째 항목에 파란색 등의 하이라이트가 들어가지 않도록 막아줍니다 
          preselect = false,          -- 자동 선택 비활성화, -- 자동 첫 번째 항목 하이라이트 방지 
          -- auto_insert = false,         -- 입력창에 자동 삽입 비활성화, -- 글자가 명령줄이나 본문에 멋대로 끼어드는 것 방지
          auto_insert = true,         -- 입력창에 자동 삽입 활성화, 즉 보이게 함.
          -- --------------
        }
      },
      -- by stc, end
      -- -----------------


      -- By default, you may press `<c-space>` to show the documentation.
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
      -- documentation = { auto_show = true, auto_show_delay_ms = 500 },
      -- {{{
      -- auto_show = true : 자동완성 창이 뜰 때 설명서 창이 (documentation widnow) 자동으로 함께 나오게 핞다.
      -- auto_show = false : 자동완성 창이 뜰 때 설명서 창이 (documentation widnow) 안 나옴
      --
      -- <C-space>와의 관계
      -- 1. **자동완성 창이 아예 안 열렸을 때** `<C-space>`를 누르면: 자동완성 팝업창이 강제로 열립니다.
      -- 2. **자동완성 창은 열렸는데 문서 창(설명서)이 안 보일 때** `<C-space>`를 다시 한번 누르면: 토글(Toggle) 기능이 작동하면서 숨겨져 있던 **문서 창이 옆에 슥 나타납니다.**
      --
      -- 즉, 현재 세팅에서는 자동완성이 뜬 상태에서 특정 함수에 대한 자세한 설명(정의)을 읽고 싶을 때 `<C-space>`를 눌러 설명서를 소환하는 구조입니다.
      -- }}}

      -- --------------------
      -- by stc

      -- 자동완성 팝업창의 레이아웃과 구성을 정의
      -- 메뉴 창 설정
      menu = {
        draw = {
          -- 가로 레이아웃 구성: 아이콘(kind_icon), 이름(kind), 단어(label)의 순서를 배치합니다.
          columns = {
            { 'kind_icon', 'kind', gap = 1 },
            { 'label', 'label_description', gap = 1 },
            { 'source_name' }, -- 맨 우측에 [LSP], [Path] 등을 배치
          },
          -- columns = {
          --   { 'kind_icon', gap = 1 },
          --   { 'label', 'label_description', gap = 1 },
          --   { 'source_name' },
          -- },
          -- ---------------------------------------------------
          -- {{{ 자동완성 목록 (레이아웃 구성) 변화를 주고자 할 때
          --
          -- 위 코드에서의 레이아웃 구성 : 
          -- 아이코(kind_icon) + 글자로 된 타입이름(kind, 예: Function, Variable) + 자동완성목록 + source_name
          -- 
          -- 여기에서 '글자로 된 타입이름'을 빼고, 그냥 
          -- 아이콘 + 자동와넝목록 + source_name
          -- 으로만 구성하고 싶다면, columns 내부 설정을 아래처럼 고치면 된다
          --
          -- columns = {
          --   { 'kind_icon', gap = 1 },
          --   { 'label', 'label_description', gap = 1 },
          --   { 'source_name' },
          -- },
          --
          -- ---------------------------------------------------
          -- }}}

          components = {
            -- 2. 각 소스별로 보여줄 예쁜 이름(꼬리표)을 커스텀 정의합니다.
            source_name = {
              text = function(ctx)
                local aliases = {
                  lsp = '[LSP]',
                  path = '[Path]',
                  snippets = '[Snippet]',
                  buffer = '[Buffer]',
                }
                return aliases[ctx.source_name] or ('[' .. ctx.source_name .. ']')

              end,
              highlight = 'BlinkCmpSource', -- 스킨(하이라이트) 적용
            },
          },
        },
      },
      -- by stc end
      -- --------------------
    },  -- completion end

    -- 자동완성 소스 설정 (데이터를 어디서 가져올 것인가)
    sources = {
      -- 기본 에디터 창에서 사용할 소스들
      -- 기본적으로 사용할 소스들의 우선순위 목록입니다.
      -- buffer는 없어도 될 듯 하다. 위에서 <C-n>, <C-p>를 vanilla nvim 설정으로 초기화 했기 때문에, buffer에 대한 자동완성이 필요한면, 그냥 <C-n>, <C-p>를 이용하면 될 듯 하다.
      default = { 'lsp', 'path', 'snippets' },
      -- default = { 'lsp', 'path', 'snippets', 'buffer' },
      --
      -- path : 파일 시스템의 경로를 자동으로 완성해 주는 기능 제공
      -- 코드나 텍스트를 작성하다가 /나 ./, ../ 등을 입력하면 blink.cmp가 파일 시스템을 탐색하여 완성 창을 띄워줍니다.

    },


    -- ---------------------------------------------------
    -- by stc
    -- 명령행(Cmdline) 완성 전용 설정
    -- cmdline: 명령줄 (Neovim에서 :, /, ? 등을 눌러 진입하는 모든 하단 입력창)
    -- blink.cmp 명령줄(cmdline) 전용 독립 설정
    -- --------------------------------------------------
    cmdline = {
      -- to inherit the mappings from the top level keymap
      -- 1. 위에서 정의한 <C-j> / <C-k> 등등의  키맵들을 명령줄 모드에서도 그대로 '상속'받습니다.
      keymap = { preset = 'inherit' },

      -- 2. 명령줄에 글자를 입력할 때 자동완성 목록 창이 자동으로 팝업되도록 설정합니다.
      -- 자동완성 메뉴가 자동표시, cf) tfalse
      completion = {
        menu = { auto_show = true },

        -- 명령줄 모드 리스트의 첫 번째 항목도 수동 선택 모드로 강제 지정합니다.
        list = {
          selection = {
            preselect = false,    -- 명령줄 창이 떠도 아무것도 하이라이트 하지 않음
            -- auto_insert = false,  -- 텍스트가 임의로 명령줄에 채워지는 것 방지
            auto_insert = true,  -- 텍스트가 임의로 명령줄에 채워지게 함.
          }
        },
      },

      -- 3. 명령줄에서 사용할 소스 
      -- sources = { 'cmdline' },
      -- 3. 명령줄에서 사용할 소스 (명령어 전용 'cmdline'과 파일 경로 전용 'path'를 함께 사용)
      -- sources = { 'cmdline', 'path' },
      -- 명령어 입력(:) 모드일 때만 'cmdline'과 'path'를 안전하게 활성화합니다.
      sources = function()
        local type = vim.fn.getcmdtype()
        -- 명령어 입력(:) 모드일 때만 cmdline과 path 소스를 사용
        if type == ':' then
          return { 'cmdline', 'path' }
        end
        return {}
      end,

      -- --------
      -- {{{ cf) 확장:
      -- Neovim에서 '명령줄(cmdline)'이라고 부르는 공간은 사실 하나가 아니라 여러 개가 있습니다.
      -- : 모드: 파일 열기, 저장, 플러그인 명령 등을 입력하는 명령어 입력 창
      -- / 또는 ? 모드: 본문 안에서 특정 텍스트를 찾는 검색 창
      --
      -- 확장: 나중에 "나는 / 검색 모드일 때는 전체 버퍼 단어 완성(buffer)을 쓰고 싶다"라는 생각이 들면, if 문 구조에서는 아래처럼 아주 쉽게 확장할 수 있습니다.
      -- sources = function()
      --   local type = vim.fn.getcmdtype()
      --   if type == ':' then
      --     return { 'cmdline', 'path' } -- 명령어 칠 때는 경로와 명령어 완성
      --   elseif type == '/' or type == '?' then
      --     return { 'buffer' }          -- 검색할 때는 현재 문서 안의 단어만 완성
      --   end
      --   return {}
      -- end
      -- }}}

    },
    -- cmdline 설정 끝
    -- by stc, end
    -- ---------------------------------------------------

    -- 스니펫 엔진 설정 
    snippets = { preset = 'luasnip' },  -- 위에서 설정한 LuaSnip을 사용
    -- snippets = { preset = 'default' }, == 내장 스니펫 엔진 활성화 (Luasnip을 거치지 않아 충돌이 없음), 따러서 LuaSnip을 사용하지 않으므로, 위의 dependancies안의 LuaSnip은 필요없음.

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    --
    -- By default, we use the Lua implementation instead, but you may enable
    -- the rust implementation via `'prefer_rust_with_warning'`
    --
    -- See :h blink-cmp-config-fuzzy for more information
    fuzzy = { implementation = 'lua' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  },

  -- -----------------------------------------------------------------
  -- by stc
  config = function(_, opts)
    require("blink.cmp").setup(opts)
  end,
  -- by stc
  -- -----------------------------------------------------------------

}



-- vim: set foldmethod=marker foldmarker={{{,}}}:
