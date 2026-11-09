
-- ~~/nvim/lua/utils/luasnip_condition.lua

-- ----------------------------------------
--{{{ Tree-sitter와 VimTeX Syntax 엔진의 충돌
--[[
* 스니펫의 condition 만들기

- Tree-sitter와 VimTeX Syntax 엔진의 충돌

Neovim 설정에서 LaTeX 파일에 Tree-sitter 구문 강조(Syntax Highlighting)가 활성화되어 있으면, Vim 전통의 Syntax Engine이 비활성화(disabled)됩니다.

NOTE: VimTeX의 수많은 강력한 기능들 중 Vim 전통 구문 엔진(synIDattr)에 의존하는 것은 오직 vimtex#syntax#in_mathzone() 함수 하나뿐입니다.
즉, Tree-sitter를 이용해도, vimtex 기능주에 잃는 것은 오직 vimtex#syntax#in_mathzone() 단 하나뿐이며, 나머지 VimTeX의 모든 최고급 기능은 그대로 유지됩니다.
cf) ejmastnak의 튜토리얼은 작성된 지 시간이 좀 지나 전통적인 Vim 및 구버전 VimTeX 방식 기준에 맞춰져 있으나, 현재 질문자님처럼 Tree-sitter 기반으로 LaTeX 환경을 구축한 Modern Neovim 세팅에서는 Tree-sitter를 켜고 개발하는 것이 표준입니다.

ex) in_comment condition의 예
VimTeX의 vimtex#syntax#in_comment() 및 in_mathzone() 함수는 Vim의 내장 문법 엔진(synstack, synIDattr)을 기반으로 작동하므로, Tree-sitter가 활성화되면 VimTeX이 구문 위치를 읽지 못해 항시 0을 리턴하게 됩니다.

증상 확인법:
.tex 버퍼에서 주석(% ...) 위에 커서를 두고 :echo vimtex#syntax#in_comment()를 실행했을 때 0이 출력된다면 vimtex는 비활성화 됨을 의미
  ==> 실제 해보니, 0이 나옴.

2. 해결 방법
방법 A: Treesitter 기반으로 in_comment 구현 (추천 🌟)

Tree-sitter 노드 이름 확인
주석 위에서 :InspectTree를 입력했을 때 커서 위치에 (comment) 노드가 표시되는지 확인합니다.
==> line_comment

--]]
--}}}
-- ----------------------------------------

-- ----------------------------------------
-- {{{ 함수 선언 방식 M.is_math=function() 과 function M.is_math()의 차이
--[[
함수 선언 2가지 방식의 차이
(1) M.is_math = function() ➔ 원본 문법 (함수를 만들어 변수에 대입), (원본 대입식)
(2) function M.is_math() ➔ 신택틱 슈거 (Syntactic Sugar,문법적 설탕) (사람이 읽기 좋게 다듬은 축약 문법, 추천 방식)
  - 사람이 코드를 읽고 쓰기 편하게 만든 문법적 설탕(Syntactic Sugar)일 뿐이며, 기능이나 성능, 메모리상의 차이는 0.001%도 없습니다.
  - ㅛ준 형태: function M.fn_name() (신택틱 슈거 형태)

두 방식 중 어느 것을 써도 성능 차이는 제로(0)에 가깝습니다. 하지만 프로그래머 사이의 규칙과 가독성을 위해 (2)의 function M.is_math() 스타일로 통일하시는 것을 강력히 추천합니다.

❶ 함수 대입 방식 (M.is_math = function())
-- 이름이 없는 익명 함수(anonymous function)를 만들어서, 
M 테이블의 is_math라는 방에 대입하는 방식입니다.
M.is_math = function()
   코드 내용
end

특징: Lua에서 함수는 일반 숫자나 문자열과 똑같은 '값(Value)'으로 취급됩니다. 따라서 변수에 값을 집어넣듯 직관적으로 대입하는 형태입니다.

❷ 함수 선언 방식 (function M.is_math())
-- 위와 100% 똑같이 컴퓨터가 처리하지만, 사람이 쓰기 편하게 바꾼 문법입니다.
function M.is_math()
   코드 내용
end

특징: 타 언어(C, Python 등)의 함수 선언식과 비슷하여 코드를 읽을 때 눈에 훨씬 잘 들어옵니다. 컴퓨터는 이 코드를 보면 내부적으로 ❶번 형태로 자동 변환하여 실행합니다.


2. 왜 function M.is_math() 방식이 더 좋을까요?

가독성과 유지보수성이 좋아집니다 (더 좋은 이유)
- 직관적인 함수 정의: = function()이라는 불필요한 대입 기호가 사라져 "아, 여기서 함수를 정의하는구나"라는 의도가 한눈에 들어옵니다.

- Neovim/Lua 생태계의 표준 스타일: Neovim 플러그인이나 대부분의 공식 Lua 스타일 가이드에서는 모듈 함수를 정의할 때 function M.func_name() 형태를 표준(Idiomatic Lua)으로 권장합니다.

① 압도적인 시각적 가독성
② 디버깅과 에러 추적(Stack Trace)의 유리함


2. 코드에서 어떤 부분을 바꿔야 할까요?
  - M.으로 외부에 공개하는 모듈 함수들(M.in_env, M.in_math 등): --> M.fn_name = function() 대신 function M.fn_name()으로 변경.
  - 파일 내부에서만 쓰는 지역 함수들(local function find_node...): --> 이미 local function으로 작성되어 있으므로 그대로 유지하시면 됩니다.
--]]
-- }}}
-- ----------------------------------------

