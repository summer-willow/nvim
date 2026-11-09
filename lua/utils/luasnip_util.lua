-- ~~/nvim/lua/utils/luasnip_util.lua

-- LuaSnip의 snippets들응 위한 공통 유틸리티들은 모아둔 파일

-- ----------------------------------------
-- 🚀 유틸리티 파일 내부에서 사용할 LuaSnip API 명시적 선언
-- 스니펫 파일이 아닌 공용 도구함(모듈)이므로, 내부에서 사용되는 핵심 함수들이 정상 작동할 수 있도록  의존성을 바인딩해 주는 것입니다.
local ls = require("luasnip")
local sn = ls.snippet_node
local i = ls.insert_node

-- ----------------------------------------
-- Lua/Neovim 버전 호환성 처리
local unpack_fn = table.unpack or unpack -- Neovim/Lua 버전 호환성 처리
-- table.unpack 호환성 선언
-- Lua 5.1(Neovim이 사용하는 LuaJIT 버전)에서는 unpack이 global 함수로 존재하며, table.unpack은 존재하지 않거나 nil일 수 있습니다. 따라서 table.unpack(args)를 호출할 때 attempt to call field 'unpack' (a nil value) 에러가 발생합니다.
-- 따라서, luasnip_util.lua 파일 상단이나 함수 내부에서 unpack 호환성 선언을 해주어야 합니다.
-- ----------------------------------------


-- ----------------------------------------
-- cf)
-- 현재 파일에서 condition 모둘을 (~~/nvim/lua/utils/luasnip_condition.lua) 직접 사용하고 싶을 때.
-- condition 모둫을 직접 require 한다.
-- local cond_collect = require("utils.luasnip_condition")
-- 사용예
-- condition = cond_collect.in_math

local M = {}

-- ----------------------------------------
-- visual selection triggering
-- visual로 선택 --> <Tab> --> triggering snippet with dynanic node --> <Tab>  
--
--[[
🧐 1. Dynamic Node d()의 인자 구조

LuaSnip에서 d() 함수의 실제 정의

  d(pos, fn, arg_nodes, user_args)

1번째 인자 (pos): 점프 순서 번호 (예: 2)
2번째 인자 (fn): 실행할 함수 (예: get_visual)
3번째 인자 (arg_nodes): 함수 내부로 전달할 다른 노드들의 값 참조 목록 (예: 1번 노드의 값을 가져오고 싶다면 {1})
4번째 인자 (user_args): 사용자 정의 추가 인자 테이블

① 세 번째 인자 역할
세 번째 인자는 get_visual 함수가 실행될 때 "다른 노드의 입력값을 실시간으로 관찰할 필요가 있는가?"를 지정하는 곳입니다.

예를 들어, i(1)에 입력한 텍스트에 따라 동적으로 모양이 바뀌는 노드를 만들 때는 d(2, my_func, {1}) 처럼 1번 노드를 넘겨줍니다.

하지만 get_visual은 다른 노드의 입력을 관찰할 필요 없이 오직 비주얼 모드로 선택했던 텍스트(LS_SELECT_RAW)만 가져오는 함수입니다. 따라서 참조할 노드가 없다는 뜻으로 명시적인 빈 테이블 {}을 적어주거나 생략해도 됩니다.

② 생략해도 되는 이유 (d(2, get_visual))
LuaSnip 내부 코드에서는 세 번째 인자가 전달되지 않거나 nil일 경우, 자동으로 빈 테이블 {}로 처리하도록 구현되어 있습니다.
--]]
--
-- 🚀 안전장치가 결합된 최신 표준 비주얼 스니펫 헬퍼 (Dynamic Node용)
function M.get_visual(args, parent)
  -- 1. [Gemini의 안전장치] 부모 노드 및 환경 변수가 실제로 존재하는지 꼼꼼하게 검사
  if parent and parent.snippet and parent.snippet.env then
    local env = parent.snippet.env
    -- 2. [ejmastnak의 최신 이름 표준] LS_SELECT_RAW를 사용
    if env.LS_SELECT_RAW and #env.LS_SELECT_RAW > 0 then
      -- 비주얼 영역이 있으면 그 텍스트를 i(1) 입력 칸 안에 넣어서 반환
      return sn(nil, i(1, env.LS_SELECT_RAW))
    end
  end

  -- 3. 비주얼 영역이 없거나 에러 상황이면 그냥 깨끗한 빈 입력 칸 i(1)을 생성
  return sn(nil, i(1))
end

-- ----------------------------------------

