-- Snippet Engine & LaTeX Extensions

return {
  'L3MON4D3/LuaSnip',

  -- ---------------------------------------
  -- {{{
  -- event = 'InsertEnter', -- 입력 모드로 진입할 때 지연 로딩하여 Neovim 켜지는 속도를 최적화합니다.
  -- ==> 수정
  -- 기존 'InsertEnter'(입력모드 진입 시 로드)는 켜지는 속도는 빠르나, 
  -- 문서를 열자마자 수식 환경($...$)을 탐색해야 하는 Tree-sitter 구문 분석 메커니즘과 
  -- 타이밍이 어긋나 자동 트리거가 무시되는 현상이 있습니다. 
  -- 안전하게 파일 버퍼를 읽는 시점('BufReadPost', 'BufNewFile')으로 전환합니다.
  -- }}}
  event = { 'BufReadPost', 'BufNewFile' },
  -- ---------------------------------------

  version = '2.*',
  build = (function()
    -- Build Step is needed for regex support in snippets.
    -- This step is not supported in many windows environments.
    -- Remove the below condition to re-enable on windows.
    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
    return 'make install_jsregexp'
  end)(),

  dependencies = {
    -- {{{
    --[[
    {
      -- `friendly-snippets` contains a variety of premade snippets.
      --    See the README about individual language/framework/plugin snippets:
      --    https://github.com/rafamadriz/friendly-snippets

      -- 스니펫 컬렉션
      'rafamadriz/friendly-snippets',
      config = function()
        -- ---------------------------------------
        -- loading snippets of friendly-snippets
        require('luasnip.loaders.from_vscode').lazy_load()

        -- ---------------------------------------
        local snippet_path = vim.fn.stdpath('config') .. '/snippets'

        -- custom JSON snippets load
        require('luasnip.loaders.from_vscode').lazy_load({
          paths = { snippet_path }
        })

        -- custorm lua snippets load
        require("luasnip.loaders.from_lua").lazy_load({
          paths = { snippet_path }
        })
      end,
    },
    --]]
    -- }}}
    -- {{{
    --[[
    {
      "iurimateus/luasnip-latex-snippets.nvim",

      -- 🌟 닷파일 유저들의 핵심 트릭: lazy 로딩을 false 처리하거나 
      -- 레이텍 전용 확장자(ft = "tex")로 명시해 순서를 강제합니다.
      ft = { "tex", "markdown" }, -- Load only on LaTeX and Markdown files
      config = function()
        -- 레이텍 소스 엔진 초기화
        require("luasnip-latex-snippets").setup({
          use_treesitter = true
        })

        -- 🌟 실제 유저 검증 핵심 가이드라인 코드:
        -- 외부 스니펫 라이브러리를 로드한 직후, LuaSnip 엔진에 새로 고침을 날려줍니다.
        require("luasnip").config.setup({})
      end,
    },
    --]]
    -- }}}
  },

  opts = {
    enable_autosnippets = true, -- 자동스니펫 (전역) 활성화

    -- Visual Selection Snippet Trigger(비주얼 선택 영역 스니펫 트리거) 기능 설정
    store_selection_keys = "<Tab>",

    update_events = "TextChanged,TextChangedI", -- 글자를 타이핑할 때마다 즉시 파싱
    ---- {{{
      --[[
      -- update_events = "TextChanged,TextChangedI",
      동적 스니펫(Dynamic Snippets)이 테스트가 변경된 순간에 즉시 수행되게 함.

      update_events: LuaSnip이 스니펫 내부의 플레이스홀더나 노드를 업데이트(동기화)하기 위해 감시하는 Neovim의 이벤트 설정입니다.
      textchanged: 일반 모드(Normal Mode)에서 텍스트가 변경되었을 때 발생하는 Neovim 이벤트입니다.
      textchangedi: 입력 모드(Insert Mode)에서 텍스트가 변경되었을 때 발생하는 Neovim 이벤트입니다.
      --]]
    ---}}}


    -- ----------------------------------------
    -- snippet 내 insert node들의 자동 들여쓰기 활성화
    -- 🌟 fmt/fmta로 생성되는 모든 스니펫이 현재 문서의 들여쓰기 규칙(tabstop/shiftwidth)를 따르도록 강제하여, 코드가 정돈되게 만듭니다.
    clean_meta_defaults = {
      -- 다른 메타 정보들과 함께 들여쓰기 자동 정렬을 기본 활성화
      indent = true,
    },
    -- {{{
    -- 개별 스니펫 정의 부분에서 직접 설정하려면:
    --
    -- clean_meta_defaults.indent = true ➔ snippets/tex.lua (개별 스니펫 파일의 add_snippets 세 번째 인자)로 이동가능하다.
    -- clean_meta_defaults.indent=true가 LaTeX 수식 텍스트 표현에만 직접 관여하는 로컬 텍스트 규칙이기 때문입니다.
    -- ls.add_snippets 함수는 세 번째 인자로 "해당 파일 타입 전체에 적용할 메타데이터(옵션)"를 넘겨받을 수 있습니다.
    -- 만약, ls.add_snippets() 함수의 세번째 인자로 넘기려면 다음과 같은 코드 구조가 된다.
    --   ls.add_snippets("tex", {
    --     -- 1. 여기에 스니펫 목록들이 들어갑니다.
    --           . . . . . 
    --   }, {
    --     -- 🌟 [핵심] 세 번째 인자: 이 파일('tex') 안의 스니펫들에만 적용될 로컬 메타데이터 설정
    --     key = "tex_normal", -- 스니펫 그룹 고유 키 (선택사항)
    --
    --     -- 💡 전역 설정을 덮어쓰고, 이 파일 내 모든 스니펫의 들여쓰기(indent)를 강제 활성화합니다.
    --     type = "snippets",
    --     clean_meta_defaults = {
    --       indent = true,
    --     }
    --   })
    -- }}}
    -- ----------------------------------------

    -- ----------------------------------------
    -- 스니펫 마지막 노드 이탈 시에도 세션 유지
    -- true로 설정해야 마지막 플레이스홀더에 도달했을 때도 세션이 유지된다.
    -- 스니펫의 마지막 노드에 도달하거나 잠시 커서를 이탈해도 스니펫 세션이 유지
    -- 필수 유지
    -- 플레이스홀더를 다 채우고 수식 바깥으로 나간 뒤에도, "앗 오타 났네" 하고 다시 Shift + Tab을 눌러 이전 스니펫 빈칸으로 되돌아갈 수 있게 해주는 기능
    -- LaTeX 타이핑 생산성에 매우 중요하므로 켜두는 것이 좋습니다.
    history = true,
    -- cf) history = true를 제외한 나머지 3개(keep_roots, link_roots, link_children)는 지우셔도 무방합니다
    -- ----------------------------------------


    -- ----------------------------------------
    -- {{{
    -- 스니펫 파일들이 로드될 때 자동으로 특정 변수들을 기본 탑재하기
    -- LuaSnip의 공식 전역 환경(snip_env) 활용
    --
    -- luasnip 설정안의 ship_env의 내용이 스니펫 등록 파일의 최상단에 자동연결된다. 단지 안보일 뿐이다. 덕분에 다수의 스니펫 등록파일에 일일히 적어놓을 필요가 없다.
    --
    -- "스니펫 파일들이 로드될 때 자동으로 특정 변수들을 기본 탑재해 주는 기능"을 공식적으로 제공합니다. 이 설정을 쓰면 스니펫 파일 상단에 아무것도 적지 않아도 s, t, i, fmt 등을 즉시 쓸 수 있습니다.
    -- 장점: Neovim 표준 사양이며, 외부 파일 관리 오버헤드가 전혀 없습니다. 스니펫 정의 파일이 매우 깔끔해집니다. (단, 개발 환경에 따라 컴포넌트 자동완성 주석 경고가 뜰 수 있으나 정상 작동합니다.)
    -- 이 설정을 쓰면 스니펫 파일 상단에 아무것도 적지 않아도 s, t, i, fmt 등을 즉시 쓸 수 있습니다.
    -- 2. 실제 스nippet 등록 파일에서 이제 선언부가 단 한 줄도 필요 없습니다. 곧바로 스니펫 정의를 시작하면 됩니다.
    -- ex)
    -- return {
    --   -- 수식 스니펫 예시
    --   s("alpha", t("\\alpha"), { condition = utils.cond.in_mathzone }),
    --
    --   -- 비주얼 헬퍼 스니펫 예시
    --   s("ff", {
    --     t("\\frac{"), i(1), t("}{"),
    --     d(2, utils.util.get_visual(2)),
    --     t("}")
    --   })
    -- }
    --
    -- NOTE: snip_env 주입 기능은 (snippets/ 폴더 밑에 있는) 순수 스니펫 등록 파일들(tex-test.lua 등)에만 자동 주입(연결)된다.
    -- 하지만, 유틸리티 모듈(헬퍼)은 스니펫 파일이 아니라 독립적인 루아 함수 라이브러리이므로,
    -- ship_env의 내용이 자동연결되지 않는다.
    -- 그러므로 유틸리티 모듈(헬퍼)에서는 직접 luasnip API 의존성을 명시해 주어야 한다.
    -- 즉, 헬퍼에 쓰인 luasnip API (s, sn, i 등등)를 써 넣어야 한다.
    --
    -- }}}

    -- 🚀 스니펫 로더가 파일을 읽을 때 자동으로 주입(연결)해 줄 전역 변수 목록
    -- ship_env를 이용한 동적 전역 변수 주입
    -- 오직 스니펫 등록 파일에만 적용된다.
    snip_env = {
      -- luasnip API 선언
      ls = require("luasnip"),
      s = require("luasnip").snippet,
      sn = require("luasnip").snippet_node,
      t = require("luasnip").text_node,
      i = require("luasnip").insert_node,
      f = require("luasnip").function_node,
      c = require("luasnip").choice_node,
      d = require("luasnip").dynamic_node,
      fmt = require("luasnip.extras.fmt").fmt,
      fmta = require("luasnip.extras.fmt").fmta,
      rep = require("luasnip.extras").rep,

      -- luasnip 유틸리티 모듈(helper)도 함께 적어 놓으면 무척 편리함
      utils = require("utils"),
      -- ----------------------------------------
    },

  },

  config = function(_, opts)
    local luasnip = require("luasnip")
    luasnip.setup(opts)

    -- 🌟 내가 직접 만든 루아 스니펫 경로 강제 지정 로드
    local snippet_path = vim.fn.stdpath('config') .. '/snippets'
    require("luasnip.loaders.from_lua").lazy_load({
      paths = { snippet_path }
    })

    -- 적용될 snippets 확장
    luasnip.filetype_extend("tex", { "tex" }) -- tex 자체 확장 보장
    luasnip.filetype_extend("markdown", { "tex" }) -- md 파일에 tex 스니펫을 공유
    -- luasnip.filetype_extend("python", { "matlab" })

    -- =========================================================================
    -- 🚀 [LuaSnip 전용 관리 키맵] 스니펫 외부 수정 후 즉시 리로드 (<Leader>L)
    -- from_lua.load() 사용: 단축키를 누를 때는 지연 로딩(lazy_load)이 아닌 즉시 강제 로딩(load)을 실행하여 변경 사항을 즉각 반영합니다.
    -- =========================================================================
    -- vim.keymap.set("n", "<Leader>rs", function() -- reload snippets
    vim.keymap.set("n", "<Leader>rl", function()  -- reload
      require("luasnip.loaders.from_lua").load({ paths = { snippet_path } })
      vim.notify("LuaSnip 스니펫 리로드 완료!", vim.log.levels.INFO, { title = "LuaSnip" })
    end, { desc = "Reload LuaSnip snippets" })


    -- ----------------------------------------
    -- choice node cycling
    -- Choice Node(선택형 노드) 실시간 순환(Cycle) 설정
    -- 선택형 노드 순환 (<C-f>)
    -- method 1
    -- running Vimscript from within Lua files --> vim.cmd[[ " Vimscript goes here! ]]
    -- vim.cmd[[
    --  "Cycle forward through choice nodes with Control-f (for example)
    -- imap <silent><expr> <C-f> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-f>'
    -- smap <silent><expr> <C-f> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-f>'
    -- ]]
    -- ----------------------------------------
    -- Vimscript 문법 대신 순수 Lua API(vim.keymap.set)로 바꿈
    -- method 2
    -- Choice Node(선택형 노드) 실시간 순환 설정 (<C-f>)
    -- Insert 모드('i')와 Select 모드('s') 모두에 매핑 적용
    vim.keymap.set({ "i", "s" }, "<C-f>", function()
      if luasnip.choice_active() then
        luasnip.change_choice(1)
      else
        -- Choice Node 상태가 아닐 때는 원래 <C-f> 키 입력 수행
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-f>", true, false, true), "n", true)
      end
    end, { silent = true, desc = "LuaSnip Choice Node Cycle Forward" })
    -- ----------------------------------------

  end,

}



-- vim: set foldmethod=marker foldmarker={{{,}}} foldlevel=0 :
