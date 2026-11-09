-- =====================================================================
-- 🛠️ mini.ai + Treesitter 텍스트 오브젝트 연습 스크립트 (Lua)
-- 
-- 💡 규칙 리마인드:
--    - f = 함수 (Function) | c = 클래스/테이블 (Class) | o = 조건문/루프 (Condition/Loop)
--    - ii / aa = 다음 타깃의 내부/전체
--    - il / al = 이전 타깃의 내부/전체
-- =====================================================================

local M = {} -- 클래스(c) 대용 테이블

-- 🎯 [테스트 1] vilf 및 cilf 연습 (함수 저격)
-- 커서를 아래 '여기' 단어 위에 두고 [ vilf ] 를 입력해 보세요.
-- 이전(Last)에 존재하는 함수 내부(@function.inner)인 'return a + b' 영역이 블록 지정됩니다.
function M.add_numbers(a, b)
  return a + b -- <- [여기]에 커서를 두고 vilf 실행!
end

-- 🎯 [테스트 2] vilo 및 cilo 연습 (조건문/루프 저격)
-- 커서를 아래 'print' 단어 위에 두고 [ vilo ] 를 입력해 보세요.
-- 이전(Last)에 존재하는 if 조건문 내부(@conditional.inner) 전체가 선택됩니다.
function M.check_status(status)
  if status == "success" then
    print("작업이 성공적으로 완료되었습니다!") -- <- [여기]에 커서를 두고 vilo 실행!
    local code = 200
  end
end

-- 🎯 [테스트 3] ciiB 또는 cii{ 대신 트리시터를 활용한 클래스 저격 (dalc / cilc)
-- 커서를 아래 'M.multiply' 함수 이름 위에 두고 [ vilc ] 를 입력해 보세요.
-- 현재 커서가 속한 거대한 구조인 'local M = { ... }' 테이블 전체의 알맹이가 잡힙니다.
function M.multiply(a, b)
  return a * b
end

-- 🎯 [테스트 4] 원격 다음(Next) 타깃 조작 연습 (ciif / diio)
-- 커서를 바로 아래 줄의 '---' 주석 위에 가만히 두고 [ ciif ] 를 입력해 보세요.
-- 커서를 이동하지 않고도 저 아래에 있는 'M.remote_function' 함수의 내부가 싹 비워집니다!
-- ---------------------------------------------------------------------
-- | <- 현재 커서 위치 (여기에 가만히 두고 ciif 입력)
-- ---------------------------------------------------------------------

function M.remote_function()
  local secret = "이 내용을 원격으로 지워보세요"
  print(secret)
end

return M
