-- ~~/nvim/lua/utils/luasnip_condition.lua

local M = {}

-- ===================================================================
-- [공통 유틸 1] Tree-sitter 노드 상위 탐색 함수
-- ===================================================================
-- [수정] pos 옵션 및 null safety 강화
local function find_node_by_condition(cond_fn, pos)
  local ok, node
  if pos then
    ok, node = pcall(vim.treesitter.get_node, { bufnr = 0, pos = pos })
  else
    ok, node = pcall(vim.treesitter.get_node)
  end

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
-- ===================================================================
local function check_in_env(name)
  return find_node_by_condition(function(node)
    local type = node:type()
    if type == "generic_environment" or type == "math_environment" then
      local begin_node = node:child(0)
      if begin_node then
        local text = vim.treesitter.get_node_text(begin_node, 0)
        if text and text:find("{" .. name .. "}") then
          return true
        end
      end
    end
    return false
  end)
end

function M.in_env(name)
  return function()
    return check_in_env(name)
  end
end

-- ===================================================================
-- [Condition 바인딩] 수식 감지 (통합 개선)
-- ===================================================================

-- ----------------------------------------
-- ----------------------------------------

-- -- [수정] Tree-sitter + 정규식 환경 체크 + VimTeX 하이브리드 수식 감지
-- function M.in_math()
--   -- 1) Tree-sitter 노드 체크
--   local is_math_node = function(node)
--     local type = node:type()
--     return type == "inline_formula"
--         or type == "displayed_equation"
--         or type == "math_environment"
--   end
--
--   -- 현재 커서 및 주변 위치(1~3자 전) 탐색
--   if find_node_by_condition(is_math_node) then return true end
--
--   local cursor = vim.api.nvim_win_get_cursor(0)
--   local row = cursor[1] - 1
--   local col = cursor[2]
--
--   for offset = 1, 3 do
--     if col - offset >= 0 then
--       if find_node_by_condition(is_math_node, { row, col - offset }) then
--         return true
--       end
--     end
--   end
--
--   -- 2) [수정] 환경 기반 검사 (align, equation, bmatrix 등 \begin{...} 감지)
--   if check_in_env("equation") or check_in_env("align") or check_in_env("gather") 
--      or check_in_env("bmatrix") or check_in_env("pmatrix") or check_in_env("math") then
--     return true
--   end
--
--   -- 3) [수정] VimTeX fallback
--   local ok_vimtex, in_mathzone = pcall(vim.fn["vimtex#syntax#in_mathzone"])
--   if ok_vimtex and in_mathzone == 1 then
--     return true
--   end
--
--   -- 4) [수정/추가] 최후의 안전장치: \[ ... \] 및 $ ... $ 내부에 커서가 있는지 줄/문서 기반 정규식 확인
--   -- Tree-sitter가 문법 에러로 노드를 아예 파괴했을 때 커서가 \[ \] 사이에 있는지 판단
--   local lines = vim.api.nvim_buf_get_lines(0, 0, cursor[1], false)
--   local full_text_up_to_cursor = table.concat(lines, "\n")
--
--   -- 마지막으로 열린 \[ 가 \] 보다 뒤에 있으면 현재 수식 블록 내부임
--   local last_open_display = full_text_up_to_cursor:find("%[%s*$") or full_text_up_to_cursor:reverse():find("%[%\\")
--   local last_close_display = full_text_up_to_cursor:reverse():find("%]%\\")
--
--   -- \[ 문맥 체크
--   if last_open_display and (not last_close_display or last_open_display < last_close_display) then
--     return true
--   end
--
--   return false
-- end

-- ----------------------------------------
-- ----------------------------------------j
-- ~~/nvim/lua/utils/luasnip_condition.lua

-- local M = {}

-- ===================================================================
-- [핵심] Tree-sitter 노드 기반 범용 수식 감지
-- ===================================================================

-- 수식 관련 Tree-sitter 노드 타입 판별 함수
local function is_math_node(node)
  if not node then return false end
  local type = node:type()

  -- 1) 대표적인 LaTeX 수식 노드 이름들
  if type == "inline_formula" 
     or type == "displayed_equation" 
     or type == "math_environment" 
     or type == "math_zone" then
    return true
  end

  -- 2) 노드 타입 이름에 'math'나 'formula'가 포함되어 있는 경우 (범용 매칭)
  if type:find("math") or type:find("formula") then
    return true
  end

  -- 3) \begin{align}, \begin{gather} 등의 generic_environment 내부에 있는지 검사
  if type == "generic_environment" then
    local begin_node = node:child(0)
    if begin_node then
      local ok, text = pcall(vim.treesitter.get_node_text, begin_node, 0)
      if ok and text then
        -- 수식 환경 목록 (필요시 추가 가능)
        local math_envs = {
          "align", "align%*", "equation", "equation%*", 
          "gather", "gather%*", "bmatrix", "pmatrix", 
          "vmatrix", "split", "multline", "alignat"
        }
        for _, env in ipairs(math_envs) do
          if text:find("{" .. env .. "}") then
            return true
          end
        end
      end
    end
  end

  return false
end

-- ===================================================================
-- [M.in_math] 커서 위치 및 부모 노드 전체 추적
-- ===================================================================
function M.in_math()
  -- 현재 커서 위치의 노드 가져오기
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then return false end

  -- 최상위 root 노드까지 부모를 계속 거슬러 올라가며 수식 노드가 있는지 확인
  while node do
    if is_math_node(node) then
      return true
    end
    node = node:parent()
  end

  return false
end

-- function M.in_text()
--   return not M.in_math()
-- end

-- function M.in_comment()
--   local ok, node = pcall(vim.treesitter.get_node)
--   if not ok or not node then return false end
--
--   while node do
--     local type = node:type()
--     if type == "comment" or type == "line_comment" then
--       return true
--     end
--     node = node:parent()
--   end
--   return false
-- end

-- M.line_begin = require("luasnip.extras.expand_conditions").line_begin

-- return M








-- ----------------------------------------
--

function M.in_text()
  return not M.in_math()
end

function M.in_comment()
  local is_ts_comment = find_node_by_condition(function(node)
    local type = node:type()
    return type == "comment" or type == "line_comment"
  end)

  if is_ts_comment then return true end

  local line_to_cursor = vim.fn.getline("."):sub(1, vim.fn.col("."))
  local comment_pos = line_to_cursor:find("[^\\]%%") or line_to_cursor:find("^%%")
  return comment_pos ~= nil
end

function M.in_equation() return check_in_env("equation") end
function M.in_itemize()   return check_in_env("itemize") end
function M.in_tikz()      return check_in_env("tikzpicture") end
function M.in_align()     return check_in_env("align") end
function M.in_bmatrix()   return check_in_env("bmatrix") end
function M.in_gather()    return check_in_env("gather") end
function M.in_proof()     return check_in_env("proof") end

M.line_begin = require("luasnip.extras.expand_conditions").line_begin

function M.in_even_line()
  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  return (line_number % 2) == 0
end

return M
