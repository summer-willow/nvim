
-- 자동 확장 속성을 강제로 주입하는 함수
-- 일반 스니펫 구조(s(...))에 자동 확장 속성(snippetType = "autosnippet")을 강제로 주입하는 단축 함수.
local as = function(context, nodes)
  context.snippetType = "autosnippet" -- 이 한 줄이 자동완성 팝업창을 완전히 건너뛰게 만듭니다.
  return s(context, nodes)
end
--{{{
--[[
## LuaSnip의 자동스니펫 구분방법
- LuaSnip 엔진 내부에는 스니펫을 저장하는 방이 크게 2가지로 나뉩니다.
  1. snippets 방 (탭이나 확정을 눌러야 터지는 일반 스니펫)
  2. autosnippets 방 (입력 즉시 터지는 자동 스니펫)
-LuaSnip 엔진이 개별 스니펫 객체를 검사할 때, snippetType = "autosnippet"이 있으면 엔진은 무조건 이 스니펫을 2번 방(autosnippets)으로 집어넣습니다.

## LuaSnip 엔진이 완벽하게 지원하는 '자동스니펫'' 설정 (순정)방법.
s({ trig = "xnn", wordTrig = true, snippetType = "autosnippet" }, {
  t("summer_willow")
}),
- 단점: s() 함수 설정란마다 snippetType = "autosnippet"을 일일이 타이핑 해야하는 불편함 발생.
- ==> as 함수를 만들어 해결: 위 방식이 너무 귀찮아서, as()라는 자동 도장을 만들어 누를 때마다 snippetType = "autosnippet"이 자동으로 찍히게 만듦.

## as 함수
local as = function(context, nodes)
- 의미: as 함수는 context와 nodes라는 2개의 인자를 넘겨받는다.
- 이들 인자들은 table 형태도 가능하다.
- 인자 이름은 아무거나 해도 됨, ex) local as = function(aaa, bbb)

  context.snippetType = "autosnippet"
  - 의미: 넘겨받은 첫 번째 인자 안에 에 `snippetType = "autosnippet"` 를 강제로 삽입

  return s(context, nodes)
  - 의미: context와 nodes를 LuaSnip의 순정 빌더 함수인 `s(...)`에게 전달.
  - 그리고 그 `s(...)`가 최종적으로 완성해 낸 스니펫 객체를 return

## 실제 as(...)의 실행 결과
ex) 
as({ trig = "xnn", wordTrig = true, desc = "기본 상용구 고정 텍스트" }, {
  t("summer_willow")
}),

-- 컴퓨터가 최종적으로 이해하는 최종 명령의 정체
s({ 
  trig = "xnn", 
  wordTrig = true, 
  desc = "기본 상용구 고정 텍스트", 
  snippetType = "autosnippet" 
}, { 
  t("summer_willow") 
})

--결과적으로, LuaSnip 엔진이 완벽하게 지원하는 '자동스니펫'' 설정 (순정)방법이 완성된다.
s({ trig = "xnn", wordTrig = true, snippetType = "autosnippet" }, {
  t("summer_willow")
}),
--]]
--}}}

-- -- ---------------------------------------
-- Visual Selection Snippet Trigger을 가능하게 해주는 헬퍼 함수 불러오기
-- cf) Visual Selection Snippet Trigger (비주얼 선택 영역 스니펫 트리거 = Variables from Selection)

-- 🌟 공통 유틸리티 파일에서 헬퍼 함수 불러오기 
-- local util = require("utils.luasnip_util")

-- ---------------------------------------