-- ========================================
-- [테이블 병합용 헬퍼 함수]
-- 두 개의 스니펫 테이블(t1, t2)을 하나로 이어 붙여 새로운 합체 테이블을 만듭니다.
-- ==> return{} 방식에서 활용, 하지만 add_snippets()에서도 활용 가능할 듯.
-- ex)
-- return aaa_snippets, concat(math_autosnippets, text_autosnippets)
-- ----------------------------------------
-- local function concat(t1, t2)
function M.concat(t1, t2)
  -- 1단계: 첫 번째 테이블(t1)을 복사하여 새로운 결과용 테이블(res) 생성
  -- (table.unpack 사용으로 원본 t1을 보호하면서 새 배열을 만듭니다)
  -- local unpack_fn = table.unpack or unpack -- Neovim/Lua 버전 호환성 처리
  local res = { unpack_fn(t1) }

  -- 2단계: 두 번째 테이블(t2)의 요소들을 하나씩 순회하며 res 뒤에 덧붙임
  for _, v in ipairs(t2) do
    table.insert(res, v) -- res 테이블 맨 마지막 위치에 v 추가
  end

  -- 3단계: t1과 t2가 모두 하나로 합쳐진 최종 테이블 반환
  return res
end

-- ========================================
-- 가변 인자 다중 조건(condition) 합성 헬퍼 함수
-- ----------------------------------------
--
--[[

# 다중 condition 만들기


LuaSnip에서 다중 조건을 논리 연산자로 묶으려면 익명 함수(람다, function() ... end)로 감싸서, "스니펫이 실행되는 그 순간"에 조건들이 평가되도록 만드셔야 합니다.

스니펫의 condition은 "참/거짓을 반환하는 함수(Function)"를 기대합니다.
따라서 여러 함수를 combinations(결합)할 때는 익명 함수(람다, function() ... end) 안에서 실행(())하여 논리 연산을 수행해야 합니다.


## 💡 기본 원리

`s()` 함수를 사용할 때 다중 조건을 적용하려면, 3번째 인자인 옵션 테이블(`opts`)에 `condition = function() ... end` 형태로 익명 함수(람다)를 전달합니다.

s({ trig = "트리거" }, 노드들, {
  condition = function()
    return (aaa() and bbb()) or (ccc() and ddd())
  end
})

> **핵심 포인트**: `aaa`, `bbb` 등 각 조건 변수 뒤에 **`()`를 붙여서 실행**해야 하며, `and / or / not`을 사용하여 논리식을 작성합니다.








--]]


-- ----------------------------------------
-- # condition의 개수에 (1개든, 2개든,..., N개든) 상관없이 작동하는, 가변 인자 다중 조건 합성 헬퍼 함수
-- Lua의 **가변 인자(`...`)** 개념을 활용하여 **원하는 만큼 개수 제한 없이 조건들을 한 번에 넘겨서 처리하는 헬퍼 함수**
-- (unpack_fn 호환성 처리 포함)

-- ----------------------------------------
-- N개 조건의 AND 결합 (1개, 2개, N개 모두 지원, line_begin 등 내장 조건 호환)
-- ----------------------------------------
-- N개의 조건을 모두 만족해야 하는 AND 헬퍼 (모두 true여야 true)
--
-- line_begin 같은 LuaSnip 조건 객체(condition object)'는, line_begin(line_to_cursor, matched_trigger, captures) 형태로 인자를 전달받아야 실행되므로, 이를 보완.
-- cf) 사용자 정의 트리짓/Treesitter 조건 (in_math, in_text 등): 보통 Vim API를 이용해 커서 위치의 하이라이트/구문 나무를 직접 조회하므로 in_math()처럼 인자 없이 호출해도 잘 동작합니다.
--
-- 따라서, luasnip_util.lua의 cond_all과 cond_any가 (1) 일반 함수와 (2) LuaSnip 조건 객체, 그리고 (3) LuaSnip이 넘겨주는 인자(...)까지 모두 안전하게 처리할 수 있도록 래핑 함수를 만들어야 한다.
--
-- 
---

--[[


## 📝 사용 예시


## 1. 조건이 없을 때 (0개일 때)

조건이 필요 없는 스니펫은 3번째 인자인 옵션 테이블(`opts`) 자체를 생략하거나 빈 테이블로 두시면 됩니다. 기존에 사용하시던 가장 익숙한 기본 형태로 쓰시면 완벽합니다.

조건이 없으면 3번째 인자를 생략하고, 조건이 1개 이상 필요할 때는 cond_all과 cond_any만 적재적소에 조합해서 사용하시면 됩니다!
condition 키가 아예 없는(즉, 조건이 없는 일반 스니펫) 경우는, 수식 영역이든 텍스트 영역이든 관계없이 아무 데서나 확장됩니다.













## ⚙️ 단 한 가지 유의할 점: 인자가 0개일 때 (Edge Case)

혹시라도 `cond_all()`이나 `cond_any()`처럼 인자를 **0개** 넣고 호출할 때의 반환값 규칙만 알아두시면 됩니다.

* **`cond_all()` (인자 0개)**: 반복문이 안 도므로 바로 `true`를 반환합니다. (수학적으로 빈 set의 AND 연산 = True)
* **`cond_any()` (인자 0개)**: 반복문이 안 도므로 바로 `false`를 반환합니다. (빈 set의 OR 연산 = False)

실제로 스니펫을 작성하실 때 인자를 0개 넣을 일은 없으므로, **1개 이상의 모든 인자 개수에 대해 아무 신경 쓰지 않고 편하게 사용**하시면 됩니다!
--]]
--
--
--
-- ----------------------------------------
function M.cond_all(...)
  local conds = { ... }

  -- LuaSnip이 condition 검사 시 넘겨주는 인자들(line_to_cursor, matched_trigger 등)을 받기 위해 ... 전달
  -- return function(...) 인자 전달:
  -- LuaSnip 실행 시점에 들어오는 문맥 인자(line_to_cursor 등)를 받아서 내부 cond들에 그대로 검사 인자로 전달합니다. line_begin은 커서 앞쪽 텍스트(line_to_cursor)가 필요한데, 이 인자가 정상 전달되어 에러 없이 줄 시작 여부를 판별합니다.
  return function(...)
    local args = { ... }
    for _, cond in ipairs(conds) do
      local res = false

      -- 타입 안전 검사 (type(cond)):
      -- 사용자 정의 함수(in_math, in_text)는 function으로 바로 실행하고, LuaSnip 내장 객체(line_begin)는 내부 호출 방식(cond:check(...) 또는 __call)에 맞춰 안전하게 인자를 전달하며 평가합니다.
      if type(cond) == "function" then
        -- 일반 함수인 경우
        res = cond(unpack_fn(args))
      elseif type(cond) == "table" and cond.check then
        -- LuaSnip 객체 형태의 condition인 경우 (.check 메서드 호출)
        res = cond:check(unpack_fn(args))
      elseif type(cond) == "table" and getmetatable(cond) and getmetatable(cond).__call then
        -- __call 메타메서드가 있는 객체인 경우
        res = cond(unpack_fn(args))
      elseif type(cond) == "boolean" then
        -- 혹시 boolean 값이 넘어왔을 경우에 대한 예외 처리
        res = cond
      end

      if not res then
        return false -- 하나라도 false면 즉시 false 반환
      end
    end
    return true -- 모두 통과하면 true
  end
end

-- ----------------------------------------
-- N개 조건의 OR 결합 (1개, 2개, N개 모두 지원, line_begin 등 내장 조건 호환)
-- N개 중 하나라도 만족하면 되는 OR 헬퍼 (하나만 true여도 true)
function M.cond_any(...)
  local conds = { ... }
  return function(...)
    local args = { ... }
    for _, cond in ipairs(conds) do
      local res = false
      if type(cond) == "function" then
        res = cond(unpack_fn(args))
      elseif type(cond) == "table" and cond.check then
        res = cond:check(unpack_fn(args))
      elseif type(cond) == "table" and getmetatable(cond) and getmetatable(cond).__call then
        res = cond(unpack_fn(args))
      elseif type(cond) == "boolean" then
        res = cond
      end

      if res then
        return true -- 하나라도 true면 즉시 true 반환
      end
    end
    return false -- 모두 false면 false
  end
end

-- ----------------------------------------
-- 조건 반전 (NOT) 헬퍼 함수
-- 전달받은 조건의 결과를 반대로 뒤집어주는 cond_not 함수
-- condition = not line_begin과 같이 (line_begin의 반대 조건), 조건 결과를 반전시키는 부정(NOT) 헬퍼 함수
-- (line_begin 같은 객체와 일반 함수 모두 지원)
-- ----------------------------------------
function M.cond_not(cond)
  return function(...)
    local args = { ... }
    local res = false
    if type(cond) == "function" then
      res = cond(unpack_fn(args))
    elseif type(cond) == "table" and cond.check then
      res = cond:check(unpack_fn(args))
    elseif type(cond) == "table" and getmetatable(cond) and getmetatable(cond).__call then
      res = cond(unpack_fn(args))
    end

    -- 조건의 결과를 반대로 반전 (! / not)
    return not res
  end
end
-- ----------------------------------------

return M


