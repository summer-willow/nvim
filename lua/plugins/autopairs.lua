-- Autopairs Configuration (with blink.cmp & Treesitter Integration)
-- -----------------------------------------------------------------
-- 타이핑 시 실시간으로 괄호 쌍을 맞춰주는 핵심 플러그인 설정입니다.
-- nvim-surround(선택 영역 감싸기) 및 LuaSnip과 충돌 없이 공존합니다.
-- -----------------------------------------------------------------

return {
  "windwp/nvim-autopairs",
  -- 인서트 모드(글자 입력 상태)로 진입할 때 지연 로딩(Lazy Load)하여 시작 속도를 최적화합니다.
  event = "InsertEnter",

  config = function()
    local autopairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    -- local ts_conds = require("nvim-autopairs.ts-conds")
    local conds = require("nvim-autopairs.conds") -- 일반 텍스트 조건 모듈 로드

    autopairs.setup({
      -- 1. Treesitter 연동 활성화 (가장 중요)
      -- {{{
      -- 문맥을 파악하여 코드 구문 구조에 따라 똑똑하게 작동하도록 만듭니다.
      -- }}}
      check_ts = true,
      ts_config = {
        -- {{{
        -- 특정 언어의 '문자열(string)'이나 '주석(comment)' 노드 안에서는 
        -- 괄호 자동 완성이 오작동하지 않도록 비활성화 영역을 지정합니다.
        -- }}}
        lua = { "string", "source" }, -- lua 파일의 string 노드 안에서는 작동 안 함
        javascript = { "string", "template_string" }, -- JS 문자열 안에서 작동 안 함
        typescript = { "string", "template_string" },
        java = { "string" },
      },

      -- 2. 글자 중간 삽입(Ignored Next Char) 예외 처리
      -- {{{
      -- 커서 바로 오른쪽에 알파벳(%w), 마침표(%.), 샵(%#), 언더바(%_) 등이 붙어있으면 
      -- 기존 코드를 수정/감싸는 중이라 판단하여 닫는 괄호를 자동으로 만들지 않습니다.
      -- 이 옵션의 의미: "커서 바로 뒤(오른쪽)에 알파벳, 숫자, 마침표, 샵, 언더바가 있을 때만 자동 완성을 하지 마라."
      -- }}}
      ignored_next_char = "[%w%.%#%_]",

      ---- -----------------------------------------------------------------
      -- 3. 동일한 줄(Line) 내부의 괄호 쌍 검사 활성화
      -- {{{
      -- true로 설정하면, (  |)) 처럼 같은 줄 오른쪽에 이미 닫는 괄호가 
      -- 여유 있게 존재할 때 (를 추가로 입력해도 닫는 괄호를 새로 만들지 않습니다.
      -- }}}
      enable_check_bracket_line = true,

      -- 4. 특정 filetype에서 autopairs 비활성화
      -- {{{
      -- Telescope 검색창이나 특정 플러그인 패널 안에서는 괄호 자동 생성을 끕니다.
      -- }}}
      disable_filetype = { 
        "TelescopePrompt", 
        "spectre_panel",
        -- ===================================================================
        -- 💡 [Option 2]: TeX 문서 전체에서 autopairs를 통째로 끄고 싶을 때 사용
        -- 아래 주석을 해제하면 .tex 파일 전체에서 괄호 자동 완성이 완전히 꺼집니다.
        -- ===================================================================
        -- "tex",
      },

      -- 5. Fast Wrap 기능 설정 (Alt + e)
      -- {{{
      -- 괄호를 열고 글자를 쳤는데, 알고 보니 우측 단어까지 감싸야 했을 때 유용합니다.
      -- 괄호 안에서 <A-e> (윈도우/리눅스는 Alt + e)를 누르면 우측 글자를 슥 삼키며 이동합니다.
      -- "아, 괄호를 먼저 열고 글을 썼어야 했는데!" 하고 후회하는 순간에 유용.
      -- 쉽게 말해, 내 커서 바로 왼쪽에 있는 괄호를 오른쪽으로 한 칸씩 슥슥 밀어 넣는 기능입니다.
      --
      -- {{{
      -- 사용법: (커서 위치 : |)
      -- ex) const message = |helloworld; 를
      -- const message = "hello"world; 처럼 " "로 감싸고 싶음.
      --
      -- cf) 약간 nvim-surround와 비슷한 개념이지만,
      -- nvim-autopairs는 insert mode에서 어는 부분을 bracketing을 하는 것이고
      -- nvim-surround는 이미 있는 bracket을 변경/삭제 등을 하는 것이다.
      --
      -- const message = |helloworld 에서 " 를 누르면
      -- 설정 ignored_next_char = "[%w%.%#%_]" 에 의해 " " 가 나오니 않고 그냥 하너의 " 만 입력된다.
      -- 여기서 닫힌 " 가 위치할 곳을 정해야 하는데
      -- <Alt>+e를 누르면 
      -- 설정 keys = "qwertyuiopzxcvbnmasdfghjkl" 에 의해
      -- 아래에 힌트문자(label)가 나타난다. 
      --
      -- <M-e>(Alt + e)를 누른 후, 화면에 뜨는 힌트 레이블(q, w, e...)과 방향 조절 키(h, l)를 조합해서 동작시킨다.
      --
      -- 원하는 위치에 해당하는 label 문자를 누르면, 다시 h과  l 이 나온다.
      -- nvim의 hjkl처럼, h는 left, l은 right를 나타낸다.
      -- 닫히는 "이 위치할 곳에 따라서 h 또는 l를 누르면 된다.
      -- 최종 커서 위치는 처음 autopairs 가 시작한 곳에 위치하게 된다.
      -- 즉, 
      -- const message = "|hello"world 가 된다.
      -- 만약 최종 컷 위치가 
      -- const message = "hello|"world 가 되길 원하면, 대문자 H 또는 L를 이용한다.
      --
      -- cf) nvim-surround 과의 관계
      -- nvim-surround: nvim-autopairs는 타이핑하는 순간에 실시간으로 쌍을 맞추고, nvim-surround는 이미 존재하는 텍스트를 감싸거나 변경(ysw))할 때 씁니다. 단축키 영역이 완전히 다르므로 아무런 충돌 없이 상호보완적으로 잘 작동합니다.
      -- nvim-surround와의 역할 분담: 
      -- 새로 코드를 타이핑할 때는 위의 nvim-autopairs가 작동하고, 이미 적어놓은 텍스트를 나중에 블록 지정하거나 단어 단위로 감싸고 싶을 때는 nvim-surround 명령문(ysw), ds( 등)를 사용하시면 궁합이 완벽합니다.
      -- }}}

      -- {{{ fast-wrap vs nvim-surround
      --
      -- Fast-wrap 기능이 약간은 nvim-surround와 비슷한 기능을 하는 것 같은.
      -- nvim-surround의 visual --> S --> bracket 이 더 나은 것 같기도 하고, 서로 용도가 틀리다는 생각도 들고....

      -- 기능의 결과물(텍스트를 괄호로 감싼다)만 보면 두 도구가 매우 비슷해 보입니다.
      -- 하지만 실전 타이핑 흐름을 뜯어보면 "뇌의 인지 과정"과 "편집 모드"에서 완전히 다른 용도를 가집니다. 
      --
      -- 1. 뇌의 인지 타이핑 흐름 차이
      -- 가장 큰 차이는 "내가 감싸야 한다는 사실을 언제 깨달았는가?" 입니다.
      --
      -- 💡 Fast-Wrap: "아차! (실시간 수습)" $\rightarrow$ 인서트 모드 중심
      -- 실시간으로 코드를 타이핑하는 도중에 발동하는 반사 신경에 가깝습니다.
      -- 상황: print를 치고 (를 누르는 순간, () 쌍이 먼저 생겼습니다. 그 다음에 글자를 적다가 print(hello|) 상태에서 "아, 뒤에 올 단어까지 괄호 안에 넣었어야 했네!" 하고 인서트 모드 도중에 즉시 깨달았을 때 씁니다.
      -- 장점: Esc를 눌러 일반 모드로 나가거나, 비주얼 모드로 영역을 지정하는 등의 모드 전환이 전혀 없습니다. 인서트 모드를 유지한 채로 <A-e> $\rightarrow$ 키 조합으로 흐름을 끊지 않고 계속 타이핑을 이어 나갈 수 있습니다.
      --
      -- 💡 nvim-surround: "이 구역을 감싸자 (사후 편집)" $\rightarrow$ 일반/비주얼 모드 중심
      --  이미 작성이 완료된 텍스트 덩어리를 멀리서 바라보며 구조를 바꿀 때 쓰는 구조적 편집 도구입니다.
      --  상황: 이미 한참 전에 작성되어 있던 코드 줄이나, 마크다운 문장의 특정 단어를 나중에 읽다가 "이 부분(단어, 문장, 블록) 전체를 괄호나 HTML 태그로 감싸야겠다" 라고 판단했을 때 씁니다.
      --  장점: 감싸야 할 대상의 범위가 매우 넓거나 복잡할 때(예: 3줄짜리 코드 블록 전체를 중괄호로 감싸기, 단어 5개를 한 번에 묶기 등) 압도적으로 편리합니다. 말씀하신 Visual 모드 선택 -> S -> 괄호는 넓은 영역을 직관적으로 제어할 때 완벽한 정석입니다.
      --
      --  3. 결론: 둘 다 세팅해 두고 이렇게 쓰세요
      --  결코 중복 투자가 아닙니다. 숙련된 Neovim 유저들은 이 두 가지를 완벽하게 분리해서 본능적으로 사용합니다.
      --
      --  글을 쓰는 속도가 더 중요할 때 (새 코드 작성): 키보드를 파다다닥 치고 있는 와중에는 무조건 Fast-Wrap (<A-e>)이 좋습니다. 일반 모드로 나갔다 들어오는 오버헤드(시간 소모)가 없기 때문입니다.
      --
      --  코드를 리팩토링하거나 문서를 다듬을 때 (편집): 이미 완성된 글을 정밀 타격할 때는 고민할 필요도 없이 nvim-surround가 정답입니다. 특히 nvim-surround는 감싸는 것뿐만 아니라 cs([ (소괄호를 대괄호로 교체), ds" (따옴표 삭제) 같은 파괴적인 편집 기능이 있기 때문에 사후 관리의 최강자입니다.
      -- }}}
      -- }}}
      fast_wrap = {
        map = "<M-e>",                         -- 매핑할 키 (Alt + e)
        chars = { "{", "[", "(", '"', "'" },   -- 적용할 괄호 종류
        pattern = [=[[%'%"%)%]%}%s]*]=],       -- 탐색할 문자열 패턴
        end_key = "$",                         -- 줄 맨 끝으로 한 번에 보내는 키
        keys = "qwertyuiopzxcvbnmasdfghjkl",   -- 빠른 레이블 선택용 키 배치
        check_comma = true,                    -- 쉼표 체크 여부
        highlight = "Search",                  -- 선택 시 순간 시각 효과
        highlight_grey = "Comment", -- 레이블이 뜰 때 가독성을 위해 어떤 Neovim 하이라이트 그룹(색상 스타일)을 쓸지 지정.
      },

    })

    -- 6. 커스텀 규칙(Rules) 정의 구역 (공식 Wiki 표준 반영 버전)
    -- -----------------------------------------------------------------
    -- local conds = require("nvim-autopairs.conds") -- 일반 텍스트 조건 모듈 로드

    autopairs.add_rules({

      --{{{
      --[[
      -- [규칙 A]: 마크다운 문서에서 백틱(`) 3개를 연달아 치면 
      -- 주렁주렁 생기지 않고 깔끔하게 아래위 대칭형태로 코드 블록을 구성합니다.
      --
      -- 마크다운에서 백틱(```) 3개를 치면 대칭으로 닫아주되,
      Rule("```", "```", "markdown")
        -- 커서 바로 뒤(오른쪽)에 백틱(`) 텍스트가 이미 존재할 때는 
        -- 중복으로 자동 완성이 발동하지 않도록 락(Lock)을 겁니다.
        -- 커서 바로 뒤에 백틱이 또 있을 때는 작동하지 않도록 방지하는 안전장치
        :with_pair(conds.not_after_text("`")),
      -- ==> 없어도, 기본으로 지원함. 따라서 지워도 됨.
      --]]
      --}}}

      -- [규칙 B]: 괄호를 열고 스페이스바를 누르면 양쪽으로 공백이 벌어지는 규칙
      -- {{{
      -- 예: (|) 상태에서 스페이스 입력 -> ( | ) 형태로 변경됨
      -- 필요에 따라 아래 주석을 해제하여 사용하세요.
      -- }}}
      Rule(" ", " ")
        :with_pair(function(opts)
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return vim.tbl_contains({ "()", "[]", "{}" }, pair)
        end),
    })

    -- ===================================================================
    -- 🔥 [신규 추가] LaTeX 수식 모드(Mathzone) 전용 autopairs 비활성화 로직
    -- ===================================================================
    -- 수식 모드 안에서 (, {, [ 문자를 입력할 때 autopairs가 닫는 괄호를 
    -- 강제로 추가하지 않도록 차단합니다. (LuaSnip 수식 스니펫과의 충돌 방지)
    -- 만약 config.disable_filetype = { "tex", }를 사용하여 tex 전체에서 autopairs를 끄실 경우
    -- 아래 로직은 따로 작동하지 않으므로 그대로 둬도 안전합니다.
    --
    -- ===================================================================
    local target_brackets = { "(", "{", "[" }

    for _, char in ipairs(target_brackets) do
      local rule = autopairs.get_rule(char)
      if rule then
        rule:with_pair(function()
          -- .tex 파일인 경우에만 수식 영역 체킹 진행
          if vim.bo.filetype == "tex" then
            -- luasnip_condition 모듈에서 안전하게 수식 감지 함수 호출
            local ok, luasnip_cond = pcall(require, "utils.luasnip_condition")
            if ok and luasnip_cond.in_math then
              -- 수식 영역 내부(in_math)라면 autopairs 괄호 생성 작동 중단 (false 반환)
              if luasnip_cond.in_math() then
                return false
              end
            end


          end
          -- 그 외의 언어(파일타압)나 수식 밖(일반 텍스트)에서는 autopairs 정상 동작 (true 반환)
          return true
        end)
      end
    end
    -- ===================================================================






  end,
}

-- ----------------------------------------
-- ----------------------------------------

-- vim: set foldmethod=marker foldmarker={{{,}}}:
