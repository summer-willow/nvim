-- ~~/nvim/lua/utils/init.lua

-- utils 폴더의 총괄 관리자 파일입니다.
local M = {}

-- 성격별로 쪼개진 모듈들을 하나의 테이블로 병합(Merge)합니다.
M.util = require("utils.luasnip_util")  -- utility
M.cond = require("utils.luasnip_condition") -- condition

-- testing
-- M.cond111=require("utils.luasnip_condition111")   -- testing

return M
