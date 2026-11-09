return {

        -- ---------------------
  -- monolithic plugin: 여러 개의 하위 기능을 하나의 거대한 묶음으로 묶어서 한 번에 관리하는 플러그인 구조입니다. (mini.nvim이 대표적입니다.)
  -- mini.nvim이라는 하나의 거대한 바구니(Monolithic Plugin)를 설치한 뒤, 그 내부 config 함수 안에서 mini.ai, mini.surround, mini.statusline을 연달아 켜주는 영리한 구조입니다.

        -- ---------------------

  { -- Collection of various small independent plugins/modules
    'nvim-mini/mini.nvim',


    -- ----------------------
    -- by stc
    -- mini.surround를 위한 key 정의 등록
    --
    -- 🌟 [핵심] LazyVim처럼 플러그인이 로드되기 전에 단축키를 Neovim에 먼저 선점 등록합니다.
    -- 이렇게 하면 Neovim 순정 's' 키가 'sr' 입력을 가로채는 것을 완벽하게 차단합니다.
    --
    -- keys = {
    --   { "ys", desc = "Add Surrounding", mode = { "n", "x" } },
    --   { "ds", desc = "Delete Surrounding" },
    --   { "sr", desc = "Replace Surrounding" }, -- 이제 'sr'이 안전하게 살아납니다!
    --   { "sf", desc = "Find Right Surrounding" },
    --   { "sF", desc = "Find Left Surrounding" },
    --   { "sh", desc = "Highlight Surrounding" },
    --   { "sn", desc = "Update Surrounding Lines" },
    -- },
    --
    --
    -- 🌟 1단계: Lazy 매니저가 Neovim 시스템에 등록할 단축키를 'gsr'로 완전히 갱신합니다.
    -- 여기에 기존에 적혀있던 "sr"이 있다면 반드시 지우거나 아래처럼 gsr로 고치셔야 합니다!
    -- keys = {
    --   { "gsa", desc = "Add Surrounding", mode = { "n", "x" } },
    --   { "gsd", desc = "Delete Surrounding" },
    --   { "gsr", desc = "Replace Surrounding" }, -- 👈 여기에 gsr이 정확히 선점되어야 합니다.
    -- },
    -- by stc
    -- ----------------------
















    config = function()
      -- Better Around/Inside textobjects
      --
      -- -----------------------------------------------
      -- mini.ai
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [I]next [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup {
        -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)

        -- mappings = {
        --   around_next = 'aa',
        --   inside_next = 'ii',
        -- },

        --{{{
        --
        --[[
        -- ----------------------------------------------------------
        * 왜 kickstart.nvim에서 mini.ai의 기본 설정을 aa, ii로 바꾸었나?

          mappings = {
            around_next = 'aa', -- 순정 'an' 대신 'aa'로 변경
            inside_next = 'ii', -- 순정 'in' 대신 'ii'로 변경
          },

        원래 `mini.ai` 공식 순정 디폴트 설정은 `n`(Next)과 `l`(Last)이 기본적으로 아주 잘 활성화되어 있습니다.
        순정 상태였다면 접미사로 `n`과 `l`을 붙여서 `dinw` (다음 단어 삭제), `dilw` (이전 단어 삭제)가 그냥 작동해야 합니다.
        하지만, Neovim v0.12 버전부터는 Treesitter 기반의 '단계적 선택(Incremental Selection)' 기능이 기본으로 포함되었는데, 이 기능이 사용하는 단축키와의 keymapping 충돌을 막기 위해서. 'aa', 'ii'로 바꾸었.다
          aa: Around Another (혹은 Another Around) → 다음 오브젝트의 주변까지
          ii: Inside Inner (혹은 Inner Inside) → 다음 오브젝트의 내부만

          cf) mini.ai의 기본 keymapping:
          around_next = 'an', (n은 Next의 약자)
          inside_next = 'in'

        -- ----------------------------------------------------------
        * 기본 설정을 바꾼 후, 다른 기능들은 잘 작동하나?

        일반적인 플러그인들과는 달리, `mini.ai`는 일부 키만 덮어써도 **설정하지 않은 나머지 기본 키들(`around_last`, `inside_last`)을 자동으로 지워버리거나 먹통으로 만드는 특성**이 있습니다.
        그래서, 다른 순정 기능이었던 접미사 'l' 관련 기능들이 공중분해 되어버려 작동하지 않는다. 

        -x- ----------------------------------------------------------
        * 그럼, 접미사 'l'를 이용하려면 ?

        접미사 'l' 관련기능에 대한 키맵핑을 명시적으로 설정해줘야 한다.

          require('mini.ai').setup {
          mappings = {
            -- kickstart가 바꾼 Next 세팅 (aa, ii)
            around_next = 'aa', -- 순정 'an' 대신 'aa'로 변경
            inside_next = 'ii', -- 순정 'in' 대신 'ii'로 변경

            -- 'l' 대신 'al', 'il'을 명시적으로 지정하여 이전 오브젝트 기능을 부활시킵니다.
            around_last = 'al',
            inside_last = 'il',
          },
          n_lines = 500,  -- 텍스트 오브젝트를 탐색할 최대 줄 수
          -- "다음(Next)" 혹은 "이전(Last)" 오브젝트를 찾기 위해 위아래로 몇 줄까지 훑어볼 것인가를 결정하는 탐색 범위
          }

        -- ----------------------------------------------------------
        * 접미사 'l'의 사용에 있어 주의 할 점.

        mini.ai 공식 문서에 따르면, al이나 il 같은 [Last] 계열 단축키들은 count(숫자)와 함께 조합될 때 커서 왼쪽이 아니라 여전히 커서 오른쪽(Next)을 기준으로 거리를 계산하는 치명적인 논리적 한계를 가지고 있습니다.
        즉, 2alw라고 치면 "왼쪽으로 두 번째 단어"가 아니라, 내부적으로 방향이 꼬여서 엉뚱한 범위를 지정하게 됩니다.

        이 때문에 전 세계의 숙련된 Neovim 유저들은 d2ilw나 d2alw처럼 컴퓨터에게 왼쪽 방향과 갯수를 동시에 계산시키는 복잡한 단축키를 실전에서 절대로 쓰지 않습니다. 

        대신, 먼저  커서를 단어에 위치 시킨 후, 단순한 명령어를 사용합니다.
        즉, 커서를 그 단어 근처로 가볍게 이동시킨 뒤, diw, daw, ci", dilw, cil) 같은 조합을 쓴다.

        -- ----------------------------------------------------------
        * 그럼, 접미사 'l'은 영원히 못쓰는 옵션인가?

        단어(w)는 공백의 경계가 모호하므로, "숫자와 l 조합"은 쓰지 않는다. ('n'도 쓰지 않는 것이 좋다)

        -- ----------------------------------------------------------
        * 접미사 'l'의 조합은 어떨때 유용한가?

        1. 괄호((, {, [)나 따옴표(", ')를 대상으로 쓸 때는 거리와 상관없이 무조건 대박 편리하다.

        괄호나 따옴표 같은 '명확한 기호'를 만날 때, 그 유용성을 가집니다.
        ex) 괄호와 따옴표를 지울 때 (최강의 활용도)

        // |는 현재 커서 위치
        const total = calculate(price, tax);  // |  <- 커서가 한참 뒤에 있는 상황

        cil) ➔ [c]hange [i]nside [l]ast [)] (내 커서 왼쪽 방향으로 가장 가까이 있는 괄호 안쪽을 지우고 입력 모드로 전환!)

        2. 일반 단어(w)를 대상으로 쓸 때는 숫자를 붙이지 말고, 바로 앞/뒤에 있는 단어 딱 1개만 스나이퍼처럼 저격할 때만 쓴다.

        -- ----------------------------------------------------------
        --]]
        --
        -- }}}

        -- ---------------------
        -- by stc
        mappings = {
          -- 'n' 대신 'an', 'in'을 명시적으로 지정 (Next)
          around_next = 'aa',
          inside_next = 'ii',

          -- 'l' 대신 'al', 'il'을 명시적으로 지정 (Last)
          around_last = 'al',
          inside_last = 'il',
        },
        -- by stc, end
        -- ---------------------
        n_lines = 500,  -- 텍스트 오브젝트를 탐색할 최대 줄 수
        -- "다음(Next)" 혹은 "이전(Last)" 오브젝트를 찾기 위해 위아래로 몇 줄까지 훑어볼 것인가를 결정하는 탐색 범위

        custom_textobjects = {
          o = require('mini.ai').gen_spec.treesitter({ -- Treesitter 기반 오브젝트
            a = { '@conditional.outer', '@loop.outer' },
            i = { '@conditional.inner', '@loop.inner' },
          }, {}),
          f = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
          c = require('mini.ai').gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
          -- C = require('mini.ai').gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
          -- t = { '<([%w_:-]+)%s-[^>]*>%s*(-)%s*</%1>', '^<.->().*()</[^>]->$' }, -- HTML 태그 개선
        },

      }


      -- {{{
      --[[

Question : 

mini.ai설정,사람들이 가장많이 설정하는 mini.ai 설저코드는 어떻게 되? 왜 그렇게 설정하는지 그 이유도 알려줘


-- {{{
Answer :

Neovim(nvim)의 텍스트 오브젝트(Text Object) 확장 플러그인인 mini.ai 설정을 찾으셨군요.
대부분의 사용자가 적용하는 가장 대중적인 mini.ai 설정 코드와 그 이유를 직관적으로 정리해 드립니다.
------------------------------
## 🔥 가장 많이 쓰는 mini.ai 설정 코드
인기 Neovim 배포판인 LazyVim 등에서 기본 채택하고 있는 검증된 설정입니다.

require('mini.ai').setup({
  n_lines = 500, -- 텍스트 오브젝트를 탐색할 최대 줄 수
  custom_textobjects = {
    o = require('mini.ai').gen_spec.treesitter({ -- Treesitter 기반 오브젝트
      a = { '@conditional.outer', '@loop.outer' },
      i = { '@conditional.inner', '@loop.inner' },
    }, {}),
    f = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
    c = require('mini.ai').gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
    t = { '<([%w_:-]+)%s-[^>]*>%s*(-)%s*</%1>', '^<.->().*()</[^>]->$' }, -- HTML 태그 개선
  },
})

------------------------------
## 💡 왜 이렇게 설정할까요? (인기 이유)## 1. n_lines = 500 (탐색 범위 확대)

* 이유: 순정 Neovim은 현재 커서 근처만 탐색합니다. 이 값을 500줄 이상으로 늘려야 코드 위아래로 멀리 떨어져 있는 함수(f)나 조건문(o) 안에서도 텍스트 오브젝트를 정확하게 찾아내어 편집할 수 있습니다.

## 2. Treesitter 기반의 함수(f) 및 클래스(c) 바인딩

* 이유: vaf(Visual Around Function)나 dif(Delete Inner Function) 같은 직관적인 키 매핑을 사용하기 위해서입니다. 코드가 아무리 복잡하게 얽혀있어도 구조를 정확히 파악해 함수 단위로 통째로 지우거나 복사할 수 있습니다.

## 3. 조건문/반복문 통합 오브젝트(o)

* 이유: if문이나 for문 등 모든 제어문을 o(Code Block/Condition)로 통일합니다. 덕분에 어떤 언어를 쓰든 dio(Delete Inner Block) 입력 한 번으로 조건문 내부 코드만 깔끔하게 날릴 수 있습니다.

## 4. HTML/XML 태그(t) 매핑 개선

* 이유: Neovim 순정 상태에서는 대괄호나 따옴표는 잘 잡지만, <div class="active">...</div> 같은 복잡한 HTML 태그 내부는 잘 잡지 못합니다. 패턴을 추가해 태그 안쪽 문자열을 한 번에 제어하기 위함입니다.

------------------------------
추가로 설정하고 싶으신 커스텀 텍스트 오브젝트가 있거나, 현재 사용 중이신 Neovim 설정 프레임워크(LazyVim, AstroNvim 등)를 알려주시면 플러그인 구조에 딱 맞는 파일 경로와 코드로 다시 작성해 드릴 수 있습니다. 어떻게 도와드릴까요?
-- }}}

-- ------------------------------------
Question :

음... keymap={ around_next = aa, inner_next=ii》 같은 것은 설정. 안하고, 초기 디폴트값으로 쓰나봐? 난 오늘 처음으로 함수, 클래스,조건문 에 대한 텍스트오브젝트는 처음봐서.. 이제껏 around_next/inner에 설정만 봐와서....

-- {{{
Answer

아, 그렇게 느끼실 수 있습니다! 질문하신 내용을 들으니 단번에 이해가 가네요. 결론부터 말씀드리면, around_next나 inner_next 같은 키맵은 이미 mini.ai 내부에서 강력하게 기본값(Default)으로 제공하고 있기 때문에 굳이 코드로 따로 적지 않는 경우가 많습니다.
그 이유와 지금 처음 보신 함수/클래스 오브젝트가 어떻게 연결되는지 알기 쉽게 정리해 드릴게요.
------------------------------
## 1. around_next 설정을 왜 생략할까요?
mini.ai는 설치만 해도 아래와 같은 키맵이 기본으로 내장되어 작동합니다.

* an (around next) / in (inner next) ➡️ 내 커서 뒤(다음)에 오는 텍스트 오브젝트 선택
* al (around last) / il (inner last) ➡️ 내 커서 앞(이전)에 오는 텍스트 오브젝트 선택

많은 사용자들이 굳이 keymap = { around_next = 'aa' } 같은 식으로 설정을 바꾸지 않는 이유는, mini.ai가 설계한 an (Around Next) 규칙이 이미 Vim의 철학(a=around, n=next)과 잘 맞고 매우 직관적이기 때문입니다.
------------------------------
## 2. "다음 함수"나 "이전 조건문"도 자동으로 작동합니다
오늘 처음 보신 함수(f), 클래스(c), 조건문(o) 설정이 바로 이 next / last 규칙과 그대로 결합합니다.
따라서 코드를 추가해 두면, 아래와 같은 환상적인 키 조합이 자동으로 완성됩니다.

* danf (Delete Around Next Function)
* 👉 현재 커서 뒤에 등장하는 가장 가까운 함수 전체를 삭제합니다.
* ciil (Change Inner Last Loop/Condition)
* 👉 현재 커서 이전에 지나쳐 온 for문이나 if문의 내부 코드만 싹 지우고 입력 모드로 전환합니다.

------------------------------
## 3. 두 설정의 시너지 효과
결국 사람들이 custom_textobjects를 열심히 설정하는 이유는, mini.ai가 기본으로 제공하는 next / last 탐색 기능(n과 l)을 함수나 조건문 같은 고차원 코드 구조에도 써먹고 싶기 때문입니다.

* 순정 Vim: 커서가 괄호 ()나 따옴표 "" 안에 있을 때만 di"가 작동합니다.
* mini.ai (기본): 커서가 따옴표 밖에 있어도 din"를 누르면 저 뒤에 있는 따옴표 안쪽을 지워줍니다.
* mini.ai (Treesitter 확장): 한 걸음 더 나아가 dinf를 누르면 저 뒤에 있는 함수 내부를 지워줍니다.

오늘 함수와 조건문 오브젝트를 처음 알게 되셨다면, 꼭 한번 적용해 보세요. 멀리 떨어진 함수를 지우려고 j나 k 키를 연타하며 이동할 필요가 없어져서 타이핑 효율이 완전히 달라집니다!
------------------------------
혹시 지금 사용 중이신 around_next 관련 커스텀 키맵(aa나 ii 등)이 따로 있으신가요? 기존에 사용하시던 익숙한 단축키 설정이 있다면, 새로운 함수/조건문 기능과 충돌하지 않게 섞어 쓸 수 있는 설정 코드를 만들어 드릴 수 있습니다. 편하게 말씀해 주세요!



-- }}}



-- ------------------------------------

Question :
nvim 이 버전업되면서, treesitter의 incremental selection의 키값과 충돌이 난다고... aa, ii 등으로 새로시 키맵핑 사더라고. 왜 지금 여기 설명에서는 그린 방지 설정이 없지?



-- {{{
Answer :

네, 정확하게 짚으셨습니다! 제가 이전 답변에서 최신 버전의 중요한 변화인 Neovim 코어와의 키맵 충돌 문제를 누락했네요. 예리한 지적 감사드립니다. [1] 
최근 Neovim(v0.11 및 v0.12 개발 버전 포함)에 Treesitter 기반의 점진적 선택(Incremental Selection) 기능이 내장(Built-in)되기 시작하면서, 기존 mini.ai가 기본값으로 사용하는 an, in 키맵과 정면으로 충돌하는 문제가 발생하고 있습니다. [2, 3] 
이 문제를 방지하고 Neovim 코어 기능과 상생하기 위해 사람들이 실제로 적용하는 충돌 방지 설정 코드와 그 구조를 명확히 바로잡아 드립니다. [4] 
------------------------------
## 🛠️ 충돌을 방지한 mini.ai 실제 추천 설정
많은 파워 유저들은 Neovim 코어의 an/in(Incremental Selection)을 살리기 위해, mini.ai 내부의 around_next와 inner_next 키맵을 아래처럼 aa와 ii 등으로 변경하여 충돌을 회피합니다.

require('mini.ai').setup({
  n_lines = 500,
  -- ⚠️ Neovim 내장 Treesitter 점진적 선택(an, in)과의 충돌 방지 설정
  mappings = {
    around_next = 'aa', -- 기존 'an' 대신 'aa' 사용 (Around Next)
    inner_next  = 'ii', -- 기존 'in' 대신 'ii' 사용 (Inner Next)
    around_last = 'al', -- (선택) 이전 개체는 그대로 유지 가능
    inner_last  = 'il', -- (선택) 이전 개체는 그대로 유지 가능
  },
  custom_textobjects = {
    o = require('mini.ai').gen_spec.treesitter({
      a = { '@conditional.outer', '@loop.outer' },
      i = { '@conditional.inner', '@loop.inner' },
    }, {}),
    f = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
    c = require('mini.ai').gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
  },
})

------------------------------
## ❓ 왜 이 방지 설정이 필요하고 유행할까요?

## 1. Neovim 순정 기능인 v ➡️ a ➡️ n 단축키 먹통 현상 해결 [2] 

* 원인: Neovim의 최신 사양에서는 Visual 모드(v) 진입 후 an을 누르면, Treesitter가 노드를 한 단계씩 확장 선택(Incremental Selection)하는 기능이 내장되어 있습니다. [3] 
* 문제: 하지만 mini.ai가 활성화되어 있으면 van을 입력했을 때 mini.ai가 n 입력을 가로채어 "다음 텍스트 오브젝트를 대기하는 상태"로 빠져버려 코어 기능이 작동하지 않습니다. [3] 

## 2. aa와 ii로 매핑했을 때의 직관성

* 사용 예시: daaf (Delete Around Next Function)
* 효과: an 대신 aa를 사용하면 "Next"라는 느낌은 조금 덜하지만, "다음(Next) 함수(f) 주변(a)을 다 지운다(d)"는 의미로 연속 타이핑(d ➡️ a ➡️ a ➡️ f)이 매우 매끄러워져 실전에서 선호도가 높습니다. [2] 

------------------------------
## 💡 요약하자면
이전 답변의 코드는 Neovim 구버전 혹은 내장 Incremental Selection을 아예 꺼두고 쓰는 유저들의 기본 설정이었던 반면, 최신 Neovim 생태계에 맞춰 플러그인 간 충돌 없이 쓰려면 mappings = { around_next = 'aa', inner_next = 'ii' } 옵션이 필수적입니다. 짚어주신 덕분에 코드가 완벽해졌습니다.
혹시 이 충돌 방지 설정을 적용하는 과정에서 키 매핑이 꼬이거나 which-key 같은 플러그인에 힌트가 잘못 뜨는 문제가 있다면 말씀해 주세요. 바로 해결 방법을 안내해 드리겠습니다!

[1] [https://www.reddit.com](https://www.reddit.com/r/neovim/comments/1es45ay/custom_keybinds_for_incremental_selection_in/)
[2] [https://www.reddit.com](https://www.reddit.com/r/neovim/comments/1s9q0pi/incremental_selection_in_neovim_012/)
[3] [https://github.com](https://github.com/nvim-mini/mini.nvim/issues/2338)
[4] [https://www.josean.com](https://www.josean.com/posts/nvim-treesitter-and-textobjects)




-- }}}

-- ------------------------------------


Question :

확실하진 않지만, 내 기억엔,,, treesitter-textobjects.nvim에서도 함수나 클래스에 대한 텍스트오브젝트를 정의하고 선택등의 설정을 하는 걸로 알고 있는데... mini.ai에서의 함수, 글래스 설정과는 어떻게 달라? 2중 설정은 아니야?


-- {{{
Answer :

기억하시는 게 정확합니다! nvim-treesitter-textobjects 플러그인도 함수(af/if)나 클래스(ac/ic)의 텍스트 오브젝트를 정의하고 선택할 수 있는 기능을 제공합니다. [1, 2] 
결론부터 말씀드리면, 만약 두 플러그인의 기본 설정을 모두 켜두면 동일한 단축키(af, if 등)가 겹쳐서 작동하는 이중 설정(충돌) 상태가 맞습니다. [3, 4] 
다만, 두 플러그인은 역할을 완전히 다르게 나누어 가지며, 숙련자들은 이 둘을 대립 관계가 아니라 상호보완 관계로 엮어서 사용합니다. 그 차이점과 이중 설정을 피하는 깔끔한 해결책을 정리해 드립니다. [5, 6, 7] 
------------------------------
## 1. 두 플러그인의 핵심 차이점

| 비교 항목 [1, 2, 3, 5, 8, 9] | nvim-treesitter-textobjects | mini.ai |
|---|---|---|
| 핵심 역할 | 언어별(Python, TS 등) 추상 구문 트리 분석 데이터 제공 | 텍스트 오브젝트를 다루는 강력한 조작 엔진 |
| 동작 특징 | 커서가 정확히 그 영역(함수 내부 등)에 있어야만 작동 | 커서가 멀리 떨어져 있어도 앞/뒤 탐색하여 조작 가능 |
| 부가 기능 | 없음 | v:count 지원 (예: 2daf로 다음 다음 함수 지우기), 연속 선택 등 |

즉, treesitter-textobjects는 "여기서 여기까지가 함수 구간이야"라고 명확히 짚어주는 역할만 잘하고, mini.ai는 그 정보를 건네받아 "그럼 저 멀리 있는 함수를 탐색(aa/ii)해서 지우거나 수정할게!"라는 고차원 엔진 역할을 수행합니다. [5, 6] 
------------------------------
## 2. 이중 설정을 방지하는 올바른 세팅법 (LazyVim 등에서 쓰는 방식)
이중 매핑 충돌을 막기 위해, 사람들은 nvim-treesitter-textobjects에서는 단축키 설정을 끄고(데이터 백엔드로만 사용), 그 데이터를 mini.ai가 가져와서 단축키를 처리하도록 일원화합니다. [4, 6, 10] 
## ❌ 나쁜 예 (이중 충돌)
두 플러그인 모두에 keymaps = { ["af"] = "@function.outer" } 같은 단축키 설정을 각각 지정해 둔 상태 (먼저 로드되거나 우선순위를 가진 플러그인이 덮어씌워져 mini.ai 고유의 앞/뒤 탐색 능력이 상실됩니다).
## 좋은 예 (일원화 세팅)

   1. nvim-treesitter-textobjects 설정: 키맵 등록 옵션(keymaps = {})을 아예 비워두거나 비활성화합니다. (플러그인은 쿼리 데이터 공급용으로만 설치)
   2. mini.ai 설정: 앞서 보셨던 custom_textobjects 내부에 Treesitter 연동 함수를 주입합니다. [2, 5, 6, 8, 11] 

-- mini.ai 설정 내부에 선언
custom_textobjects = {
  -- treesitter-textobjects가 수집한 언어별 데이터를 mini.ai 엔진에 탑재
  f = require('mini.ai').gen_spec.treesitter({ 
    a = '@function.outer', 
    i = '@function.inner' 
  }),
}

이렇게 세팅하면 이중 설정의 낭비 없이, treesitter의 정확한 구문 분석 능력과 mini.ai의 영리한 스마트 탐색(예: daaf로 다음 함수 지우기) 능력을 완벽하게 결합하여 사용할 수 있습니다. [4, 6] 
------------------------------
현재 혹시 init.lua나 plugins/ 폴더 내에 두 플러그인의 설정 코드가 각각 어떻게 적혀있는지 공유해 주실 수 있나요? 코드를 보고 단축키 충돌이 나지 않도록 깔끔하게 결합하는 형태로 리팩토링해 드리겠습니다!

[1] [https://www.reddit.com](https://www.reddit.com/r/neovim/comments/wa819w/miniai_extend_and_create_ai_textobjects_like/)
[2] [https://www.reddit.com](https://www.reddit.com/r/neovim/comments/10q863v/function_and_class_text_objects_with_treesitter/)
[3] [https://nvim-mini.org](https://nvim-mini.org/mini.nvim/doc/mini-ai.html)
[4] [https://www.reddit.com](https://www.reddit.com/r/neovim/comments/136vj6x/whats_the_difference_between_these_two_miniai/)
[5] [https://nvim-mini.org](https://nvim-mini.org/mini.nvim/doc/mini-ai.html)
[6] [https://www.reddit.com](https://www.reddit.com/r/neovim/comments/136uzdx/whats_the_difference_between/?tl=ko)
[7] [https://www.reddit.com](https://www.reddit.com/r/neovim/comments/136uzdx/whats_the_difference_between/)
[8] [https://github.com](https://github.com/nvim-mini/mini.ai)
[9] [https://nvim-mini.org](https://nvim-mini.org/mini.nvim/doc/mini-ai.html)
[10] [https://www.reddit.com](https://www.reddit.com/r/neovim/comments/136uzdx/whats_the_difference_between/)
[11] [https://www.reddit.com](https://www.reddit.com/r/neovim/comments/wiamjt/miniai_now_supports_textobjects_based_on/)




-- }}}



-- ------------------------------------








      --]]
      --
      -- }}}


      -- -----------------------------------------------

      -- -----------------------------------------------
      -- mini.surround
      --
      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      -- require('mini.surround').setup()

      -- {{{
      -- -----------------------------
      -- by stc

      -- 기존 kickstart 주석 설명(saiw, sd, sr)을 전 세계 대다수 개발자가 사용하는
      -- 더욱 강력하고 직관적인 대중적 문법(ysiw, ds, cs) 구조로 덮어씌웁니다.
      --
      -- 전 세계 Neovim 유저들이 가장 많이 사용하고 사실상 표준(De facto standard)으로 정착된 설정
      --
      -- mini.surround 플러그인 고유의 키맵 대신, 옛날부터 유명했던 tpope/vim-surround라는 전설적인 플러그인의 규칙을 그대로 계승하는 설정을 가장 많이 씁니다.
      --[[
      return {
        'echasnovski/mini.surround',
        event = 'VeryLazy',
        opts = {
          -- 🌟 전 세계 Neovim 유저들이 가장 익숙해하는 표준 키맵으로 변경합니다.
          mappings = {
            add = 'ys',           -- [y]ank [s]urround ([Y]ou [S]urround) : 서라운드 추가
            delete = 'ds',        -- [d]elete [s]urround : 서라운드 삭제
            change = 'cs',        -- [c]hange [s]urround : 서라운드 변경

            find = 'sf',          -- [s]urround [f]ind : 우측 서라운드 찾기
            find_left = 'sF',     -- 좌측 서라운드 찾기
            highlight = 'sh',     -- [s]urround [h]ighlight : 주변 서라운드 하이라이트
            update_n_lines = 'sn',-- [s]urround [n]lines : 탐색 줄 수 변경

            suffix = '',          -- 기본 접미사 비활성화 (위의 커스텀 키를 쓰기 위함)
          },
          -- 검색 및 교체 시 줄 바꿈을 얼마나 멀리까지 탐색할지 지정 (기본값으로 충분)
          search_method = 'cover',
        },
      }
      --]]

      -- 이제부터는 손가락 꼬임 없이 ysiw", cs"', ds' 등의 최고 효율 단축키들을 온전히 누리실 수 있습니다!

      -- ex)
      -- ysiw) ➔ [y]ank [s]urround [i]nside [w]ord ➔ 현재 단어 내부를 대상으로 지정하고 )로 감싸라.
      -- ys$] ➔ [y]ank [s]urround + $ (현재 커서부터 줄 끝까지를 대상으로) + ]로 감싸라.
      -- ds" = [d]elete [s]urround (서라운드를 지워라) + " (따옴표를)
      -- cs"' = [c]hange [s]urround (서라운드를 바꿔라) + "를 + '로
      --
      -- by stc end
      -- -----------------------------
      -- }}}

      -- -----------------------------
      -- by stc
      -- require('mini.surround').setup {
      --   mappings = {
      --     add = 'ys',           -- [y]ank [s]urround ([Y]ou [S]urround) : 서라운드 추가
      --     delete = 'ds',        -- [d]elete [s]urround : 주변 서라운드 삭제
      --
      --     -- change = 'cs',        -- [c]hange [s]urround : 기존 서라운드 변경
      --     -- ==> cs(문장 지우기)로 오동작!!
      --     -- 🌟 [최종 교정] cs 대신 'cr' (Change/Replace Surround)을 사용합니다!
      --     -- 이렇게 하면 mini.ai의 클래스 지정자 'c'와 무조건 100% 충돌이 해결됩니다.
      --     -- change = 'cr',        -- [c]hange [r]eplace surround : 기존 서라운드 변경
      --     -- ==> cr(커서 위치 글자 바꾸기)로 오동작!!
      --     --
      --     change = 'sr',        -- [s]urroud [r]eplace surround : 기존 서라운드 변경
      --     -- change = 'sc',        -- [S]urround [C]hange
      --     -- change = 'ss',        -- [S]urround [S]witch / Substitute
      --     --
      --     --{{{ sr 대신 고려해 볼 만한 최적의 키 조합 Top 2
      --     --[[
      --     sr 대신 고려해 볼 만한 최적의 키 조합 Top 2
      --
      --     ① 후보 1 : sc (Surround Change) — ★★★★★ (가장 추천)
      --     의미: [S]urround [C]hange
      --     장점:sf(찾기), sh(하이라이트), sn(줄수 변경)과 함께 's' 돌림자가 되어 직관성이 극대화됩니다!
      --     change = 'sc',
      --     change = 'sc',        -- [S]urround [C]hange
      --
      --     ② 후보 2 : cs (Surround Switch / Substitute) — ★★★★☆
      --     의미: [S]urround를 다른 것으로 [S]witch(교체)한다
      --     장점: 같은 키를 연속으로 두 번(s ➔ s) 누르기 때문에 타이핑 속도가 압도적으로 빠름
      --     change = 'ss',        -- [S]urround [S]witch / Substitute
      --     --]]
      --     --}}}
      --
      --     find = 'sf',          -- [s]urround [f]ind : 다음(우측) 서라운드 찾기
      --     find_left = 'sF',     -- 이전(좌측) 서라운드 찾기
      --     highlight = 'sh',     -- [s]urround [h]ighlight : 주변 서라운드 하이라이트
      --     update_n_lines = 'sn',-- [s]urround [n]lines : 탐색 범위(줄 수) 지정
      --
      --     suffix = '',          -- 기본 접미사 비활성화 (위의 커스텀 키를 쓰기 위함, 커스텀 키 충돌 방지용 접미사 초기화), -- 커스텀 키 활성화를 위해 접미사 비활성화
      --   },
      --   -- 검색 및 교체 시 줄 바꿈을 얼마나 멀리까지 탐색할지 지정 (기본값으로 충분)
      --   search_method = 'cover',
      --
      -- }
      -- by stc end
      -- -----------------------------------------------

      -- -----------------------------------------------
      -- by stc 
      -- imitating LazyVim

      -- require('mini.surround').setup {
      --   mappings = {
      --     add = 'gsa',           -- [g]o [s]urround [a]dd
      --     delete = 'gsd',        -- [g]o [s]urround [d]elete
      --     change = 'gsr',        -- [g]o [s]urround [r]eplace (★중요: 공식 옵션명은 여전히 change입니다)
      --     find = 'gsf',
      --     find_left = 'gsF',
      --     highlight = 'gsh',
      --     update_n_lines = 'gsn',
      --     suffix = '',
      --   },
      --   search_method = 'cover',
      -- }

      -- mappings.change = 'gsr'만으로는 operator-pending 특성 때문에 동작 안함.
      --
      -- change는 내부적으로 <Plug>(mini-surround-replace)라는 operator-pending 명령을 사용합니다. 즉, sr처럼 짧은 키를 바로 operator로 인식해야 하는데, gsr처럼 g prefix가 붙으면 Vim이 먼저 g를 다른 동작으로 해석하려고 해서 충돌이 납니다.
      -- 그래서 gsr은 mini.surround.setup{ mappings = { change = 'gsr' } }만으로는 제대로 적용되지 않는 거예요.
      --
      -- ===> adding Tag (gsr tt new_tag)가 안됨... 오직 sr tt new_tag 만 됨



      --[[
      opts = {
        mappings = {
          add = "gsa", -- Add surrounding in Normal and Visual modes
          delete = "gsd", -- Delete surrounding
          find = "gsf", -- Find surrounding (to the right)
          find_left = "gsF", -- Find surrounding (to the left)
          highlight = "gsh", -- Highlight surrounding
          replace = "gsr", -- Replace surrounding
          update_n_lines = "gsn", -- Update `n_lines`
        },
      }
      --]]


      -- by stc end
      -- -----------------------------------------------

      -- -----------------------------------------------
      -- mini.statusline
      --
      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end
      -- -----------------------------------------------

      -- ... and there is more!
      --  Check out: https://github.com/nvim-mini/mini.nvim
    end,
  },
}



-- vim: set foldmethod=marker foldmarker={{{,}}}:
