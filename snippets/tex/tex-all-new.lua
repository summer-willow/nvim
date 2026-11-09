
-- ~~/nvim/snippets/tex/tex-all-new.lua

--
-- HACK: from ejmastnak:
--[[
-- I use ff (fraction), mm (inline math), and nn (new equation environment).
--
-- HACK: Combinations of home row keys like j, k, l, s, d, and f, for example, sd, df, jk, and kl ...
-- ex)
-- HACK: first, (in a system-wide preamble file) define the LaTeX command:
-- \newcommand{\diff}{\ensuremath{\operatorname{d}\!}}
-- then access it with the following snippet:
-- s({trig = "df", snippetType = "autosnippet",  condition = tex.in_mathzone },
--   { t("\\diff") }
-- )
-- This df snippet makes typing differentials a breeze, with correct spacing, upright font, and all that.
-- As a side note, using a \diff command also makes redefinition of the differential symbol very easy—for example to adapt an article for submission to a journal that uses italic instead of upright differentials, one could just replace \operatorname{d}\! with \,d in the command definition instead of rummaging through LaTeX source code changing individual differentials.
--
-- HACK: ex) for upright text in subscripts
-- s({trig = 'sd', snippetType="autosnippet", wordTrig=false, condition = tex.in_mathzone},
--   fmta("_{\\mathrm{<>}}",
--     { d(1, get_visual) }
--   )
-- ),
--
--
--]]
--
--
--
--[[
NOTE: 현재 로딩된 스니펫 목록을 확인하는 내장 명령은?
:LuaSnipListAvailable
--]]


--[[
-- snippet 등록 방법들
-- ----------------
-- * method 1
local snippets_group = {
  -- 일반 스니펫1,
  -- 일반 스니펫2,

}
local autosnippets_group1 = {
  - 자동변환 스니펫1,
  - 자동변환 스니펫2,
}
local autosnippets_group2 = {
  - 자동변환 스니펫1,
  - 자동변환 스니펫2,
}
local autosnippets_group3 = {
  - 자동변환 스니펫1,
  - 자동변환 스니펫2,
}
return snippets_group, concat(autosnippets_group1, autosnippets_group2, autosnippets_group3)
-- return은 2개까지 return 할 수 있다. 첫번째는 일반스니펫(snippets_group), 두번째는 자동변환스니펫(autosnippets_group)
--]]

-- cf) ls.add_snippets 명시적 등록 방식 사용

--[[
-- ----------------------------------------
cf)
ls.add_snippets(filetype, snippets, opts)

LuaSnip 설계상 ls.add_snippets(filetype, snippets, opts)에서 세 번째 인자인 opts는 스니펫 컬렉션의 관리용 메타데이터(예: type = "autosnippets", key = "그룹이름", refresh_notify)를 받는 용도입니다.
그룹 전체용 condition 필드는 존재하지 않습니다.

* opts
key = "key_ID"
type = "snippets" or "autosnippets"

-- ----------------------------------------
cf)
ls.s(context, nodes, opts)

* context :
trig="trig_name"
snippetType="autosnippet" or "snippet"
wordTrig=true (deault)
regTrig=false (default)
hidden= true or false

* nodes
스니펫 정의

* opts :
condition = in_math
show_condition = in_math

LuaSnip의 기본 함수 
3번째 인자에 condition을 주입

* **첫 번째 인자 (`context`)**: **"무엇을 입력했을 때 작동할 것인가?"** (트리거 이름 `trig`, 정규식 여부 `regTrig`, 단어 단위 여부 `wordTrig` 등)
* **두 번째 인자 (`nodes`)**: **"무엇으로 변환할 것인가?"** (본문 텍스트, 입력 창 `i()`, 비주얼 셀렉션 `d()`, dynamicNode 등)
* **세 번째 인자 (`opts`)**: **"언제/어떻게 동작할 것인가?"** (실행 조건 `condition`, 카테고리 지정 `callbacks` 등)

cf)
LuaSnip의 `s()` 함수 형식의 차이

* 1번 방식 (첫 번째 인자에 포함)
"s({ trig = ""mk"", condition = cond }, nodes)"
장점: 인자가 2개로 줄어들어 단순함
단점: "테이블 하나에 트리거, 정규식, 조건이 섞임"

* 2번 방식 (세 번째 인자로 분리)
"s({ trig = ""mk"" }, nodes, { condition = cond })"
장점: 스니펫 트리거 설정과 실행 조건/옵션이 명확히 분리됨
단점: 인자가 3개가 되어 가로로 길어질 수 있음


---

사실 **(1번 방식)도 내부적으로는 (2번 방식)과 완전히 동일하게 동작하는 정상적인 방법**입니다.

==> 동일하게 작동하지만, 명확한 설정과 가독성을 위해 (2번 방식)을 이용하가.

## 📌 결론: 어떤 방식을 써야 할까요?

* 단일 조건(`in_math` 등)처럼 짧은 조건은 (1번 방식)으로 작성하셔도 깔끔하고 완벽하게 동작합니다.
* 익명 함수(`function() return ... end`)가 들어가는 복잡한 다중 조건일 때만 가독성을 위해 (2번 방식)처럼 3번째 인자로 떼어내는 방식을 고려해 보시면 됩니다.

--]]


-- luasnip API 선언
-- local ls = require("luasnip")
-- local s = ls.snippet
-- local sn = ls.snippet_node
-- local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local rep = require("luasnip.extras").rep

-- helper functions
local get_visual = utils.util.get_visual
local cond_all = utils.util.cond_all
local cond_any = utils.util.cond_any
local cond_not = utils.util.cond_not
local concat = utils.util.concat

-- conditions
local in_math=utils.cond.in_math
local in_text=utils.cond.in_text
local in_comment=utils.cond.in_comment

local in_equation=utils.cond.in_equation
local in_itemize=utils.cond.in_itemize
local in_tikz=utils.cond.in_tikz
local in_align=utils.cond.in_align
local in_bmatrix=utils.cond.in_bmatrix
local in_gather=utils.cond.in_gather
local in_proof=utils.cond.in_proof
local in_even_line= utils.cond.in_even_line

-- luasnip조건 객체(condtion object)
local line_begin = utils.cond.line_begin


-- ----------------------------------------
-- testing


--[[
--
-- my_complex_cond 같은 복잡한 조건 조합 변수는 ls.add_snippets() 외부(파일 상단)에 정의해야 합니다.
-- ✨ 이렇게 배치했을 때의 장점
가독성 향상: 스니펫의 내용(s(...))과 복잡한 조건식(cond_any, cond_all)이 분리되어 코드가 깔끔해집니다.
재사용성: 동일한 super_condition을 여러 스니펫에서 동시에 재사용할 수 있습니다.

-- cf)
-- 만약 ls.add_snippets() 내부(스니펫 정의 배열 안)에 적으려고 하면 Lua 문법상 스니펫 객체나 테이블 정의 구문이 꼬이거나 에러가 발생합니다.

-- ex) my_complex_cond은 add_snippets 외부, 상단에 선언한다.
local my_complex_cond = cond_any(
  cond_all(in_math, line_begin),
  cond_all(in_text, not_line_begin)
)

ls.add_snippets("tex", {

  -- 실제 스니펫 정의부에서는 변수명을 가져다 씁니다.
  s(
    { trig = "test_trig" },
    fmta("\\frac{<>}{<>}", { i(1), i(2) }),
    {
      condition = my_complex_cond
    }
  ),

}, {
  type = "autosnippets",
})

return {}, {}


cf) 
람다(익명) 함수를 재사용하기 위해 이름을 붙인 일반 함수(지역 변수)로 만들어 관리할 때도, 앞서 본 super_condition과 마찬가지로 ls.add_snippets() 외부(파일 상단)에 선언하는 것이 가장 좋습니다.

1. 선언 및 사용 방법
파일 상단에 local 변수로 조건 검사용 함수를 선언해두고, 스니펫 내부에서는 해당 변수 이름만 가져다 쓰시면 됩니다.

2. 왜 ls.add_snippets() 상단 외부에 두어야 할까요?
Lua의 변수 범위(Scope) 규칙: Lua는 위에서 아래로 실행되므로, 스니펫 내부(condition = ...)에서 해당 함수를 참조하려면 반드시 스니펫 선언 코드보다 위에 정의되어 있어야 합니다.