local M = {}

-- 🛠️ 통합 유틸 및 통합 환경 감지 함수 사용
--
-- ===================================================================
-- [공통 유틸 1] Tree-sitter 노드 상위 탐색 함수
-- 커서 위치의 노드를 받아와서 상위 노드로 거슬러 올라가며 특정 조건을 만족하는지 검사하는 공통 유틸 함수
-- 파일 내부에서만 쓰는 지역 함수
-- ===================================================================
local function find_node_by_condition(cond_fn)

  -- 현재 커서 위치의 Tree-sitter 노드를 가져옵니다.
  local ok, node = pcall(vim.treesitter.get_node) -- Neovim 내장 API 사용
  if not ok or not node then return false end

  while node do
    if cond_fn(node) then
      return true
    end
    node = node:parent()
  end
  return false
end

-- ===================================================================
-- [공통 유틸 2] LaTeX \begin{name} 환경 이름 감지 함수
-- 파일 내부에서만 쓰는 지역 함수
-- ===================================================================
local function check_in_env(name)
  return find_node_by_condition(function(node)
    local type = node:type()
    -- Tree-sitter는 \begin{...} 구조를 'generic_environment' 등으로 파싱합니다.
    if type == "generic_environment" or type == "math_environment" then
      -- 환경의 첫 번째 자식 노드(보통 \begin{name} 단락)에서 이름을 대조합니다.
      local begin_node = node:child(0)
      if begin_node then
        -- 현재 버퍼에서 해당 노드가 가진 실제 텍스트 문자열을 추출합니다.
        local text = vim.treesitter.get_node_text(begin_node, 0)
        -- 텍스트 내부에 우리가 찾는 환경 이름(예: 'itemize')이 들어있는지 검사
        if text and text:find("{" .. name .. "}") then
          return true
        end
      end
    end
    return false
  end)
end

-- External 래퍼(wrapper) (필요 시 외부에서 동적으로 환경명을 넘길 때 사용)
-- 외부에서 커스텀 환경 검사가 필요할 때 사용할 수 있도록 함수 형태로 제공
-- M.in_env = function(name)
function M.in_env(name) -- 💡 [변경] M.in_env = function(name) 에서 신택틱 슈거로 변경
  return function()
    return check_in_env(name)
  end
end

-- ===================================================================
-- [Condition 바인딩] 스니펫 파일에서 조건(condition)으로 사용할 함수들
-- ===================================================================