return {

  -------------------------------------------------------------
  -- [A 그룹] 입력 즉시 바로 터지는 자동 스니펫 (autosnippet)
  -- 즉, nvim에서의 상용구(Abbreviation, 줄임말) 역활을 한다.
  -------------------------------------------------------------


  -- ;xnn ==> summer_willow
  -- {{{
  as({ trig = "xnn", wordTrig = true, desc = "기본 상용구 고정 텍스트" }, {
    t("summer_willow")
  }),
  -- }}}

  -- ;xll (labelling) ==> 2026_07_19_19_06_28
  -- {{{
  -- xll (labelling) --> useful for labeling_index in LaTeX 
  as({ trig = "xll", wordTrig = true, desc = "(labeling_indwx) 현재 날짜/시간 동적 출력" }, {
    f(function()
      -- os.date: 현재 시스템의 날짜와 시간을 원하는 형식 문자열로 반환하는 Lua 내장 함수
      return os.date('%Y_%m_%d_%H_%M_%S')
    end)
  }),
  -- }}}

  -- ;xdd (date) ==> 2026-07-19 19:08:32
  -- {{{
  as({ trig = "xdd", wordTrig = true, desc = "현재 날짜/시간 동적 출력" }, {
    f(function()
      return os.date('%Y-%m-%d %H:%M:%S')
    end)
  }),
  -- }}}

  -- ;xtt (time) ==> 19:11:13
  -- {{{
  as({ trig = "xtt", wordTrig = true, desc = "현재 시각(시:분:초) 동적 출력" }, {
    f(function()
      -- %H는 00 ~ 23 형식
      return os.date('%H:%M:%S')
    end)
  }),
  -- }}}

  -- --- ==> ----------------------------------------
  -- cmm ==> -- ----------------------------------------
  -- {{{
  -- 주석 가로 분리선/구분선: Comment (주석) 또는 Comment Marker (주석 표시선)
  -- trig name 추천: div (divider), line, sep (separator), hl (horizontal line), dl (divider line), ldiv (lua divider), cdiv (comment divider), coml (comment line) 
  s({ trig = "---", wordTrig = true, desc = "구분선/분리선 생성" }, {
    t("----------------------------------------") -- (--------- 만) 40개
    -- t("-- ----------------------------------------") -- (--------- 만) 40개
  }),
  as({ trig = "cmm", wordTrig = true, desc = "분리선/구분선 생성 (-- 포함)" }, {
    -- cf) trig="c--"
    -- t("----------------------------------------") -- (--------- 만) 40개
    t("-- ----------------------------------------") -- (--------- 만) 40개
  }),
  -- }}}



  -------------------------------------------------------------
  -- [B 그룹] 필요할 때 골라 쓰는 일반 스니펫 (선택 사항)
  -- 기존처럼 목록 창이 뜨고 선택(Confirm)해서 사용하는 형태입니다.
  -------------------------------------------------------------

  -- (test)
  -- s({ trig = "example-normal", desc = " (test) 일반 스니펫 예시" }, {

  -- s({ trig = "exam", desc = " (test) 일반 스니펫 예시", name = "See? ya ?" }, {
  --   t("This is normal snippet")
  -- }),


-- s({ trig = "exam", name = "See? ya?", desc = "(test) 일반 스니펫 예시" }, {
--   t("This is normal snippet")
-- }),


-- 🌟 [정석 가이드] desc(설명) 영역의 앞부분에 우리가 보고 싶었던 이름을 같이 적어줍니다.
-- s({ 
--   trig = "exam", 
--   name = "See? ya ?", 
--   desc = "See? ya ? | (test) 일반 스니펫 예시" -- ➔ blink의 label_description과 doc에 완벽하게 걸립니다!
-- }, {
--   t("This is normal snippet")
-- }),









-- ---------------------------------------
-- Visual Selection Snippet Trigger
-- 예제 테스트 스니펫
-- cf) Visual Selection Snippet Trigger (비주얼 선택 영역 스니펫 트리거 = Variables from Selection)

  -- -- visula section block을 \texttb{...}으로 감싼다.
  -- s({ trig = "bf" }, {
  --   t("\\textbf{"),
  --   -- 만약 비주얼 선택된 단어가 있다면 그걸 뱉고, 없으면 커서가 위치할 빈칸($1) 제공
  --   f(util.get_visual, {}),
  --   i(1),
  --   t("}")
  -- }),

  -- -- 수식을 \left( \right) 로 감싸는 스니펫 예시
  -- s({ trig = "lrp" }, {
  --   t("\\left( "),
  --   f(util.get_visual, {}), -- 복사 붙여넣기 대신 util.get_visual 사용
  --   i(1),
  --   t(" \\right)"),
  -- }),

-- ---------------------------------------

}



-- vim: set foldmethod=marker foldmarker={{{,}}} foldlevel=0 :