메모리 Efficiency: ls.add_snippets() 외부에 정의해두면, Neovim이 이 파일을 로드할 때 함수 객체를 딱 1번만 메모리에 생성하고 여러 스니펫이 이를 공유합니다. (스니펫 정의 내부에 매번 익명 함수를 적으면 스니펫 개수만큼 함수 객체가 새로 만들어집니다.)

ex)
-- 💡 [재사용 함수 선언] ls.add_snippets() 시작 직전 상단에 위치합니다.
-- "수식 내부 + 줄 시작" OR "텍스트 내부 + 줄 시작이 아님"
local cond_math_line_or_text_inline = function(line_to_cursor, matched_trigger, captures)
  local is_line_begin = line_begin(line_to_cursor, matched_trigger, captures)
  return (in_math() and is_line_begin) or (in_text() and not is_line_begin)
end

ls.add_snippets("tex", {

  -- 첫 번째 스니펫에서 재사용
  s(
    { trig = "ffccc" },
    fmta("(ffccc) \\frac{<>}{<>}", { i(1), i(2) }),
    {
      condition = cond_math_line_or_text_inline
    }
  ),

  -- 두 번째 스니펫에서도 동일 조건 재사용
  s(
    { trig = "ffccc2" },
    fmta("(ffccc2) \\frac{<>}{<>}", { i(1), i(2) }),
    {
      condition = cond_math_line_or_text_inline
    }
  ),

}, {
  type = "autosnippets",
})

return {}, {}







--]]
-- ----------------------------------------

local math_cond= {
  condition=in_math, 
  show_condition=in_math
}
--[[

-- 수식 안에서만 작동하도록 조건을 강제하는 테이블
local math_cond = {
  condition = is_math,     -- 1. [LuaSnip 전용] 실제 자동 트리거(확장)를 수식 안에서만 허용
  show_condition = is_math -- 2. [Blink.cmp 전용] 자동완성 팝업 픽셀 창에 노출되는 것을 수식 안으로만 제한
  -- {{{
  -- show_condition = is_math의 역활:
  -- "수식 밖이라면, blink.cmp 자동완성 팝업창 목록에도 이 자동 스니펫을 아예 띄우지 마라"고 숨김 처리(필터링)를 하는 명령
  -- 따라서, 수식밖에서 쓸데 없이 수식전용 스니펫이 보이지 않게 하여, 선택되는 것을 방지.
  -- show_condition은 LuaSnip 완성 창(cmp / nvim-cmp)에 이 스니펫을 노출할지 말지 판단하는 개별 스니펫 전용 노드 속성
  -- }}}
}

-------------------
cf) 
hidden (완성 창 자동완성 메뉴에서 숨기기)
show_condition과 별개로, 자동완성(nvim-cmp 등) 목록에 아예 노출하고 싶지 않은 스니펫에 hidden = true를 줍니다.
LaTeX 팁: autosnippets처럼 굳이 팝업 창에 안 떠도 타이핑 즉시 바뀌는 단순 수식 기호들(aa --> \alpha)에 지정해 두면 자동완성 팝업 창이 지저분해지는 것을 막아줍니다.

s({ trig = "aa", hidden = true }, { t("\\alpha ") }, { condition = in_math })
-------------------

--]]


-- ========================================
  -- key = "tex_normal"
  -- 탭을 눌러 확장하는 일반 스니펫 테이블 
-- ========================================
-- {{{
-- return { } 대신, lua 로더가 정상 인식하도록 add_snippets 함수 사용
ls.add_snippets("tex", {

  -- tt ==> \texttt{}
  s({trig="tt", dscr="Expands 'tt' into '\texttt{}'"},
    fmta(
      "\\texttt{<>}",
      { 
        d(1, get_visual),
       }
    )
  ),

  -- tii ==> \textit{}
  s({trig = "tii", snippetType="autosnippet", dscr = "Expands 'tii' into LaTeX's textit{} command."},
    fmta("\\textit{<>}",
      {
        d(1, get_visual),
      }
    )
  ),


}, {
  key = "tex_normal"
})
-- }}}


-- ========================================
    -- key="math_autosnip",
    -- type="autosnippets"
-- ========================================
-- {{{
ls.add_snippets("tex",{

  -- ;a -> \alpha
  s({ trig = ";a", name = "alpha", wordTrig=false }, { t("\\alpha") }, {condition=in_math, show_condition=in_math}),
  -- s({ trig = ";a", name = "alpha", wordTrig=false }, { t("\\alpha") }, math_cond),

  -- ;b -> \beta
  s({ trig = ";b", name = "beta", wordTrig=false }, { t("\\beta") }, math_cond),

  -- ;g -> \gamma
  s({ trig = ";g", name = "gamma", wordTrig=false }, { t("\\gamma") }, math_cond),

  -- xx -> \times (곱하기 기호)
  s({ trig = "xx", name = "times", wordTrig=false }, { t("\\times") }, math_cond),

  -- ** -> \cdot (점 곱하기)
  s({ trig = "**", name = "cdot", wordTrig=false }, { t("\\cdot") }, math_cond),
  -- %% -> \cdot (점 곱하기)
  -- s({ trig = "%%", name = "cdot" }, { t("\\cdot ") }, math_cond), -- ** 대신 %%로 안전하게 변경 (정규식 충돌 방지)

  -- ----------------------------------------

  -- ff ==> \frac{}{}
  -- {{{
  -- s({trig = '([^%a])ff', regTrig = true, wordTrig = false, condition=in_math},
  --   fmta(
  --     [[<>\frac{<>}{<>}]],
  --     {
  --       f( function(_, snip) return snip.captures[1] end ),
  --       i(1),
  --       i(2)
  --     }
  --   )
  -- ),
  -- ok
  -- -- [줄 맨 처음용 (column=1)]
  -- s({trig = '^ff', regTrig = true, wordTrig = false, condition=in_math},
  --   fmta(
  --     [[\frac{<>}{<>}]],
  --     {
  --       i(1),
  --       i(2)
  --     }
  --   )
  -- ),
  -- ok
  --
  -- cf)
  -- ff ==> /frac{}{}
  -- s({ trig = "ff", name = "fraction" },
  --   fmt("\\frac{{{}}}{{{}}}{}", { i(1), i(2), i(0) }),
  --   math_cond
  -- ),
  -- ok
  -- 주의: Lua 문법 특성상 fmt 안에서 LaTeX의 중괄호({})를 문자 그대로 출력하려면 무조건 두 번({{}}) 써야 에러가 나지 않습니다.
  --
  -- s({trig = "ff", dscr="ff --> \\frac{}{}", condition = in_math,},
  s({trig = "ff", dscr="ff --> \\frac{}{}", },
    fmta(
      "(testing, ok111) \\frac{<>}{<>}",
      {
        i(1, "1st"),
        i(2, "2nd"),
      }
    )
  ),
  -- }}}

  -- ----------------------------------------

  -- ----------------------------------------
  -- superscript
  -- td, sp
  -- 카스텔 스타일: 알파벳 기반 단독 트리거 
  -- td ==> ^{}
  --
  -- td ==>  ^{<cursor>} (to the power of)
  -- rd ==>  ^{(<cursor>)} (to the power of)
  -- rd는 ^{(...)} 처럼 지수 전체를 괄호로 한 번 더 감싸줘야 할 때 사용했습니다.
  -- -- 카스텔 스타일: td 입력 시 ^{<커서>} 생성 (지수 입력 시 ^^보다 손이 편함)

  -- 3. td 입력 시 ^{<커서>} 생성
  -- td 입력 시 임의의 지수 (^{}) 완성 후 커서 이동
  s({ trig = "td", wordTrig = false, hidden=true, dscr="to the power (dscr)" },
    fmta("^{<>}", { i(1) }),
    { condition = in_math, show_condition = in_math }
    -- { condition = in_math,  }
  ),

  s(
    { trig = "sp", regTrig = true, wordTrig = false, hidden = true, dscr="superscript" },
    fmta("^{<>}", { i(1) }), 
    { condition = in_math, show_condition = in_math }
  ),

  -- ^^ ==> ^{}
  -- 2. ^^ 입력 시 ^{<커서>} 생성
  -- in_math에서는 인식 안함
  s(
    { trig = "^^", wordTrig = false, hidden = true },
    fmta("^{<>}", { i(1) })
    -- { condition = in_math, show_condition = in_math }
  ),


  -- sr ==> ^2
  -- sr 입력 시 제곱 (^2) 자동 완성
  s({ trig = "sr", wordTrig=false, dscr = "square", hidden=true }, { t("^2") }, math_cond),

  -- cb ==> ^3
  -- cb 입력 시 세제곱 (^3) 자동 완성
  s({ trig = "cb", wordTrig=false, dscr = "cube", hidden=true }, { t("^3") }, math_cond),


  -- superscript, end
  -- ----------------------------------------

  -- ----------------------------------------
  -- subscript
  -- nn, sb, bm
  s({ trig = "nn", wordTrig = false, hidden = true }, -- 또는 __ 대신 nn / sub 등 사용
    fmta("_{<>}", { i(1) }),
    { condition = in_math, show_condition = in_math }
  ),

  s(
    { trig = "sb", regTrig = true, wordTrig = false, hidden = true, dscr="subscript" },
    fmta("_{<>}", { i(1) }),
    { condition = in_math, show_condition = in_math }
  ),

  s(
    { trig = "bm", regTrig = true, wordTrig = false, hidden = true, dscr="subscript (bottom)" },
    fmta("_{<>}", { i(1) }),
    { condition = in_math, show_condition = in_math }
  ),

  -- x1 ==> x_{1}
  -- {{{
  -- -------------------
  -- 4. 알파벳 + 숫자 1자리 -> x1 -> x_{1}
  -- [정규식] x1 -> x_1, v2 -> v_2 (문자+숫자 입력 시 아래첨자 자동 매핑)
  -- ([a-zA-Z])(%d) 패턴 감지 -> a1 입력 시 a_{1} 로 자동 변경
  -- ([a-zA-Z]) : 영문 대/소문자 1글자를 감지하고 1번 캡처 그룹(captures[1])에 저장
  -- (%d) : 오직 1자리 숫자 1개만 감지하고 2번 캡처 그룹(captures[2])에 저장
  -- 동작 예시: x1 입력 시 $\rightarrow$ captures[1] = "x", captures[2] = "1" $\rightarrow$ x_{1}로 변환
  -- -------------------
  -- }}}
  -- s({
  --   trig = "([a-zA-Z])(%d)",
  --   regTrig = true,
  --   wordTrig = false,
  --   -- snippetType = "autosnippet",
  --   hidden = true,
  --   dscr="x1 --> x_{1}",
  -- }, f(function(_, snip)
  --   return snip.captures[1] .. "_{" .. snip.captures[2] .. "}"
  -- -- end), { condition = in_math }),
  -- -- end), { math_cond }),
  -- end),  math_cond ),
  -- ok
  -- 아래 00 -->{}가 더 나은 것 같음. so, comment out. 


  -- 00 --> _{}
  -- {{{
  -- A fun zero subscript snippet
  --
  -- ---------
  -- cf) x1 --> x_{1} 과 trig의 regex에 의해 --> regex shadowing !!!
  -- This snippet is shadowed by a previous snippet of s({ trig = "([a-zA-Z])(%d)",... )
  --
  --   s({ trig = "([a-zA-Z])(%d)", dscr="x1 --> x_{1}", ... )
  -- ([a-zA-Z]) : 영문 대/소문자 1글자를 감지하고 1번 캡처 그룹(captures[1])에 저장
  -- (%d) : 오직 1자리 숫자 1개만 감지하고 2번 캡처 그룹(captures[2])에 저장
  -- ---------
  --
  -- -----------------------
  -- 1) ([%a%)%]%}%|]) : 첫 번째 캡처 그룹 해석
  --
  -- () (Group): 이 괄호 안에 매칭된 문자는 LuaSnip의 snip.captures[1] 변수에 저장되어 본문에서 재사용됩니다.
  --
  -- [...] (Character Class): 대괄호 안에 나열된 문자들 중 딱 한 글자와 매칭됩니다.
  --
  -- %a: Lua 정규표현식 패터닝에서 모든 알파벳 하나(a~z, A~Z)를 의미합니다.
  --
  -- %): 소괄호 닫기 ) (특수문자 패스스루용 % 탈출문자 적용).
  --
  -- %]: 대괄호 닫기 ] (특수문자 패스스루용 % 탈출문자 적용).
  --
  -- %}: 중괄호 닫기 } (특수문자 패스스루용 % 탈출문자 적용).
  --
  -- %|: 수식 절대값 기호나 파이프 | (특수문자 패스스루용 % 탈출문자 적용).
  --
  -- 요약: "알파벳 하나, 또는 닫는 괄호 ), ], }, 또는 파이프 | 중 어느 한 글자"를 찾아 감쌉니다.
  --
  -- ex) 
  -- | x00 |  x_{|} | 변수 $x$의 아래첨자 입력 |
  -- | a00 |  a_{|} | 변수 $a$의 아래첨자 입력 |
  -- | )00 |  )_{|} | 괄호 뭉치 뒤 전체에 아래첨자 붙이기 |
  -- | ]00 |  ]_{|} | 행렬/벡터 닫는 기호 뒤 아래첨자 |
  -- | }00 |  }_{|} | 스니펫으로 생성된 구조물 뒤 아래첨자 |
  -- | |00 |  |_{|} | 절대값/노름(Norm) 기호 뒤 아래첨자 |
  -- -----------------------
  -- }}}
  s({trig = '([%a%)%]%}%|])00', regTrig = true, wordTrig = false, condition = in_math,},
    fmta(
      "<>_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual), -- 수식 내부 입력창 (첫 번째 탭)
        -- i(1, '1')
      }
    )
  ),



  -- __ ==> _{}
  -- 1. __ 입력 시 _{<커서>} 생성
  -- -- in_math에서는 인식 안함
  s({ trig = "__", wordTrig = false, hidden = true, dscr="subscript" },
    fmta("_{<>}", { i(1) })
    -- { condition = in_math, show_condition = in_math }
  ),

  -- subscript,end
  -- ----------------------------------------


  -- [정규식] 분수 캡처: (상수나 변수)/ 입력 시 분수로 자동 리팩토링
  -- 예: 1/ 입력 시 \frac{1}{} 로 변환
  s({ trig = "([%a%d]+)/", regTrig = true, hidden=true, dscr = "auto fraction" },
    fmt("\\frac{{{}}}{{{}}}{}", {
      f(function(_, snip) return snip.captures[1] end),
      i(1),
      i(0)
    }),
    math_cond
  ),

  -- ---------------------------------------
  -- ⑤ 괄호 및 유틸리티
  -- ---------------------------------------
  -- () 입력 시 \left( \right) 로 자동 감싸기 (수식 크기에 맞춰 조절됨)
  s({ trig = "((", dscr = "left right parenthesis" },
    fmt("(aaaa) \\left( {} \\right){}", { i(1), i(0) }),
    math_cond
  ),
  -- ok

  -- LEFT/RIGHT PARENTHESES
  -- by ejmastnak
  s({trig = "([^%a])l%(", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "(ejmastnak) <>\\left(<>\\right)",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- ok, 

  -- ---------------------------------------
  -- 환경문(Environment) 자동 완성 스니펫
  -- ---------------------------------------
  -- [행렬] begmat -> \begin{matrix} 자동 완성
  s({ trig = "begmat", name = "matrix environment" },
    fmt([=[
    \begin{{matrix}}
      {}
    \end{{matrix}}{}
    ]=], { i(1), i(0) }),
    math_cond
  ),

  -- [p-행렬(괄호)] begpmat -> \begin{pmatrix} 자동 완성
  s({ trig = "begpmat", name = "pmatrix environment" },
    fmt([=[
    \begin{{pmatrix}}
      {}
    \end{{pmatrix}}{}
    ]=], { i(1), i(0) }),
    math_cond
  ),

  -- [정렬 수식] begali -> \begin{aligned} (디스플레이 수식 안에서 주로 사용)
  s({ trig = "begali", name = "aligned environment" },
    fmt([=[
    \begin{{aligned}}
      {}
    \end{{aligned}}{}
    ]=], { i(1), i(0) }),
    math_cond
  ),

  -- [케이스 구분] begcas -> \begin{cases} 자동 완성
  s({ trig = "begcas", name = "cases environment" },
    fmt([=[
    \begin{{cases}}
      {}
    \end{{cases}}{}
    ]=], { i(1), i(0) }),
    math_cond
  ),


  -- ----------------------------------------
  -- ----------------------------------------
  -- choice node cycling 
  -- ----------------------------------------
  -- ----------------------------------------

  -- ex)
  s("var", {
      c(1, {
          t("const"),
          t("let"),
          t("var"),
      }),
      t(" "), i(2, "variable_name"), t(" = "), i(3, "value")
  }),
  -- ok

  -- ex)
  s("fn", {
    c(1, {
      t("public "),
      t("private "),
      t("protected "),
      i(nil, ""), -- 아무것도 붙이지 않거나 직접 커스텀 키워드 입력 가능
    }),
    t("function "), i(2, "name"), t("()")
  }),
  -- public function name() 등이 생성
  -- ok.

  -- ----------------------------------------
  -- ex)
  s("func111", {
    c(1, {
      -- 선택지 1: 화살표 함수
      sn(nil, {
        t("const "), i(1, "name"), t(" = ("), i(2), t(") => { "),
        i(3),
        t(" }"),
      }),
      -- 선택지 2: 표준 function 키워드 함수 (줄바꿈 처리 적용)
      sn(nil, {
        t({ "function " }),
        i(1, "name"),
        t("("),
        i(2),
        t({ ") {", "\t" }), -- 줄바꿈 후 들여쓰기(\t)
        i(3),
        t({ "", "}" }),     -- 줄바꿈 후 닫는 중괄호
      }),
    }),
  }),
  -- ok

  -- 더 쉽게 입력하려고, fmta() helpper 이용
  -- > --> >> 로 Escaping 처리 (가장 간단함)
  s("func222", {
    c(1, {
      -- 선택지 1: 화살표 함수 (=> 대신 =>> 사용)
      sn(
        nil,
        fmta(
          [[
const <> = (<>) =>> {
  <>
}
]],
          { i(1, "name"), i(2), i(3) }
        )
      ),
      -- 선택지 2: 일반 함수
      sn(
        nil,
        fmta(
          [[
function <>(<>) {
  <>
}
]],
          { i(1, "name"), i(2), i(3) }
        )
      ),
    }),
  }),
  -- ok

  -- delimiters 옵션 변경 (추천)
  -- 이스케이프하는 대신, <> 델리미터 자체를 다른 문자로 바꿈
  -- fmta 호출 시 3번째 인자로 { delimiters = "<>" } 대신 다른 문자를 지정해 주면 됩니다.
  --
  -- cf)
  -- fmta에 옵션을 넣을 때는 인자 3개의 순서와 괄호 위치가 정확해야 합니다.
  -- 첫 번째 인자: [[ multiline string ]] (스니펫 템플릿)
  -- 두 번째 인자: { i(1), i(2), ... } (노드 배열)
  -- 세 번째 인자: { delimiters = "[]" } (옵션 테이블)
  s("func333", {
    c(1, {
      -- 선택지 1: 화살표 함수 (delimiters = "[]" 사용)
      sn(
        nil,
        fmta(
          [[
const [1] = ([2]) => {
  [3]
}
]],
          { i(1, "name"), i(2), i(3) },
          { delimiters = "[]" }
        )
      ),
      -- 선택지 2: 일반 함수 (delimiters = "[]" 사용)
      sn(
        nil,
        fmta(
          [[
function [1]([2]) {
  [3]
}
]],
          { i(1, "name"), i(2), i(3) },
          { delimiters = "[]" }
        )
      ),
    }),
  }),
  -- ok

  -- ----------------------------------------
  -- 예시 1: 분수 3단 변형(frac/dfrac/tfrac) 스니펫 (단축어: ccaa)
  -- ----------------------------------------
  s({ trig = "ccaa111", description = "Fractions (frac/dfrac/tfrac) choice" }, {
    -- 1. [Choice Node] 분수 종류 선택 (\frac, \dfrac, \tfrac)
    c(1, {
      t("\\frac"),  -- 기본 분수
      t("\\dfrac"), -- 디스플레이용 큰 분수
      t("\\tfrac"), -- 텍스트 라인용 작은 분수
    }),
    t("{"),
    -- 2. 비주얼 선택 텍스트가 분자(i) 자리에 들어가도록 Dynamic Node(d) 사용
    d(2, get_visual, {}), -- 1. 세 번째 인자를 명시적으로 빈 테이블로 전달
    -- d(2, get_visual), -- 2. 세 번째 인자 생략 (LuaSnip이 내부에서 nil을 {}로 처리)
    t("}{"),
    -- 3. 분모 입력 칸
    i(3),
    t("}"),
  }),
  -- ok

  -- fmta 형태로 변형.
  -- 1. delimiters = "[]" 적용 버전 (가장 안전하고 깔끔함)
  -- 줄바꿈 처리 안전화: fmta([[ ... ]]) 내부에서 멀티라인 문자열을 그대로 사용하여 \n 관련 nvim_buf_set_text 에러를 방지했습니다.
  -- fmta 내부 템플릿을 [[ ... ]]로 감쌌기 때문에 \frac 대신 \\frac을 쓰더라도 안전하고 깔끔하게 렌더링됩니다.

  -- {{{
  --
  -- #$ fmta([[ ... ]]) 형태... 즉 [[ . . . ]]의 유용성
  --
  -- ---
  --
  -- 루아(Lua)에서 `[[ ... ]]`는 **'로 문자열(Raw String)'** 또는 '다중 행 문자열(Multiline String)'을 작성하는 표기법입니다.
  --
  -- 특히 LuaSnip에서 `fmta([[ ... ]])` 형태로 작성할 때 `[[ ... ]]`가 제공하는 핵심 유용성은 크게 **3가지**입니다.
  --
  -- ---
  --
  -- ## 1. 백슬래시(`\`) 이스케이프(Escape) 지옥 탈출
  --
  -- 일반 큰따옴표(`"..."`)나 작은따옴표(`'...'`) 안에서는 백슬래시(`\`)가 특수 문자(예: `\n`, `\t`)를 뜻하는 이스케이프 문자로 동작합니다.
  --
  -- 따라서 LaTeX 명령어나 C언어 문장 등을 작성할 때 백슬래시를 일일이 두 번(`\\`) 써야 했습니다. 하지만 `[[ ... ]]` 안에서는 **문자 그대로(Raw)** 인식됩니다.
  --
  -- * **일반 문자열 (`"..."`) 사용 시:**
  -- ```lua
  -- t("\\frac{\\alpha}{\\beta}") -- 백슬래시를 전부 \\ 로 2번씩 써야 함
  --
  -- ```
  --
  --
  -- * **Raw String (`[[ ... ]]`) 사용 시:**
  -- ```lua
  -- fmta([[ \frac{\alpha}{\beta} ]], { ... }) -- 화면에 보이는 그대로 \ 작성 가능!
  --
  -- ```
  --
  --
  --
  -- > **Note:** 스니펫에 LaTeX 코드가 많을수록 백슬래시를 1개만 써도 된다는 점이 엄청난 편의성을 제공합니다.
  --
  -- ---
  --
  -- ## 2. 코드 모양 그대로 '줄바꿈(Enter)' 작성 가능
  --
  -- 일반 문자열은 줄바꿈을 하려면 `\n`을 쓰거나 문자열을 계속 이어 붙여야 하지만, `[[ ... ]]`는 **키보드 Enter를 친 모양 그대로 스니펫의 줄바꿈으로 인식**합니다.
  --
  -- * **일반 문자열 (`"..."`) 사용 시:**
  -- ```lua
  -- t({ "function foo() {", "\treturn true;", "}" }) -- 줄 단위로 테이블을 나누어 작성
  --
  -- ```
  --
  --
  -- * **Raw String (`[[ ... ]]`) 사용 시:**
  -- ```lua
  -- fmta([[
  -- function foo() {
  --     return true;
  -- }
  -- ]], { ... }) -- 실제 코드 구조를 눈으로 보면서 작성
  --
  -- ```
  --
  --
  --
  -- ---
  --
  -- ## 3. 따옴표(`"`, `'`)와의 충돌 방지
  --
  -- 스니펫 템플릿 안에 큰따옴표(`"`)나 작은따옴표(`'`)가 들어갈 때, 이스케이프(`\"`, `\'`)를 신경 쓸 필요가 전혀 없습니다.
  --
  -- ```lua
  -- -- 따옴표가 많은 HTML/JS/TeX 스니펫도 이스케이프 없이 작성 가능
  -- fmta([[ <div class="container" id='app'>[1]</div> ]], { i(1) }, { delimiters = "[]" })
  --
  -- ```
  --
  -- ---
  --
  -- ## 📌 요약: 왜 `fmta([[ ... ]])` 조합을 즐겨 쓸까?
  --
  -- | 구분 | 일반 문자열 (`"..."`) | Raw String (`[[ ... ]]`) |
  -- | --- | --- | --- |
  -- | **백슬래시** | `\\frac` (2번 작성) | `\frac` (1번 작성, LaTeX 최적화) |
  -- | **줄바꿈** | `\n` 또는 테이블 `{ "a", "b" }` 분리 | Enter 키로 입력한 모양 그대로 반영 |
  -- | **가독성** | 문자열 연산자로 복잡해짐 | **스니펫 완성본 모양이 눈에 바로 보임** |
  --
  -- 결론적으로 `[[ ... ]]`를 사용하면 "스니펫 템플릿을 실제 에디터에 출력될 코드 모양과 100% 똑같이 눈으로 보면서 편하게 작성"할 수 있다는 것이 가장 큰 유용성입니다.
  --
  -- }}}
  s(
    { trig = "ccaa222", description = "Fractions (frac/dfrac/tfrac) choice" },
    fmta(
      [[
  [1]{[2]}{[3]}
  ]],
      {
        -- 1. 분수 종류 선택
        c(1, {
          t("\\frac"),  -- 기본 분수
          t("\\dfrac"), -- 디스플레이용 큰 분수
          t("\\tfrac"), -- 텍스트 라인용 작은 분수
        }),
        -- 2. 분자 (get_visual 연동)
        d(2, get_visual),
        -- 3. 분모 입력 칸
        i(3),
      },
      { delimiters = "[]" }
    )
  ),
  -- ok

  -- 2. 기본 델리미터 <> 버전
  s(
    { trig = "ccaa333", description = "Fractions (frac/dfrac/tfrac) choice" },
    fmta(
      [[
  <1>{<2>}{<3>}
  ]],
      {
        -- 1. 분수 종류 선택
        c(1, {
          t("\\frac"),
          t("\\dfrac"),
          t("\\tfrac"),
        }),
        -- 2. 분자 (get_visual 연동)
        d(2, get_visual),
        -- 3. 분모 입력 칸
        i(3),
      }
    )
  ),
  -- ok

  -- 시작 커서를 분자 내부로 설정
  --[[
  LuaSnip에서 스니펫이 확장(Expand)되면 커서가 가장 먼저 들어가는 위치는 Choice Node가 있느냐 없느냐가 아니라, 숫자 인덱스가 가장 작은 노드(보통 1번)입니다.

기존 작성법: c(1, ...)이 1번이었기 때문에 스니펫 트리거 즉시 커서가 Choice Node 위치(\frac)로 갔던 것입니다.

수정 작성법: Choice Node의 번호를 2번이나 3번으로 미루고, 분자 칸(d 또는 i)을 1번으로 지정하면 스니펫이 실행되자마자 커서가 바로 {} 내부(분자 칸)로 들어갑니다.

커서가 choice node 위치에 있을 때, <C-f>를 누르면 Choice Node(\frac ➔ \dfrac ➔ \tfrac)가 실시간으로 바뀝니다!

🛠️ 수정된 fmta 코드 (시작 커서를 분자 내부로 설정)
노드 번호만 아래처럼 교체해 주시면 됩니다.

1번 노드: 분자 위치 (d(1, get_visual)) ➔ 커서 시작 위치!

2번 노드: Choice Node (c(2, ...))

3번 노드: 분모 위치 (i(3)
  --]]
  s(
    { trig = "ccaa444", description = "Fractions with initial cursor inside numerator" },
    fmta(
      [[
  [2]{[1]}{[3]}
  ]],
      {
        -- 1. 커서가 가장 먼저 도착하는 분자 칸 (get_visual 연동)
        d(1, get_visual),

        -- 2. Choice Node를 2번으로 지정 (커서가 분자에 있어도 <C-f>로 cycling 가능!)
        c(2, {
          t("\\frac"),  -- 기본 분수
          t("\\dfrac"), -- 디스플레이용 큰 분수
          t("\\tfrac"), -- 텍스트 라인용 작은 분수
        }),

        -- 3. 분모 입력 칸 (<Tab> 이동 위치)
        i(3),
      },
      { delimiters = "[]" }
    )
  ),

  -- ----------------------------------------
  -- choice node cycling, end
  -- ----------------------------------------

  -- ----------------------------------------
  -- testing



















  -- testing, end
  -- ----------------------------------------


}, {
    key="math_autosnip",
    type="autosnippets"
})
-- }}}

