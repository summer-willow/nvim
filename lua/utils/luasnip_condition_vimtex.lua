-- ~~/nvim/lua/utils/luasnip_condition.lua

-- ----------------------------------------
--{{{ Tree-sitter와 VimTeX Syntax 엔진의 충돌
--[[
* 스니펫의 condition 만들기

- Tree-sitter와 VimTeX Syntax 엔진의 충돌

Neovim 설정에서 LaTeX 파일에 Tree-sitter 구문 강조(Syntax Highlighting)가 활성화되어 있으면, Vim 전통의 Syntax Engine이 비활성화(disabled)됩니다.

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
  - 표준 형태: function M.fn_name() (신택틱 슈거 형태)

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
function M.in_env(name)
  return function()
    return check_in_env(name)
  end
end

-- ===================================================================
-- [Condition 바인딩] 스니펫 파일에서 조건(condition)으로 사용할 함수들
-- ===================================================================

-- 1. Tree-sitter 기반 수식 영역 감지 (기존 동일)
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
function M.in_math()
  return find_node_by_condition(function(node)
    local type = node:type()
    return type == "inline_formula"
        or type == "displayed_equation"
        or type == "math_environment"
  end)
end

-- 2. Tree-sitter 기반 일반 텍스트 영역 (수식이 아닌 영역)
function M.in_text()
  return not M.in_math()
end

-- ===================================================================
-- [VimTeX 전용 수식 감지 바인딩]
-- ===================================================================

-- 3. VimTeX 전용 수식 영역 감지
-- {{{
--[[
NOTE: VimTeX의 내장 함수인 vimtex#syntax#in_mathzone()을 이용한 조건 감지
:lua print(require("utils.luasnip_condition").vimtex_in_math())
--]]
-- }}}
function M.vimtex_in_math()
  local ok, is_mathzone = pcall(vim.fn["vimtex#syntax#in_mathzone"])
  return ok and is_mathzone == 1
end

-- 4. VimTeX 전용 일반 텍스트 영역
function M.vimtex_in_text()
  return not M.vimtex_in_math()
end

-- ===================================================================

-- 5. 주석 영역 감지 (Tree-sitter + 보완 로직)
function M.in_comment()
  -- Tree-sitter 기반 검사
  local is_ts_comment = find_node_by_condition(function(node)
    local type = node:type()
    return type == "comment" or type == "line_comment"
  end)

  if is_ts_comment then return true end

  -- Tree-sitter가 커서 위치(줄 끝/주석 시작점)의 파싱 범위를 놓칠 때를 대비한 보완책 (Fallback)
  local line_to_cursor = vim.fn.getline("."):sub(1, vim.fn.col("."))
  local comment_pos = line_to_cursor:find("[^\\]%%") or line_to_cursor:find("^%%")
  return comment_pos ~= nil
end

-- 6. 구체적인 LaTeX 환경들
function M.in_equation() return check_in_env("equation") end
function M.in_itemize()  return check_in_env("itemize") end
function M.in_tikz()     return check_in_env("tikzpicture") end
function M.in_align()    return check_in_env("align") end
function M.in_bmatrix()  return check_in_env("bmatrix") end
function M.in_gather()   return check_in_env("gather") end
function M.in_proof()    return check_in_env("proof") end

-- ----------------------------------------
-- the start of a new line
M.line_begin = require("luasnip.extras.expand_conditions").line_begin
-- ----------------------------------------

-- ----------------------------------------
function M.in_even_line()
  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  return (line_number % 2) == 0
end
-- ----------------------------------------

return M
