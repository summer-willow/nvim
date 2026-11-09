

-- -----------------------------------------------
-- cf) lazyvim의 config 폴더 위치 (keymaps.lua, options.lua, autocmds.lua)
-- GitHub 주소: LazyVim/lua/lazyvim/config/keymaps.lua
-- c:\Users\stc\AppData\Local\nvim-lazy-data\lazy\LazyVim\lua\lazyvim\config\
-- Neovim 안에서 확인하는 가장 빠른 방법: :lua print(require("lazyvim.config.keymaps"))를 입력한 뒤 경로를 추적하거나, :verbose map <C-s>를 쳐서 어디서 정의되었는지 확인할 수 있습니다.




-- -----------------------------------------------
-- cursor movement
-- 기본 keybinding : 
-- 0 : 현재줄의  (공백도 포함해서) column=1 으로 이동
-- ^ : 현재줄의 공백 제외하고, 첫 문자로 이동
-- $ : 현재줄의 (공백도 포함해서) 맨 마지막으로 이동
-- g_ : 현재줄의 공백 제외하고, 마지막 문자로 이동
--
-- ==> 아래 keymapping은 일단 보류 !!!
-- 이미 다른 기능에 gl, gh 또는  A-l, A-h 가 이미 등록되어 있는지 
-- 살펴보고 사용할 것.
--
-- -- 1. gl / gh 방식 (추천: 기존 기능과 조화로움)
-- vim.keymap.set('n', 'gl', '$', { desc = '줄 끝으로 이동' })
-- vim.keymap.set('n', 'gh', '^', { desc = '줄 처음으로 이동' })
--
-- 또는 
--
-- -- 2. Alt 키 방식 (추천: 입력 모드에서도 편리함)
-- vim.keymap.set({'n', 'i'}, '<A-l>', '<End>', { desc = '줄 끝으로 이동' })
-- vim.keymap.set({'n', 'i'}, '<A-h>', '<Home>', { desc = '줄 처음으로 이동' })
-- -----------------------------------------------


















-- --------------------------------------------

-- increment/decrement numbers


-- 비주얼 모드에서 여러 숫자를 동시에 순차적으로 증가/감소
vim.keymap.set('v', '<leader>a', 'g<C-a>', {desc='Increment numbers in sequence'})
vim.keymap.set('v', '<leader>x', 'g<C-x>', {desc='Decrement numbers in sequence'})
-- {{{ 활용
-- * 단순 증가는 기본값 사용: <C-a>, <C-x>
-- 예: 1, 1, 1 선택 후 <C-a> → 2, 2, 2
--
-- * 순차적 번호 매기기
-- 예: 1, 1, 1 선택 후 g<C-a> → 2, 3, 4
--
-- 활용 사례 :  리스트의 번호를 순서대로 매길 때
-- 상황: 복사 붙여넣기로 번호가 꼬였을 때
-- 1. Apple
-- 1. Banana
-- 1. Cherry
-- 1. Dragonfruit
--
-- 단축키 <leader>a
--
-- 결과:
-- 2. Apple
-- 3. Banana
-- 4. Cherry
-- 5. Dragonfruit
--
-- 팁: 만약 1, 2, 3, 4로 만들고 싶다면, 
-- 숫자 부분만 비주얼 블록 모드(Ctrl + v,  or, Ctrl+q)로 수직 선택 후, 번호를 모두 0으로 바꾸고 (Ctrl+q --> j 이용 --> c(change) --> 0 --> <Esc>)(모두 0으로 만듦), 다시 선택해서 (gv) <leader>a 를 누른다
-- }}}






-- -----------------------------------------------
-- 예시: 새로운 단어 섹션을 만드는 단축키
-- 날짜와 템플릿을 자동으로 넣어주는 매크로
vim.keymap.set('n', '<leader>nw', function()
    -- YYYY-MM-DD 형식의 날짜 가져오기
    local date = os.date("%Y-%m-%d")
    
    -- 현재 커서 위치에 텍스트 삽입
    local lines = {
        "## " .. date,
        "- Word: ",
        "- Meaning: ",
        "- Example: ",
        ""
    }
    
    -- 현재 커서 아래에 줄 삽입
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_lines(0, row, row, false, lines)
    
    -- 입력하기 편하게 "Word: " 끝으로 커서 이동
    vim.api.nvim_win_set_cursor(0, {row + 2, 8})
    vim.cmd("startinsert!")
end, { desc = "새로운 단어장 템플릿 생성" })
-- -----------------------------------------------


-- ----------------------------------------
-- ---- ----
-- LSP에 의한 virtual text를 별도의 팝업창으로 표시
-- :lua vim.diagnostic.open_float()
-- 단축키 설정
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
-- cf) 메시지가 너무 길어, 창 아래로 넘어간다면,
-- 한 번 더 같은 단축키를 누르거나 명령어를 입력하여
-- 팝업창 안으로 커서를 이동시켜 j, k키 이용
--
--
-- 커서를 가져다 대기만 해도 잠시 후 전체 메시지가 뜨게 하기
-- -- 3. 자동으로 팝업 띄우기 (마우스/커서 호버)
-- -- 커서가 멈춰있을 때 자동으로 진단 메시지 팝업을 띄움
-- vim.api.nvim_create_autocmd('CursorHold', {
--   callback = function()
--     vim.diagnostic.open_float(nil, { focusable = false })
--   end,
-- })
-- -- ==> 화면이 너무 지지분해 짐. 잠시 사용 보류

--
-- cf) 4. 메시지를 별도 창(Trouble)에서 보기
-- 만약 프로젝트 전체의 에러 메시지를 한 눈에 보고 싶다면, Trouble.nvim 같은 플러그인을 추천합니다. 화면 하단에 목록 형태로 모든 메시지를 출력해 주며, 윈도우 환경에서도 텍스트 줄바꿈(wrap) 설정을 통해 잘림 없이 볼 수 있습니다.
-- ---- ----
-- ----------------------------------------

-- -----------------------------------------------

-- -----------------------------------------------

-- -----------------------------------------------

-- -----------------------------------------------

-- -----------------------------------------------



-- --------------------------------
-- mdodeline
-- vim: set foldmethod=marker foldmarker={{{,}}}:
