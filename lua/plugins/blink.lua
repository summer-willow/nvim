return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',

  dependencies = {
    { "L3MON4D3/LuaSnip" },

    -- for obsidian.nvim
    -- "saghen/blink.cmp-obsidian", -- 이 의존성을 추가하세요
    "saghen/blink.compat", -- nvim-cmp 호환 레이어 추가
  },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      -- {{{
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
      -- cf) All presets have the following mappings:
      --
      -- *  <tab>/<s-tab>: move to right/left of your snippet expansion (by LuaSnip plugin)
      -- *  <c-space>: Open menu or open docs for if already open, 자동완성 및 문서 창 토글
      -- *  <c-e>: Hide menu, 자동완성 창 닫기
      -- *  <C-y>: 선택한 아이템 확정(Accept)
      -- *  <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- *  <c-k>: Toggle signature help (매개변수 가이드)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      --
      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      --
      -- }}}
      preset = 'default',

      -- ---------------------------------------
      -- {{{
      -- ['<CR>'] = {
      --    function(cmp)
      --      if cmp.is_visible() and cmp.get_selected_item() then
      --        return cmp.accept()
      --      else
      --        return false
      --      end
      --    end,
      --    'fallback',
      -- },
      -- }}}
      ["<CR>"] = { "accept_and_enter", "fallback" },
      -- ["<CR>"] = { "accept", "fallback" },

      -- -------------------------------------
      -- snippet placehold jump:
      -- {{{
      -- 조합형 스니펫 용으로 쓸 예정.
      -- (Latex/Markdown의 수식용은 <Tab>/<S-Tab>을 사용)
      -- }}}
      ['<C-l>'] = { 'snippet_forward', 'fallback' },
      ['<C-h>'] = { 'snippet_backward', 'fallback' },
      -- Or, as redundancies
      -- ['<C-f>'] = { 'snippet_forward', 'fallback' },
      -- ['<C-b>'] = { 'snippet_backward', 'fallback' },
      -- ==> Choice Node(선택형 노드) cycling 에서 <C-f>가 쓰임

      -- ---------------------------------------
      -- 자동완성 창 목록 이동은 C-n, C-p ==> C-j, C-k로
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },

      -- 기존 default 프리셋에 묶여있던 <C-n>, <C-p>의 기능을 명시적으로 해제.
      -- {{{
      -- 결과적으로, 이제 <C-n>과 <C-p>는 vanilla nvim의 기능인 단어완성 기능만 수행한다.
      -- vanilla nvim:의 (순정 상태의 nvim) 기본 기능인,
      -- 현재 버퍼(파일)와 열려 있는 다른 버퍼에 있는 단어들을 기반으로 단어를 완성해 주는 기능이 수행.
      -- <C-p>: previous completion (이전 완성 후보)
      -- <C-n>: next completion (다음 완성 후보)
      --
      -- :h i_CTRL-N, :h i_CTRL-P
      -- vaniila nvim 내장 자동완성 전체 시스템과 더 다양한 완성 옵션(경로 완성, 사전 완성 등)에 대해 깊게 알아보고 싶다면
      -- :help ins-completion
      --
      -- (그래서 sources.default={'lsp','path', 'snippets'}에서 buffer가 빠진것이다.)
      -- }}}
      ['<C-n>'] = {},
      ['<C-p>'] = {},

      -- ---------------------------------------
      -- document window toggle
      -- {{{
      -- 자동완성 메뉴가 켜져 있을 때 <C-o>를 누르면 설명서 창이 toggle (open/close)
      -- 원래 <C-Space>가 동작되어 documentation window가 toggle 되어야 하나,
      -- 하지만 윈도우 OS에서는 <C-Space>가 키 값을 갖조 않기 때문에, 동작하지 않는다.
      -- 그래서 <C-Space> 대신 <C-o>로 문서 창을 토글한다.
      -- }}}
      ['<C-o>'] = { 'show_documentation', 'hide_documentation' },
      -- 기본 <C-Space> 자리는 혹시 모르니 원래 순정 기능 세트로 안전하게 복구해 둡니다.
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },

      -- ---------------------------------------
      -- documentation window 내 scrolling
      -- {{{
      -- cf) telescope에서도 default로 <C-u> (up), <C-d> (down)이 preview window 내용을 스크롤 한다.
      -- 창이 열려있지 않을 때는 원래 Neovim의 반 페이지 스크롤(fallback)로 정직하게 작동합니다.
      --}}}
      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },

      -- ---------------------------------------
      -- 자동완성 창을 수동으로 열거나 닫고 싶을 때를 위한 추가 권장 키맵
      -- ['<C-e>'] = { 'hide' },
      ['<C-e>'] = { 'hide', 'show' },
      ["<Esc>"] = { "hide", "fallback" },

      -- ---------------------------------------
      -- 수식 전용: <Tab>/<S-Tab>
      --
      -- <Tab> 키는 오직 스니펫 점프와 확장만 수행.

      -- {{{ ejmastnk 방식으로 전환
      -- https://ejmastnak.com/tutorials/vim-latex/luasnip/
      -- 고속 수식 typeset을 위해서:
      -- 일반 단어 자동완성(LSP) 흐름과 수식 스니펫(LuaSnip) 흐름을 분리.
      -- 탭 키는 오직 "수식 스니펫 확장 및 placeholder 점프"로만 이용
      -- }}}

      -- ---------------------------------------
      -- {{{ cf) 나의 기존 설정
      -- [ 탭(Tab) 키: 이동, 스니펫 점프, 일반 탭 ]
      -- ['<Tab>'] = {
      --    function(cmp)
      --      if cmp.is_visible() then return cmp.select_next() end
      --      if cmp.snippet_active() then return cmp.snippet_forward() end
      --      -- 동작 우선순위: 스니펫 jump 중이라도 자동완성 목록(cmp.is_visible())이 뜨면 Tab은 이동을 우선
      --    end,
      --    'fallback',
      -- },
      -- ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },

      -- [ 역탭(Shift-Tab): 역이동, 역점프 ]
      -- ['<S-Tab>'] = {
      --    function(cmp)
      --      if cmp.is_visible() then return cmp.select_prev() end
      --      if cmp.snippet_active() then return cmp.snippet_backward() end
      --    end,
      --    'fallback',
      -- },
      -- ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      --
      -- 내 기존 설정: 자동완성 창이 열려 있으면 창 안에서 다음 후보로 이동(select_next)하는 것이 최우선입니다. 창이 닫혀 있거나 후보가 없을 때만 LuaSnip 스니펫의 다음 칸으로 점프(snippet_forward)합니다.
      -- }}}

      -- ---------------------------------------
      -- {{{ cf) accept, select, expand 기능의 차이점
      -- * expand (확장): trigger 단어(예: LaTeX에서 ff를 입력하면 \frac{}{} 로 바뀌는 것)를 실제 스니펫 템플릿으로 변환하는 행위입니다.
      -- * select (탐색/하이라이트): 자동완성 팝업창이 떴을 때, 위아래로 움직이며 후보군 중 하나를 조준(하이라이트)하는 행위입니다. 아직 본문에 글자가 확정되어 박힌 것은 아닙니다.
      -- * accept (확정): 조준된(선택된) 자동완성 후보를 내 코드에 최종적으로 입력하는 행위입니다. 만약 선택된 후보가 스니펫이라면, accept하는 순간 내부적으로 expand까지 동시에 일어납니다.

      -- cf)
      -- expand는 'LuaSnip 엔진'의 명령이고, accept는 'blink.cmp(자동완성 창) 엔진'의 명령입니다
      -- accept는 **자동완성 팝업창이 떠 있을 때** blink에게 안전하게 확정을 맡기는 최고의 선택이 맞습니다. (cmp.hide와 schedule 불필요)
      -- expand는 팝업창 없이 순수 타이핑 글자만으로 스니펫을 강제 작동시킬 때 필요한 LuaSnip 전용 무기입니다. (cmp.hide와 schedule 필수)
      -- }}}
      -- ---------------------------------------
      -- original <Tab> setting
      ["<Tab>"] = {
        function(cmp)
          -- {{{
          --  "지금 내 커서 자리에 확장할 수 있는 단어가 있다면, 현재 스니펫 목록창이 켜져 있든 말든 무조건 확장(expand)을 먼저 해라"
          --
          -- LuaSnip에 등록된 단축어라면 blink 우회해서 즉시 확장
          -- 오직 순수한 LuaSnip 스니펫 단축어일 때만 확장. (trigger가 정확히 일치할 때만 동작)
          --
          -- 자동완성 창이 열린 상태에서 외부 플러그인(LuaSnip)으로 글자를 바꾸려면 다음 2단계 단계를 밟아야만 합니다.
          -- 1. blink.cmp 창을 닫아서 Neovim의 잠금(TextLock)을 푼다. (cmp.hide())
          -- 2. 잠금이 완전히 풀리는 아주 미세한 순간을 기다렸다가 텍스트를 바꾼다. (vim.schedule())
          -- }}}

          -- LuaSnip 확장 가능 여부 검사 및 실행
          if require("luasnip").expandable() then
            -- 자동완성 팝업창(blink)이 떠 있는 상태에서 외부 엔진(LuaSnip)이 본문 글자를 강제로 바꾸려고 하면 에디터가 충돌을 일으킵니다(TextLock 에러).
            -- cmp.hide(): blink의 자동완성 창을 닫아 버퍼 잠금(TextLock)을 안전하게 해제
            cmp.hide()  -- blink 창을 닫아 Neovim의 TextLock(버퍼 잠금)을 해제

            -- {{{
            -- 버퍼 락이 풀린 직후 안전하게 실행되도록 vim.schedule로 감싸줍니다.
            -- vim.schedule(): Neovim이 팝업창을 닫는 내부 정리를 완벽히 끝마친 바로 다음 밀리초(ms)에 LuaSnip 코드가 실행되도록 실행 순서를 안전하게 뒤로 미뤄주는 안전장치입니다.
            -- }}}
            vim.schedule(function()
              require("luasnip").expand()
            end)
            return true -- blink에게 이 키 입력을 처리했음을 알리고 루프 종료
          end

          -- ---------------
          -- [2단계] 확장할 단어는 없지만, 이미 스니펫 플레이스홀더 내부에 진입해 있는 상태라면 다음 칸으로 점프
          -- 이미 스니펫 안에서 점프 중이라면 다음 칸으로 점프
          if cmp.snippet_active() then
            return cmp.snippet_forward()
          end
        end,

        "fallback" -- 둘 다 해당 안 되면 순정 탭 들여쓰기
      },

      -- [역탭 키] 이전 칸으로 점프
      ["<S-Tab>"] = { "snippet_backward", "fallback" },

      lights = {},  -- ?????

    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    -- 4. UI 및 디자인 설정
    completion = {
      -- {{{
      -- completion.list.selection.preselect=false/true :
      -- 목록이 처음 나왔을 때 자동으로 첫 번째 항목이 선택(하이라이트)되게 하거나/선택되지 않도록 설정,
      --
      -- completion.list.selection.auto_insert=true/false :
      -- 자동완성 목록 후보들을 위/아래로 탐색할 때, 해당 후보 글자가 입력창에 보이게/안보이게 설정
      -- }}}
      list = {
        selection = {
          -- --------------
          preselect = false,  -- 자동 선택 비활성화, 
          auto_insert = false,  -- 입력창에 자동 삽입 활성화, 즉 보이게 함.
        }
      },

      -- By default, you may press `<c-space>` to show the documentation.
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      -- 문서/미리보기 창이 목록 창 옆에 자동으로 뜨도록 설정
      -- documentation = { auto_show = false, auto_show_delay_ms = 500 },
      documentation = {
        -- 다른 키를 누르지 않아도 목록 창이 뜨면 자동으로 옆에 정보를 보여줍니다.
        auto_show = true,
        -- 커서를 움직이자마자 즉시 반응하도록 딜레이를 0초(또는 아주 짧게)로 설정합니다.
        auto_show_delay_ms = 50,

        -- 미리보기 창의 크기 및 테두리 스타일 설정
        window = {
          border = 'rounded', -- 깔끔한 둥근 테두리
          max_width = 60,
          max_height = 20,
        },
      },

      -- 자동완성 팝업창의 레이아웃과 구성을 정의
      menu = {
        draw = {
          columns = {
            { 'kind_icon', 'kind', gap = 1 },
            --   { 'kind_icon', gap = 1 },
            { 'label', 'label_description', gap = 1 }, -- 여기서 label_description을 그립니다.
            { 'source_name' }, -- 맨 우측에 소스이름([LSP], [Path] 등)을 배치
          },
          -- {{{
          -- 위 코드에서의 레이아웃 구성 : 
          -- 아이코(kind_icon) + 글자로 된 타입이름(kind, 예: Function, Variable) + 자동완성목록 + source_name
          --
          -- cf) 여기에서 '글자로 된 타입이름'을 빼고, 그냥 
          -- 아이콘 + 자동와넝목록 + source_name
          -- 으로만 구성하고 싶다면, columns 내부 설정을 아래처럼 고치면 된다
          -- columns = {
          --   { 'kind_icon', gap = 1 },
          --   { 'label', 'label_description', gap = 1 },
          --   { 'source_name' },
          -- },
          -- }}}

          components = {
            -- source_name 의 모양을 custom 정의
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

    },  -- completion end

    -- 자동완성 소스 설정 (데이터를 어디서 가져올 것인가)
    sources = {
      -- 기본 에디터 창에서 사용할 소스들
      -- default = { 'lsp', 'path', 'snippets', 'buffer' },
      -- default = { 'lsp', 'path', 'snippets' },
      -- {{{ buffer source가 필요할 때
      -- buffer는 없어도 될 듯 하다. 위에서 <C-n>, <C-p>를 vanilla nvim 설정으로 초기화 했기 때문에, buffer에 대한 자동완성이 필요한면, 그냥 <C-n>, <C-p>를 이용하면 된다.
      -- }}}
      -- {{{ path source 사용법
      -- path : 파일 시스템의 경로를 자동으로 완성해 주는 기능 제공
      -- 코드나 텍스트를 작성하다가 /나 ./, ../ 등을 입력하면 blink.cmp가 파일 시스템을 탐색하여 완성 창을 띄워줍니다.
      -- }}}





      -- default 목록에 obsidian 추가
      default = { "lsp", "path", "snippets", "obsidian" },
      providers = {
        obsidian = {
          name = "obsidian",
          module = "blink.compat.source",
        },
      },




    },

    -- ---------------------------------------
    -- 명령행(Cmdline) 완성 전용 설정
    -- cmdline: 명령줄 (Neovim에서 :, /, ? 등을 눌러 진입하는 모든 하단 입력창)
    -- blink.cmp 명령줄(cmdline) 전용 독립 설정
    -- ---------------------------------------
    cmdline = {
      -- 위에서 정의한 <C-j> / <C-k> 등등의  키맵들을 명령줄 모드에서도 그대로 '상속'받습니다.
      keymap = { preset = 'inherit' },

      -- 명령줄에 글자를 입력할 때 자동완성 목록 창이 자동으로 팝업되도록 설정
      completion = {
        menu = { auto_show = true },

        list = {
          selection = {
            preselect = false,    -- 명령줄 창이 떠도 아무것도 하이라이트 하지 않음
            auto_insert = true,   -- 텍스트가 임의로 명령줄에 채워지게 함.
          }
        },
      },

      -- 명령줄에서 사용할 소스
      -- 명령어 입력(:) 모드일 때만 'cmdline'과 'path'를 활성화
      sources = function()
        local type = vim.fn.getcmdtype()
        if type == ':' then
        -- (명령어 전용 'cmdline'과 파일 경로 전용 'path'를 함께 사용)
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

    -- ---------------------------------------
    -- 스니펫 엔진 설정 
    -- 🌟 [핵심 수정] 외부/LSP 스니펫의 모든 제어권을 LuaSnip 엔진으로 강제 리다이렉트
    snippets = {
      preset = 'luasnip', -- LuaSnip을 사용하도록 연결

      -- ---------------------------------------
      -- {{{
      -- 아래 추가 코드는 왜 들어간 것이고, 무슨 역할을 하나요?
      --
      -- blink.cmp 설정에서 preset = 'luasnip'만 적어두면, blink는 기본적으로 "네가 직접 Lua 파일(tex.lua)에 코딩한 스니펫"들만 LuaSnip 엔진으로 관리합니다.
      --
      -- 하지만 에디터를 쓰다 보면 내가 직접 짜지 않은 스니펫들도 만납니다.
      --
      --   - friendly-snippets 플러그인에 들어있는 수만 개의 VSCode 형식 JSON 스니펫
      --   - rust-analyzer, pyright, LaTeX-LSP(texlab) 같은 LSP 서버가 자동완성 창에서 던져주는 완성형 스니펫
      --
      -- blink.cmp는 이 외부 스니펫들을 만났을 때, LuaSnip에게 넘기지 않고 자신이 가진 순정 내장 내비게이션(Blink Native Engine)으로 직접 렌더링하고 처리해 버립니다.
      --
      -- 이를 막고, "외부 JSON이든 LSP가 주입한 스니펫이든 묻지도 따지지도 말고 무조건 LuaSnip 엔진이 통제하게 만들어라" 하고 blink의 팔을 뒤로 꺾어 LuaSnip에게 주도권을 강제로 넘겨주는 안전장치가 바로 그 코드들입니다.
      --
      --   - expand: LSP가 준 스니펫 문법을 LuaSnip 고유 포맷(lsp_expand)으로 변환해 터뜨립니다.
      --   - active: 현재 커서가 LuaSnip 스니펫 범위 안에 있는지 감시합니다.
      --   - jump: 플레이스홀더 간 이동을 blink 내장 기능이 아니라 LuaSnip의 내장 jump 함수로 실행합니다.
      --
      -- 즉, 아래 덧붙여진 expand, active, jump 함수들은 "LSP(언어 서버)가 던져주는 표준 스니펫이나 VSCode 형식(JSON/코드 팩)의 스니펫을 LuaSnip 엔진으로 강제 리다이렉트(토스)하기 위해" 존재합니다.
      -- 즉, 이 블록은 "LSP나 다른 외부에서 들어오는 모든 스니펫 제어권도 전부 LuaSnip 너가 도맡아서 처리해라"라고 교통정리를 해주는 전역 허브이기 때문에 반드시 유지해야 합니다.
      -- }}}
      -- ---------------------
      -- snippets 리다이렉트 블록
      expand = function(snippet)
        require("luasnip").lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require("luasnip").jumpable(filter.direction)
        end
        return require("luasnip").in_snippet()
      end,
      jump = function(direction)
        require("luasnip").jump(direction)
      end,
      -- ---------------------
      -- ---------------------------------------

    },

    -- {{{ cf) snippets = { preset = 'default' },
    -- snippets = { preset = 'default' }, ==> 내장 스니펫 엔진 활성화 (Luasnip을 거치지 않아 충돌이 없음), 따러서 LuaSnip을 사용하지 않으므로, 위의 dependancies안의 LuaSnip은 필요없음.
    -- }}}

    -- ---------------------------------------
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

  config = function(_, opts)
    require("blink.cmp").setup(opts)

    -- {{{
    -- -------------------------------------------------
    -- Neovim 순정 키 매핑(config 내부)
    -- config 함수 내부에서 Neovim 고유의 인터셉터(vim.keymap.set)를 사용하는 것.
    -- 최우선 순위 권한: Neovim 순정 키 매핑은 blink.cmp가 키 입력을 감지하고 연산을 시작하기 바로 전 단계에서 키를 낚아체어, blink.cmp가 자동완성 팝업을 띄우려고 대기줄(Queue)을 계산하기 직전 단계에서 먼저 발동합니다.
    -- cf) 'jk' 키맵핑은 타이밍 대기가 필요한 다중 문자 조합이기 때문에, blink.cmp가 제공하는 keymap = { ... } 블록에서 설정하면, 무조건 동기화 버그가 발생.
    --
    -- -------------------------------------------------
    -- }}}
    -- Insert 모드와 Select 모드에서 jk를 누르면 LuaSnip 다음 칸으로 점프 (없으면 jk 입력)
    vim.keymap.set({ "i", "s" }, "jk", function()
      -- LuaSnip이 아직 로드되지 않았을 경우를 대비한 안전장치
      local has_luasnip, luasnip = pcall(require, "luasnip")

      -- LuaSnip을 통해 다음 플레이스홀더로 점프가 가능한지 확인
      if has_luasnip and luasnip.jumpable(1) then
        -- 점프가 가능하면 안전하게 점프만 수행.
        -- blink보다 높은 우선순위에서 LuaSnip 점프를 실행하여 입력 버퍼 밀림을 원천 차단.
        luasnip.jump(1)
      else
        -- 점프할 곳이 없으면 본래 의도대로 jk를 입력 버퍼에 전달 (재귀 방지)
        -- 'n' 옵션을 주어 이 jk가 다시 이 매핑을 트리거하는 재귀 현상을 방지합니다.
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("jk", true, false, true), "n", false)
      end
    end, { silent = true })
    -- -------------------------------------------------

  end,
}


-- vim: set foldmethod=marker foldmarker={{{,}}} foldlevel=0 :