-- ========================================
  -- type = "autosnippets",
-- ========================================
-- {{{
ls.add_snippets("tex", {

  -- mk ==> \(\)
  -- {{{

  -- {{{
  --[[
  %a: Lua 정규표현식에서 모든 알파벳 글자(대문자/소문자 a-z, A-Z)를 의미하는 문자 클래스입니다.
  [^ ... ]: 대괄호 안에 캐럿(^)이 들어가면 "여기에 적힌 문자가 아닌 것(NOT)"을 의미하는 부정 조건이 됩니다.
  [^%a]: 알파벳이 아닌 문자 딱 1글자
  즉, 숫자(0-9), 공백(스페이스, 탭, 엔터), 문장 부호(,, ., (, [), 심지어 한글이나 특수문자 등 알파벳만 아니라면 무엇이든 이 조건에 매칭됩니다.
  "반드시 mm 바로 앞글자는 알파벳이 아닐 때만(예: 공백이거나, 숫자 뒤거나, 괄호 바로 뒤일 때만) 수식 스니펫을 트리거하겠다"

  -- --------------
  주의) [^%a]의 조건를 판별하기 위해서는 "알파벳이 아닌 '글자' 딱 1개"를 반드시 필요로 합니다.
  즉, 숫자(0-9), 공백(스페이스, 탭, 엔터), 문장 부호(,, ., (, [), 심지어 한글이나 특수문자 등이 반드시 앞에 있어야 한다.

  만약 줄의 맨 처음에서는 공백조차 없는 '무(無)'의 상태이기 때문에, [^%a]는 존재하지 않는 빈 공간을 '글자'로 인식하지 못하므로 매칭에 실패하고, 동작하지 않는다.

  해결 방법: 줄의 맨 처음(^)도 포함하도록 정규식 수정하기
  줄의 맨 처음(문서의 시작 또는 줄바꿈 바로 뒤)을 뜻하는 정규표현식 기호는 ^입니다.

  따라서 "줄의 맨 처음이거나(^), 혹은 알파벳이 아닌 글자([^%a]) 뒤에 mm이 올 때"로 조건을 확장해 주어야 합니다.

  🛠️ 올바른 정규식 패턴: (^|[^%a])mm
  |는 정규식에서 OR(또는)을 의미합니다.
  (^|[^%a]): "줄의 맨 처음이거나(^), 알파벳이 아닌 다른 문자([^%a])"라는 뜻이 됩니다.
  ==> 하지만 
  Lua 패턴에는 | (OR) 연산자를 아예 지원하지 않습니다.
  Lua 엔진은 |를 "또는"으로 해석하지 않고, 그냥 수식에 적힌 문자 그대로의 파이프라인(|) 글자로 인식해 버립니다.
  Lua에서 줄의 맨 처음을 뜻하는 앵커 기호 ^는 반드시 패턴의 가장 첫 글자로만 와야 합니다. 그리고
  대괄호 [...] 안으로 들어가는 순간, 이 ^는 "줄의 맨 처음"이라는 의미를 완전히 잃어버리고 "~가 아닌 것(Negation)"이라는 정반대의 의미로 고정되어 버립니다.
  따라서 Lua 패턴 엔진의 한계상, "줄의 맨 처음"과 "특정 문자 세트"를 대괄호나 괄호로 묶어서 동시에 표현하는 것이 문법적으로 불가능했던 것입니다.
  ==> 그래서, 스니펫 선언을 2개로 분리: "문장 중간 수식 시작" 과 "줄 맨 처음 수식 시작"
  -- --------------

  Regex Capture Group (정규식 캡처 그룹)이란?
  정규표현식에서 괄호 ( )로 감싼 부분을 "캡처 그룹(Capture Group)"이라고 부릅니다.
  Neovim이 문서를 감시하다가 이 트리거를 만나면, 단순히 매칭만 하고 끝나는 것이 아니라 1번(첫번째) 괄호 ([^%a]) 자리에 들어온 진짜 문자가 무엇인지 메모리에 살짝 저장(캡처)해 둡니다.
    만약 에디터에 1mm을 입력했다면 ➔ 1번 캡처 그룹에 숫자 1이 저장됩니다.
    만약 에디터에 1234mm을 입력했다면 ➔ 1번 캡처 그룹에 숫자 4이 저장됩니다.
    만약 에디터에 (스페이스)mm을 입력했다면 ➔ 1번 캡처 그룹에 공백(  )이 저장됩니다.

  3. f( function(_, snip) return snip.captures[1] end )는 무엇을 하나요?
  📌 무엇을 보존(preserve)한다는 뜻인가요?
  정규식 트리거(regTrig = true)는 조건이 맞아서 스니펫을 실행하는 순간, 트리거 조건에 부합했던 기존 텍스트를 화면에서 완전히 지워버리고 스니펫 결과물로 덮어씁니다.
  예를 들어 에디터에 
  1mm이라고 적었을 때, 스니펫이 실행되면 1mm 전체가 싹 지워집니다.
  하지만 우리는 수식 앞에 있던 숫자 1은 지워지지 않고 그대로 남기를 원합니다! 바로 이때 지워질 뻔한 앞글자(1번 캡처 그룹에 들어있던 1)를 구출해 와서 원래 자리에 고스란히 복원(보존)해 놓는 역할을 하는 것이 이 함수 노드입니다.
  ex)
  prog11mm을 입력했을 때, 이 정규식이 매칭을 시도하는 범위는 맨 뒤에서부터 역산하여 1mm 딱 3글자뿐입니다.
  트리거 매칭: 1mm 영역이 매칭됩니다.
  이때 1번 캡처 그룹(captures[1])에 저장되는 값은 오직 "1"입니다.
  앞의 prog1은 매칭 영역이 아니므로 애초에 삭제 대상도 아닙니다.
  텍스트 삭제: 매칭된 1mm만 화면에서 지워집니다. (화면 상태: prog1)
  스니펫 전개: f(function... captures[1]) 노드가 실행되면서 지워졌던 "1"을 그 자리에 다시 뱉어냅니다.
  결과: prog1 + 1 + $|$ ➔ 최종적으로 화면에는 prog11$|$가 남게 됩니다.
  --]]
  -- }}}

  -- ----------------------------------------
  -- s({ trig = "mk", wordTrig = true },
  s({ trig = "([^%a])mk", wordTrig = false, regTrig = true, hidden=true },
    fmta(
      -- "<>$<>$",
      "<>\\(<>\\)",
      -- "<>\\(<>\\)<>",
      {
        -- {{{
        -- 첫 번째 빈칸(<>) 채우기: f(...) 함수가 실행되어 snip.captures[1]에 저장해 둔 글자(한개의 글자)을 뱉어내어 채움.
        -- snip.captures[1]은 정규식의 1번 괄호(즉, [^%a] 위치)에 들어왔던 
        -- 진짜 글자를 리턴합니다.
        --
        -- 글자 보존 원리 (snip.captures[1]): 정규식 트리거는 발동하는 순간 조건에 맞았던 텍스트를 화면에서 전부 지워버립니다. 만약 1mk을 입력했다면 앞의 숫자 1까지 지워지게 됩니다. 이때 f(function... captures[1] end) 노드가 1번 괄호(([^%a]))에 잡혀있던 숫자 1을 메모리에서 구출하여 원래 자리에 고스란히 복원(보존)해 줍니다. 최종적으로 화면에는 1$|$가 남게 됩니다.
        -- }}}
        f( function(_, snip) return snip.captures[1] end ),

        -- {{{
        -- 두 번째 빈칸(<>) 채우기: 비주얼 셀렉션(get_visual)이 있다면 가져와서 $ $ 사이에 넣고, 없으면 그냥 커서 i(1)를 대기시킵니다.
        -- }}}
        d(1, get_visual),

        -- i(0),
      }
    )
  ),
  -- {{{
  -- ==> 줄의 맨 처음(^)일때는 regex 조건이 잡아내지 못하므로
  -- 스니펫 선언을 2개로 분리:
  -- (1) "문장 중간 용 스니펫" 과 (2) "줄 맨 처음 용 스니펫"
  -- ==> 고려사항: latex 문서에서 과연 "줄 맨 처음"에 스닛펫을 쓸 경우가 았는지 고려할 것 !!!
  -- }}}

  -- [column=1일 때 대비] (줄 맨 처음 용)
  s({ trig = "^mk", wordTrig = false, regTrig = true, hidden = true },
    fmta(
      "\\(<>\\)",
      -- "\\(<>\\)<>",
      {
        d(1, get_visual),
        -- i(0),
      }
    )
  ),
  -- ----------------------------------------
  -- }}}

  -- dm ==> \[ \]
  -- {{{
  -- [문장 중간용 dm]
  s({ trig = "([^%a])dm", wordTrig = false, regTrig = true, hidden=true },
  -- s({ trig = "([^%a%$])dm", wordTrig = false, regTrig = true },
  -- {{{
  -- (ee 스니펫에서 경험하셨던 것처럼, 문장 중간용 정규식 트리거인)
  -- ([^%a])dm은 인라인 수식 기호인 $ 바로 뒤에서 공백 없이 dm을 입력할 때, $dm 전체를 지워버려 마커를 파괴할 위험이 있습니다.
  -- 보안책: 패턴을 ([^%a])dm에서 ([^%a%$])dm으로 수정하여 앞에 있는 달러 기호를 집어삼키지 못하도록 안전장치를 걸어주는 것이 좋습니다.
  -- s({ trig = "([^%a%$])dm", wordTrig = false, regTrig = true },
  -- }}}
      fmta(
        [[
          <>
          \[
              <>
          \]
          <>
        ]],
        {
          f( function(_, snip) return snip.captures[1] end ), -- 지워진 앞글자 복원
          d(1, get_visual), -- 수식 내부 입력창 (첫 번째 탭)
          -- i(1), -- 수식 내부 입력창 (첫 번째 탭)
          -- {{{
          -- d(1, get_visual) : 
          -- 한 줄짜리 글이 아니라, 여러 줄을 선택하고 dm을 누르면, get_visual_test 함수가 들여쓰기나 줄바꿈을 예쁘게 정돈하지 못하고 텍스트가 찌그러져 들어갈 수 있습니다.
          -- 디스플레이 수식은 대개 빈 공간에서 새로 시작하는 경우가 많으므로, 
          -- 비주얼 선택 영역 복사 기능을 빼고 깔끔하게 i(1)로 지정해 두는 것이 수식 줄바꿈 편집 시 훨씬 안정적입니다
          -- }}}
          i(0), -- 수식 외부 탈출창 (마지막 탭)
        }
      )
    ),
    -- [줄 맨 처음용 (column=1) dm]
    s({ trig = "^dm", wordTrig = false, regTrig = true, hidden=true },
      fmta(
        [[
          \[
              <>
          \]
          <>
        ]],
        {
          d(1, get_visual),
          -- i(1), -- 수식 내부 입력창 (첫 번째 탭)
          i(0), -- 수식 외부 탈출창 (마지막 탭)
        }
      )
    ),
  -- ----------------------------------------
  -- }}}

  -- ee ==> e^{} (Euler's number raised to a power)
  --{{{
  --{{{
  --[[
  -- ----------------------------------------
  -- Make ee expand to e^{} (Euler’s number raised to a power) 
  --
  -- 만약 "mm ==> $|$"의 스닛펫을 쓸경우, 독바로 고백없이 "ee ==> e^{|}" 스니펫 사용 할 경우 발생되는 문제(ㅇ류동작)
  --
  -- $$ 안에서의 문제 발생
  -- s({trig = '([^%a])ee', regTrig = true, wordTrig = false},
  1. 문제의 상황 ➔ 공백이 전혀 없을 때 ($ee)
    ==> mm + (공백없이) ee --> ($e^{|}$)

    1. mk을 눌러 $|$가 된 상태에서 공백 없이 곧바로 ee를 입력합니다. ($ee$)

    2. LuaSnip 엔진은 ee의 바로 앞글자인 수식 기호 $를 검사합니다. $는 알파벳이 아니므로 [^%a] 조건에 완벽히 매칭됩니다.

    3. [치명적인 지점] ee 스니펫이 발동하는 순간, 엔진은 매칭된 영역인 $와 ee 전체($ee)를 버퍼에서 싹 지워버립니다. (이 순간 문서에는 닫는 달러$ 기호 1개만 남게 됩니다.)

    4. 그리고 스니펫이 펼쳐지면서 f(function...) 노드가 캡처했던 $ 기호를 원래 자리에 복원합니다.

    5. 결과적으로 겉보기에는 $e^{2}$처럼 보이지만, Neovim과 LuaSnip 내부 구조 관점에서는 원래 mm이 만들어둔 시작 $ 기호가 삭제되고, ee 스니펫이 강제로 재생성한 $ 기호로 대체된 상태가 됩니다.
    ("앞글자 $를 지웠다 복구하는 과정에서 좌표 마커가 파괴된 것"임)

    6. 결론: ee 스니펫이 mm 스니펫의 경계선($)을 침범하여 집어삼킨 후 재생성했기 때문에, 두 스니펫의 추적 구조가 내부적으로 꼬여버린 것입니다. 이 때문에 첫 번째 탭은 꼬인 노드를 정리하는 데 소모되고, 두 번째 탭이 되어서야 완전히 탈출하게 되는 것입니다.

  2. 완벽한 해결 방법
  해결책은 아주 간단합니다. ee 스니펫이 발동할 때, 알파벳이 아닌 문자 중에서 수식 기호($)만큼은 절대로 침범하지 않도록 제외해 주면 됩니다.

  Lua 정규표현식 대괄호 안에서 ^ 뒤에 문자를 나열하면 "이 문자들을 제외한 것"이라는 뜻이 됩니다. 알파벳(%a)과 달러 기호($) 둘 다 제외하도록 [^%a%$]로 수정하면 끝납니다.
  -- 🌟 [수정] [^%a] 에서 [^%a%$] 로 변경하여 앞의 수식 기호($)를 침범하지 못하도록 방어
  s({trig = '([^%a%$])ee', regTrig = true, wordTrig = false},
    fmta(
      "<>e^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- 🌟 [추가 안전장치] 만약 $ 바로 뒤에서 공백 없이 ee를 쓸 때를 위한 전용 스니펫
  -- 이 스니펫은 mm이 만들어 둔 기존 수식 기호 $를 지우지 않고 놔둔 채, 오직 ee 2글자만 지우고 e^{<>}를 확장합니다
  s({trig = '$ee', wordTrig = false},
    fmta(
      "$e^{<>}",
      {
        d(1, get_visual),
      }
    )
  ),

  -- ** 하지만, 현재 인라인 수식으로 $$를 사용하지 않고, 대신 \(|\)를 사용하니, placeholdder 깨짐(좌표마커 깨짐) 문제는 없다.
  ------------------------------------------
  --]]
  --}}}

  s({trig = "([^%a])ee", wordTrig = false, regTrig = true},
    fmta(
      "<>e^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  s({trig = "^ee", wordTrig = false, regTrig = true},
    fmta(
      "e^{<>}",
      {
        d(1, get_visual),
      }
    )
  ),
  --}}}

  -- h1 ==> \section{}
  -- {{{
  -- {{{
  --[[
  -- 새줄에서 확장하기
  # expansion only at the start of a new line
  -- ----------------------------------------

  (1) using a built-in expansion condition : line_begin
  or
  (2) using regex : "^([%s]*)foo" 

  ==> condition=line_begin 을 쓰는
  것이 더 좋다.

  즉, 
  s({trig = "^([%s]*)h1", dscr="Top-level section", wordTrig=false, regTrig=true, condition = line_begin },.....
  보다는 
  다음과 같이 line_begin 조건을 사용하면 
  s({trig = "h1", dscr="Top-level section", condition = line_begin },.....
  trig="h1"의  h1 문자열만 소비(consume)하여 대체하므로, 에디터에 이미 입력되어 있던 앞쪽 공백이나 탭을 건드리지 않고 그대로 유지해 줍니다. 또한 regTrig=true 같은 것을 안써줘도 되므로 코드가 한결 간결하다.

  -- ----------------------------------------
  (1) using a built-in expansion condition : line_begin

  line_begin = require("luasnip.extras.expand_conditions").line_begin 이용
  - 앞에공백이 여러개 있어도 됨

  -- ----------------------------------------
  (2) using regex : "^([%s]*)foo" 

  "^([%s]*)foo" 
  - Lua 정규표현식(Pattern)에서 "현재 줄의 맨 처음이거나, 혹은 앞에 오직 공백(스페이스나 탭)만 있는 상태에서 foo가 입력되었을 때"를 의미하는 조건식입니다.
  - 들여쓰기(Indent)된 상태까지 포함하여 사실상 아무런 앞 단어가 없는 순수한 줄의 시작 상태를 의미

  --
  ^ (anchor): 문자열(또는 줄)의 시작 위치를 지정하는 앵커 기호입니다.
  %s (whitespace class): 스페이스, 탭(\t), 줄바꿈(\n) 등 모든 공백 문자를 의미하는 특수 문자 클래스입니다.
  * (zero or more quantifier): 바로 앞의 요소가 '0개 이상' 반복될 수 있음을 뜻하는 수량자입니다.

  -- 분석
  (1) ^ (줄의 시작): 패턴의 맨 앞에 붙은 이 기호는 커서가 "줄의 가장 첫 번째 칸"에서부터 검사를 시작하라는 절대 명령입니다.
  (2) ([%s]*) (0개 이상의 공백):
      %s는 공백(스페이스, 탭)을 뜻합니다.
      *은 0개 이상을 뜻하므로, 공백이 아예 없어도 되고, 스페이스가 5칸이든 탭이 2칸이든 상관없이 전부 인정하겠다는 의미입니다.
      괄호 ()로 감싸져 있으므로, 이 공백들은 추후 snip.captures[1]로 구출할 수 있도록 캡처 그룹에 저장됩니다.
  (3) foo (트리거 문자열): 앞의 조건(줄 시작 + 공백들)을 만족한 바로 직후에 문자열 foo가 정확히 붙어 나와야 합니다.

  --
  2. 왜 "새로운 줄(New Lines)"에서만 작동한다고 할까?

  1) 작동하는 경우 (True)
  foo ➔ 줄 맨 앞에 공백이 0개인 상태로 시작했으므로 매칭 성공
      foo ➔ 앞선 코드의 들여쓰기(스페이스 4칸) 뒤에 foo를 썼으므로 매칭 성공
  \t\tfoo ➔ 탭(Tab) 키를 두 번 눌러 들여쓰기한 뒤 foo를 썼으므로 매칭 성공

  2) 작동하지 않는 경우 (False)
  print(foo ➔ foo 앞에 공백이 아닌 print(라는 문자열이 존재하므로 매칭 실패
  a = foo ➔ foo 바로 앞에는 공백이 있지만, 그 앞줄의 시작(^) 사이에 a =라는 문자가 가로막고 있으므로 매칭 실패

  즉, 요약하자면: 문장 중간에 삽입되는 foo에는 절대로 반응하지 않고, 사용자가 엔터를 치고 새로운 줄을 만들어서 들여쓰기만 맞춘 채 무언가 새로운 코드를 시작하려는 순간에만 이 스니펫을 실행하겠다는 강력한 제어 장치입니다.
  --]]
  -- }}}

  -- s({trig = "h1", dscr="Top-level section", condition = utils.cond.line_begin },
  s({trig = "h1", dscr="\\section{}", hidden=true, condition = line_begin },
    fmta(
      [[\section{<>}]],
      {
        d(1, get_visual), -- 수식 내부 입력창 (첫 번째 탭)
        -- i(1)
      }
    )
  ),
  -- }}}

  -- h2 ==> \subsection{}
  -- {{{
  -- {{{
  -- 제대로동작.
  -- 정확히, s({trig = "h2", dscr="\\subsection", condition = line_begin },와 동일한 동작
  -- s({trig = "^([%s]*)h2", dscr="\\subsection",
  -- wordTrig = false, regTrig = true,
  --   -- condition = line_begin 
  --   },
  --   fmta(
  --     [[<>\subsection{<>}]],
  --     {
  --       -- 첫번째 <> : 정규식 첫 번째 캡처 그룹 ([%s]*)으로 잡은 공백을 문자열 맨 앞에 다시 출력하도록 만들어 
  --       -- 앞쪽 공백이나 탭을 건드리지 않고 들여쓰기가 그대로 유지되게 만든다.
  --       f( function(_, snip) return snip.captures[1] end ),  -- 앞의 들여쓰기 공백 복원
  --       d(1, get_visual), -- 수식 내부 입력창 (첫 번째 탭)
  --       -- i(1)
  --     }
  --   )
  -- ),
  -- }}}

  s({trig = "h2", dscr="\\subsection{}", condition = line_begin },
    fmta(
      [[\subsection{<>}]],
      {
        d(1, get_visual), -- 수식 내부 입력창 (첫 번째 탭)
        -- i(1)
      }
    )
  ),
  -- }}}

  -- new ==> \begin{env} ... \end{env}
  -- {{{
  s({ trig = "new", dscr = "\\begin{env} . . .\\end{env}, A generic new environment", condition = line_begin },
    fmta(
      [[
        \begin{<>}
            <>
        \end{<>}
        <>
      ]],
      {
        i(1, "env"),      -- 1: 환경 이름 지정 (기본값 "env", 예: align, itemize 등)
        d(2, get_visual), -- 2: 비주얼 선택했던 본문 텍스트가 여기 들어감
        rep(1),           -- 3: 1번에서 입력한 환경 이름을 자동 복사
        i(0),             -- 0: 스니펫 완료 후 다음 커서 위치
      }
    )
  ),
  -- }}}


  -- ========================================

  -- ----------------------------------------
  -- ----------------------------------------
  -- ========================================



}, {
  type = "autosnippets",
})
-- }}}

-- ========================================
  -- key = "testing",
  -- type="autosnippets"
-- ========================================
-- {{{
ls.add_snippets("tex", {

  s({ trig = "key222", name = "key222 alpha" }, { t("(key222=testing) \\alpha ") } ),


  -- ----------------------------------------
  -- ----------------------------------------
  -- 다중 condition 할용 예시
  s({ trig = "ff333",  }, fmta("(ff333, in_math) \\frac{<>}{<>}", { i(1), i(2) })),
  -- works !!!

  s({ trig = "ffmath333",  }, fmta("(ff333, in_math) \\frac{<>}{<>}", { i(1), i(2) }), {condition=in_math}),
  -- works !!!



-- ----------------------------------------
-- 예시 1: (in_math and line_begin) or (in_text and not line_begin)
-- 조건: "수식 안이면서 줄 시작이거나" OR "텍스트 안이면서 줄 시작이 아닐 때"

-- (add_snippets 외부, 상단에 선언)
-- local my_complex_cond = cond_any(
--   cond_all(in_math, line_begin),
--   cond_all(in_text, not_line_begin)
-- )

  -- s({ trig = "ffccc",  }, fmta("(ffccc, in_math) \\frac{<>}{<>}", { i(1), i(2) }), {
  --   -- condition=in_math
  --   condition = function()
  --     return (in_math() and line_begin()) or (in_text() and not line_begin())
  --   end
  -- }),
  -- ==> error
  --
  -- LuaSnip이 제공하는 기본 확장 조건(Expand Condition) 객체인 line_begin은 단순한 일반 함수가 아니라, 내부적으로 line_begin(line_to_cursor, matched_trigger, captures) 형태와 같이 , line_to_cursor, matched_trigger 같은 인자(Context)를 전달받아야 작동하도록 설계된 조건 함수(또는 객체)입니다.
  --
  -- condition 익명 함수, function() ... end, 
  -- 내부에서 line_begin이나 in_math 같은 LuaSnip 조건 함수를 사용할 때는, 괄호를 떼고 LuaSnip이 요구하는 인자(line_to_cursor, matched_trigger, captures)를 그대로 전달해 주어야 합니다.

  s({ trig = "ffccc" }, fmta("(ffccc, in_math) \\frac{<>}{<>}", { i(1), i(2) }), {

  -- 💡 function() ... end 로 감싸서 실행 시점에 평가되도록 만듭니다.
  condition = function(line_to_cursor, matched_trigger, captures)
    -- 1) 사용자 정의 함수(in_math, in_text)는 인자 없이 호출 가능하다고 가정
    -- 2) LuaSnip 내장 조건(line_begin)에는 받은 인자를 그대로 전달해 주어야 함
    local is_line_begin = line_begin(line_to_cursor, matched_trigger, captures)

    return (in_math() and is_line_begin) or (in_text() and not is_line_begin)
  end
}),
  -- ==> work !!!
-- 주의할 점: aaa, bbb 등 각 조건 변수 뒤에 ()를 붙여서 함수를 호출하고 그 true/false 결과를 and / or / not으로 엮어야 합니다.

  -- 동일한 스니펫:  cond_all, cond_any, cond_not 헬퍼 함수 활용 버전 (매번 익명 함수(람다, function() ... end)를 안쓰므로, 더 깔끔한 방법)
-- s({ trig = "ffddd" }, fmta("(ffddd, in_math) \\frac{<>}{<>}", { i(1), i(2) }), {
  --
        -- ❌ 잘못된 방식: in_math()와 in_text()를 즉시 실행해서 결과를 전달함
--     condition=cond_any(
--       cond_all(in_math(), line_begin),
--       cond_all(in_text(), line_begin)
--     )
-- }),
  -- ==> error 발생 !!!
  --
  -- in_math()처럼 괄호 ()를 붙여서 넘겨버리면 스니펫 파일이 로드되는 시점에 in_math()가 평가되어 결과값(true 또는 false 보조 boolean 값)이 cond_all로 넘어가게 됩니다.
  -- 조건 합성에 전달할 때는 함수 그 자체(참조)를 넘겨주어야 키를 누를 때마다 커서 위치를 실시간으로 판별합니다.
  -- ffddd 스니펫 조건 부분의 in_math(), in_text()에서 괄호 ()를 제거합니다
  s({ trig = "ffddd" }, fmta("(ffddd, in_math) \\frac{<>}{<>}", { i(1), i(2) }), {
    -- 🟢 올바른 방식: 함수 자체를 전달
    condition = cond_any(
      cond_all(in_math, line_begin),
      cond_all(in_text, not line_begin) -- 항상 false
    )
}),
  -- cond_all(in_text, not line_begin) -- 항상 false ==> 오류
  -- line_begin은 일반 boolean 변수가 아니라 LuaSnip 조건 객체(또는 함수)이기 때문에, 앞에 Lua의 not 연산자를 붙이면 (not line_begin) Lua는 객체 존재 유무만 판단하여 항상 false가 되어버립니다.
  --
  -- line_begin의 반대(줄 시작이 아님) 조건을 만드시려면 조건 결과를 반전시키는 부정(NOT) 헬퍼 함수를,cond_not(), 사용

s({ trig = "ffeee" }, fmta("(ffeee, in_math) \\frac{<>}{<>}", { i(1), i(2) }), {
    condition = cond_any(
      cond_all(in_math, line_begin),
      cond_all(in_text, cond_not(line_begin))
    )
}),
  -- ==> all right !!!
-- ----------------------------------------





-- 2. (응용) 만약 줄 시작 + 수식 안 조건을 동시에 쓰실 때 (cond_all 이용)
s({ trig = "ffmath444" }, fmta("(ffmath444, in_math and line begin) \\frac{<>}{<>}", { i(1), i(2) }), { 
    condition = cond_all(line_begin, in_math)
    }),
  -- ok !! 


-- ### 예시 3: `in_math and in_even_line

-- * **조건**: "수식 내부이면서 동시에 짝수 줄에 있을 때"

s(
  { trig = "ffmath555" },
  fmta("(ffmath555, in_math and not in_commet) \\frac{<>}{<>}", { i(1), i(2) }),
  {
    condition = function()
      -- return in_math() and not in_comment()
      -- return in_math() and in_comment()  -- never haappened !!!
      return in_math() and in_even_line()
    end
  }
),
  -- ok

s(
  { trig = "ffmath666" },
  fmta("(ffmath666, in_math and not in_commet) \\frac{<>}{<>}", { i(1), i(2) }),
  {
    condition = cond_all(in_math, in_even_line), show_condition=in_math

  }
),
  -- ok, 

  -- 다중 condition 할용 예시, end
  -- ----------------------------------------
  -- ----------------------------------------



}, {
  key = "testing",
  type="autosnippets"
})
-- }}}



-- return을 비워두거나 생략해도 됨 (add_snippets로 이미 등록 완료됨)
return {}, {}