-- 1. 수식 영역 감지
-- {{{
--[[
NOTE: 현재 파일의 Tree-sitter 노드 구조를 화면 오른쪽에 시각적으로 보여주는 명령어
:InspectTree

NOTE: in_math() 자체가 제대로 condition을 감지하는지 확인하는 방법
(tex 파일안에서)
:lua print(require("utils.luasnip_condition").in_math())
수식영역안에서는 true가 나와야 하고, 일반 텍스트(수식 밖)에서 false가 출력되어야 정상입니다.

실제 내 treesitter에서는 inline_formula, displayed_equation
--]]
-- }}}
--
-- M.in_math = function()
function M.in_math()
  return find_node_by_condition(function(node)
    local type = node:type()
    return type == "inline_formula"
        or type == "displayed_equation"
        or type == "math_environment"
  end)
end
-- {{{
--[[
-- cf) 수식 영역 감지
-- 개별 condition 방식 (통합 유틸 및 통합 환경 감지 함수를 사용하지 않는 방식)
-- (단지 참조용으로 보관)
function M.in_math()
  -- 현재 커서 위치의 Tree-sitter 노드를 가져옵니다.
  local node = vim.treesitter.get_node()

  -- 부모 노드들을 위로 탐색하며 수식 관련 노드가 있는지 확인합니다.
  while node do
    local type = node:type()
    -- 순수 tex 파서의 대표적인 수식 노드 이름들입니다.
    -- if type == "inline_math" or type == "math_environment" or type == "displayed_equation" then
    if type == "inline_formula" or type == "math_environment" or type == "displayed_equation" then
      return true
    end
    node = node:parent()
  end
  return false
end
-- ==> it works !!!
--]]
-- }}}

-- 2. 일반 텍스트 영역 (수식이 아닌 영역)
-- M.in_text = function()
function M.in_text()
  return not M.in_math()
end

-- 3. 주석 영역 감지 (Tree-sitter + 보완 로직)
-- {{{
--[[
줄에 따라, 혹은 같은 줄이어도 커서 위치에 따라 in_comment 감지가 됐다 안됐다 하는 원인은, TeX 파서가 주석(%)과 그 주변 구문을 해석하는 Tree-sitter의 CST(Concrete Syntax Tree) 구조 특성 때문입니다.

결론부터 말씀드리면, LaTeX Tree-sitter 파서에서 주석 노드의 이름은 line_comment나 block_comment가 아니라 오직 comment 하나뿐이며, 커서 위치에 따라 주석 노드가 생략되거나 파서 노드의 범위가 빗나가는 현상이 발생합니다.

1. 왜 특정 위치에서만 동작을 안 할까요?
① TeX 파서의 노드 이름 문제
TeX(LaTeX) Tree-sitter 파서 문법(Grammar)에서는 주석을 comment 노드로만 표기합니다. line_comment는 다른 언어(C, Python 등)에서 쓰이는 이름입니다.

② 줄 맨 앞이나 주석 기호(%) 직후의 커서 위치 문제 (가장 큰 원인)
vim.treesitter.get_node()는 기본적으로 커서 직후(오른쪽)의 문자를 기준으로 노드를 선택합니다.

  - % 주석 내용 줄에서 커서가 % 바로 앞이나 % 바로 위에 있을 때:
    - Tree-sitter는 이 위치를 아직 주석 내부가 아닌 상위 구문(예: document 또는 text)으로 판단할 수 있습니다.

  - 줄의 맨 마지막(줄바꿈 \n 바로 앞)에 커서가 있을 때:
    - LaTeX 파서에 따라 줄바꿈 문자를 comment 노드에 포함하지 않고 줄바꿈(\n) 노드로 분류하여 comment 탐색이 실패할 수 있습니다.

2. 해결 방법: 주석 영역 감지 함수 개선
이 문제는 커서의 위치를 살짝 왼쪽(현재 커서 바로 전 글자)도 함께 체크하거나, Tree-sitter 실패 시 Vim의 구문 강조(Syntax/HL) 정보 또는 Lua 정규식 fallback을 병행하면 100% 완벽하게 해결됩니다.

3. 핵심 포인트 요약
  - LaTeX 파서 노드 고정: LaTeX Tree-sitter에서 주석은 comment입니다.
  - [^\\]%% Fallback 예외 처리: LaTeX에서는 \%가 단순 문자 '%' 출력용 기호입니다. 따라서 이스케이프(\)되지 않은 % 뒤쪽 문자열은 무조건 주석 영역으로 간주되도록 안전장치를 추가했습니다.
--]]
-- }}}
-- M.in_comment = function()
function M.in_comment()
  -- Tree-sitter 기반 검사
  local is_ts_comment = find_node_by_condition(function(node)
    local type = node:type()
    return type == "comment" or type == "line_comment"
  end)

  if is_ts_comment then return true end

  -- Tree-sitter가 커서 위치(줄 끝/주석 시작점)의 파싱 범위를 놓칠 때를 대비한 보완책 (Fallback)
  -- 현재 커서가 속한 줄에서 % 기호 뒤에 있는지 검사합니다.
  -- Fallback: 커서 이전 문자열 중 이스케이프되지 않은 % 존재 여부
  local line_to_cursor = vim.fn.getline("."):sub(1, vim.fn.col("."))

  -- 줄 중간에 이스케이프되지 않은 % (즉, \% 가 아닌 %) 가 존재하는지 확인
  -- \% 가 아닌 순수 주석 시작 % 기호 뒤에 커서가 있다면 주석으로 판단
  local comment_pos = line_to_cursor:find("[^\\]%%") or line_to_cursor:find("^%%")
  return comment_pos ~= nil
end

-- 4. 구체적인 LaTeX 환경들 (필요할 때마다 이 밑에 한 줄씩 추가하시면 됩니다!)
-- M.in_equation  = function() return check_in_env("equation") end
function M.in_equation() return check_in_env("equation") end

-- M.in_itemize   = function() return check_in_env("itemize") end
function M.in_itemize()  return check_in_env("itemize") end

-- M.in_tikz      = function() return check_in_env("tikzpicture") end
function M.in_tikz()     return check_in_env("tikzpicture") end

-- M.in_align     = function() return check_in_env("align") end
function M.in_align()    return check_in_env("align") end

-- M.in_bmatrix   = function() return check_in_env("bmatrix") end
function M.in_bmatrix()  return check_in_env("bmatrix") end

-- M.in_gather = function() return check_in_env("gather") end
function M.in_gather() return check_in_env("gather") end

-- M.in_proof = function() return check_in_env("proof") end
function M.in_proof() return check_in_env("proof") end

-- ----------------------------------------


-- ----------------------------------------
-- the start of a new line
-- LuaSnip 빌트인 줄 시작 감지 조건 (앞에 공백들이 있어도 됨)
-- 설명: 외부 모듈에서 미리 만들어진 값/함수를 가져와 M 테이블의 line_begin 키에 할당하는 형태입니다.
-- 상태: 신택틱 슈거 대상이 아니며, 외부 모듈의 참조를 바인딩하는 올바른 작성 방식입니다.
M.line_begin = require("luasnip.extras.expand_conditions").line_begin
-- ok!
-- ----------------------------------------

-- ----------------------------------------
-- Silly example: returns true when the cursor is on an even-numbered line
--
--{{{
--[[
-- function M.in_even_line()
--   local line_number = vim.fn['line']('.')
--   if ((line_number % 2) == 0) then  -- an even-numbered line
--     return true
--   else  -- an odd-numbered line
--     return false
--   end
-- end
--
-- 위의 in_even_line 도 아주 잘 동작하지만, Lua의 최신 API와 조건식 스타일을 적용하면 코드를 더욱 간결하고 빠르게 다듬을 수 있습니다.
--
-- 1) Vim script 함수인 vim.fn['line']('.')을 불러오는 것보다, Neovim C-내장 API인 vim.api.nvim_win_get_cursor(0)[1]을 사용하는 편이 실행 속도 면에서 더 효율적입니다.

-- 2) 불리언(Boolean) 직접 반환
-- if...else 문으로 true/false를 나눠서 리턴하기보다 조건식 결과 자체를 바로 리턴하면 1줄로 단순화할 수 있습니다.

-- 💡 다듬은 코드 (Neovim 내장 API + 1줄 반환 스타일)
--]]
--}}}
function M.in_even_line()
  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  return (line_number % 2) == 0
end
-- ----------------------------------------



return M



