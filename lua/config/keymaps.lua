-- --------------------------------

-- --------------------------------
-- For conciseness
local keymap = vim.keymap -- for conciseness
local opts = { noremap = true, silent = true } -- For conciseness
-- cf) sntax: vim.keymap.set({mode}, {lhs}, {rhs}, {options})
-- cf) noremap=true is default in vim.keymap.set()
--  See `:help vim.keymap.set()`

-- --------------------------------
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- -- Clear search  -- from lazyvim
-- -- 검색 결과 하이라이트 끄기: 검색 후 화면에 계속 남는 highligh를 <Esc> 한 번으로 끕니다.
-- vim.keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and Clear hlsearch' })

-- --------------------------------
-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>qq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- --------------------------------

-- --------------------------------
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- --------------------------------
-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- --------------------------------
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
-- smart-split.nvim 설치로 아래 부분 주석처리
-- 아래 keymapping은 smart-splits.nvim에서 제공
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-- cf) 아래처럼, <C-w>h 로 정의해되 됨 (nvim은 <C-w>h 와 <C-w><C-h>를 모두 splited window 이동으로 작동
-- vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
-- cf) <C-w>H/J/k/l : splited window를 옮기는 keymapping

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })
-- ===> 윈도우11, powershell에서는 <C-S-h/j/k> 가 이미 다른 기능으로 설정되어 있음.

-- --------------------------------

-- --------------------------------
-- 창(window) 분활 (split, vsplit, only)
-- local keymap = vim.keymap.set

-- 창 분할하기 (현재 커서 창 기준)
-- vim.keymap.set("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
-- vim.keymap.set("n", "<leader>-", "<cmd>split<CR>", { desc = "Split window horizontally" })
vim.keymap.set('n', '<leader>sl', '<cmd>vsplit<CR>', { desc = 'Split window right' })
vim.keymap.set('n', '<leader>sj', '<cmd>split<CR>', { desc = 'Split window down' })

-- 현재 창만 남기고 나머지 모두 닫기 (:only)
-- vim.keymap.set("n", "<leader>qo", "<cmd>only<CR>", { desc = "Close all other windows" })
vim.keymap.set('n', '<leader>so', '<cmd>only<CR>', { desc = 'Maximize current window (only)' })

-- 현재 활성화된 창 하나만 닫기 (:close), split 등으로 창을 나눴을 때 유용
-- :q 로 해도 되나, 편하게 단축키로 지정
-- vim.keymap.set("n", "<leader>qc", "<cmd>close<CR>", { desc = "Close current window" })
vim.keymap.set('n', '<leader>sx', '<cmd>close<CR>', { desc = 'Close current window' })
-- -----------------------------------------------

-- -----------------------------------------------
-- buffer 관련
-- 버퍼 닫기 단축키 (현재 버퍼 닫기, 메모리에서 삭제)
-- vim.keymap.set("n", "<leader>bx", "<cmd>bdelete<CR>", { desc = "Close Buffer" })
-- ==> 단순히 :bdelete 만으로 버퍼를 지우면, 빈 껍데기 남는 현장 때문에,
-- auto-sesseion 플러그인에 이 빈껍데기를 불러오려는 과정에서 에러가 발생.
-- 그래서, 대신 <leader>bx 를 bufferline.nvim에서 제공하는 버퍼 지우는 기능으로 대체.

-- 현재 버퍼만 남기고, 다른 모든 버퍼 닫기
-- [B]uffer [C]leanup
vim.keymap.set("n", "<leader>bc", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close all other buffers" })

-- -----------------------------------------------

-- -----------------------------------------------


-- -----------------------------------------------

-- -----------------------------------------------

-- -----------------------------------------------
-- 창 크기 조절(Resize)
---- Resize splited window with arrows
-- Control + 화살표 키를 이용해 현재 창의 크기를 부드럽게 조절
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- 창 크기를 모두 똑같이 정렬 (등분하기)
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equalize window sizes" })
-- -----------------------------------------------



--


-- --------------------------------
-- keymap.set({ 'n', 'v', 'i' }, 'jk', '<ESC>', { desc = 'Exit insert mode with jk' })
-- i 모드(입력)에서만 작동하도록 설정 : n과 v 모드를 제외하면 j 키를 누를 때 딜레이가 사라져 쾌적해짐
-- vim.keymap.set('i', 'jk', '<ESC>', { desc = 'Exit insert mode with jk' })

-- --------------------------------
-- --------------------------------
-- save & quit
-- vim.keymap.set('n', ',s', '<cmd>update<CR>', { desc = 'save/update current file' })
-- vim.keymap.set('n', ',e', '<cmd>q<CR>', { desc = 'quit current window' })
-- vim.keymap.set('n', '<leader>s', '<cmd>update<CR>', { desc = 'save/update current file' })
-- vim.keymap.set('n', '<leader>e', '<cmd>q<CR>', { desc = 'quit current window' })
-- vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
-- vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save" })

-- vim.keymap.set('n', "'s", '<cmd>update<CR>', { desc = 'save/update current file' })
-- vim.keymap.set('n', "'e", '<cmd>q<CR>', { desc = 'quit current window' })
-- 원래 's에서 {'}는 mark 사용할 때 사용됨(ex, {m -> a}로 마크a 지정, 그리고 그 마크a로 이동할 때 'a를 사용)

-- <leaer>ls/le ==> very convenient !!!
vim.keymap.set('n', "<leader>ls", '<cmd>update<CR>', { desc = 'save/update current file' })
vim.keymap.set('n', "<leader>le", '<cmd>q<CR>', { desc = 'quit current window' })

-- just so so !!
-- vim.keymap.set('n', "<leader>ww", '<cmd>update<CR>', { desc = 'save/update current file' })
-- vim.keymap.set('n', "<leader>we", '<cmd>q<CR>', { desc = 'quit current window' })

-- not good
-- vim.keymap.set('n', "<leader>,s", '<cmd>update<CR>', { desc = 'save/update current file' })
-- vim.keymap.set('n', "<leader>,e", '<cmd>q<CR>', { desc = 'quit current window' })




vim.keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' }) -- save file	-- from lazyvim
-- x : Visual 모드, 정확히는 "Pure Visual" 모드. 마우스나 키보드로 텍스트 블록을 선택하고 있는 상태를 의미
-- s : Select 모드, 선택된 상태에서 글자를 치면 선택 영역이 지워지면서 새 글자가 입력되는 모드 (주로 Snippet 사용 시 다음 입력 칸으로 넘어갔을 때 이 모드가 됨).

-- --------------------------------
-- -- better indenting 	-- from lazyvim
-- '<', '>'를 이용한 인덴트(들여쓰기) 조정 후 선택 유지: 원래 >를 누르면 선택이 풀리는데, 이건 선택 상태를 유지해줘서 연속으로 조정 가능
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- --------------------------------

-- --------------------------------
-- visual selection block 전체를 이동시키기
-- ===> 이미 LazyVim에서 제공: <A-j>, <A-k>
--
-- 1. Normal Mode: Alt+j/k로 현재 줄 이동
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
-- {{{ :m .+1<CR>== & :m .-2<CR>==n 의미
--
-- 1. :m .+1<CR>== (아래로 한 줄 이동) 분석
-- :m { target(위치) } : 현재 줄을 {위치}의 아래로 보내라.
-- 만약 현재 5번 줄에 있다면, :m 6은 "5번 줄을 6번 줄 아래로 보내라"가 되어 결과적으로 5번 줄이 6번 줄이 됩니다. 즉, 한 칸 내려가는 것.
-- . (점): 현재 커서가 있는 줄 번호를 의미
-- +1: 현재 줄 번호에 1을 더한 상대 위치, 즉 다음 줄을 의미
-- <CR>: Enter 키. 명령어를 실행
-- ==: 이동한 직후에 현재 줄의 들여쓰기를 자동 교정
--
-- 2. :m .-2<CR>== (위로 한 줄 이동) 분석
-- .-2: 현재 줄(.)에서 위로 두 번째 줄을 의미합니다.
-- :move 의 작동 원리 --> :m {target}은 "현재 줄을 {target} 줄의 '바로 아래'로 이동"시킵니다.
-- 따라서, :m .-2 는 "내 윗윗줄의 아래(즉, 내 윗줄의 위)"로 이동하라는 의미가 됨
-- }}}

-- 2. Insert Mode: Alt+j/k로 현재 줄 이동 (입력 중에도 가능)
-- <Esc>로 나갔다가 이동 후 다시 'gi'로 마지막 입력 위치로 돌아옴
vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { desc = 'Move line down' })
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { desc = 'Move line up' })
-- {{{ <Esc>:m .+1<CR>==gi & <Esc>:m .-2<CR>==gi 의미
-- <Esc>:m .+1<CR>==gi & <Esc>:m .-2<CR>==gi 의미
--
-- 1. <Esc>:m .+1<CR>==gi 분석
--
-- <Esc>: go to Normal Mode (명령어 :m는 노멀 모드에서 동작)
-- :m .+1<CR>: 현재 줄을 한 칸 아래로 옮김
-- ==: 이동한 줄의 들여쓰기를 정렬
-- gi: 가장 마지막에 편집(Insert)했던 위치로 돌아가면서 다시 Insert Mode로 진입하라는 명령
--
-- 2. <Esc>:m .-2<CR>==gi (위로 한 줄 이동하고 다시 insert mode로 진입)
--
-- cf) 자주 쓰이는 g 시리즈
-- gg --> Go to top : 문서의 맨 첫 줄로 이동
-- gj / gk --> Go visual line : (긴 문장이 줄바꿈 됐을 때) 화면에 보이는 대로 한 줄씩 이동
-- gd --> Go to Definition : 코딩 중 변수가 정의된 곳으로 이동. (LSP 연동 시 필수)
-- gu / gU --> get uppercase : 선택한 글자를 소문자(u) 또는 대문자(U)로 바꿈.
-- gv --> give back visual : 마지막에 선택했던 블록(Visual Selection)을 다시 선택
-- }}}

-- 3. Visual Mode: Alt+j/k로 선택 영역 이동
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
-- {{{ :m '>+1<CR>gv=gv & :m '<-2<CR>gv=gv 의미
--:m '>+1<CR>gv=gv & :m '<-2<CR>gv=gv 의미
--
-- 1. :m '>+1<CR>gv=gv (블록을 아래로 이동) 분석
--
-- 이 명령어는 **"선택 영역을 통째로 떼어서 다음 줄 아래에 붙여넣고 다시 선택하라"**는 뜻입니다.
-- '>: 비주얼 모드에서 선택한 영역의 마지막 줄을 의미하는 특수 기호
-- '>,Selection End,선택 영역의 끝 지점
-- +1: 그 마지막 줄의 다음 줄(1줄 아래)을 의미
-- :m '>+1: 결국 "선택된 블록을 블록 끝부분 바로 다음 줄 위치로 옮겨라"라는 명령
-- <CR>: 엔터! 실행
-- gv: Give back visual , "방금 선택했던 영역을 다시 선택(Reselect)하라"는 명령. (줄을 옮기고 나면 선택 영역이 해제되기 때문에)
-- =: 선택된 블록의 들여쓰기를 정렬 (Indent)
-- gv: 정렬 후 다시 블록 선택 상태를 유지합니다.
-- (덕분에 연속해서 Alt+j를 눌러 계속 내릴 수 있습니다.)
--
-- 2. :m '<-2<CR>gv=gv (블록을 위로 이동) 분석
--
-- '<: 비주얼 모드에서 선택한 영역의 첫 번째 줄을 의미하는 특수 기호
-- '<,Selection Start,선택 영역의 시작 지점
-- .-2: 현재 줄(.)에서 위로 두 번째 줄을 의미합니다.
-- -2: "(비쥬얼 선택 영역의 첫 번째 줄의) 윗윗줄"을 의미
-- :m '<-2: "내가 선택한 블록 전체를 현재 블록의 첫 줄보다 두 칸 위(즉, 윗줄의 위)로 옮겨라"라는 뜻
-- }}}

-- visual mode 진입 시 (Shift + v), Shift key 연속사용을 위해
-- 다음 keymappint도 설정
-- 한 줄의 visual block 을 이동시킬 때 유용.
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'moves lines down in visual selection' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'moves lines up in visual selection' })
--

-- --------------------------------
-- --------------------------------
-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', { noremap = true, silent = true, desc = 'Toggle Soft Wrap' })
-- --------------------------------

-- Move the cursor up and down by display line
-- 화면 줄 기준으로 위아래 이동
vim.keymap.set({ 'n', 'v' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, noremap = true, silent = true, desc = 'Move down by display line' })
vim.keymap.set({ 'n', 'v' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, noremap = true, silent = true, desc = 'Move up by dispay line' })
-- {{{
-- 화면상에 보이는 대로 줄 이동을 하되, 숫자를 입력했을 때는 실제 줄 번호만큼 이동
-- j,k  : 실제 줄(Logical Line) 단위로 이동
-- gj, gk : 화면에 보이는 줄(Display Line) 단위로 이동
--
-- ex) 5j라고 입력했을 때 사용자의 의도는 보통 "실제 코드 5줄 아래로 가고 싶다"는 것입니다. 하지만 j가 무조건 gj로 매핑되어 있으면, 화면상에서만 5줄 아래로 가게 되어 사용자의 의도와 다른 이동으로 동작
--
-- v:count==0 ? 'gj' : 'j'  ==> 삼항 연산자 조건문 (Condition ? True : False)
-- v:count : 명령어 앞에 붙이는 숫자
-- v:count==0 : "사용자가 이동할 줄 수를 숫자로 입력하지 않았다"는 뜻
-- ? 'gj': (참일 때) 숫자를 입력 안 했다면, 화면상 아래 줄 (display line) (gj)로 이동
-- : 'j': (거짓일 때) 숫자를 입력했다면(예: 5j), 원래 j의 동작인 실제 줄 (logical line) 단위로 이동
-- cf) sntax: vim.keymap.set({mode}, {lhs}, {rhs}, {options})
-- expr=true  : "{rhs}을 그대로 실행하지 말고, 하나의 '식'으로 평가해서 그 결과값을 실행하라"는 옵션, rhs = right-hand side
-- 즉, "v:count == 0 ? 'gj' : 'j'" 에서 v:count==0 를 실행하고, 그 결과를 실행
-- }}}
-- {{{ 옵션 expr=true 의 활용 예시
-- 왜 expr=true 가 필요한가요? (핵심 요약)
-- 단순 매핑은 정적(Static)입니다. 누르면 항상 똑같은 일을 하죠. 하지만 expr = true를 사용하면 동적(Dynamic)인 매핑이 가능해집니다.
-- 즉, 에디터의 상태(현재 줄 번호, 입력된 숫자, 커서 위치 등)에 따라, 서로 다른 키가 눌린 것처럼 동작하게 만들고 싶을 때 사용합니다.
--
-- ex) 예시 A: 시간을 입력하는 매핑
-- --------------------------------------
-- 현재 시간을 입력하는 매핑 (Lua의 os.date 함수 사용)
-- vim.keymap.set('i', '<F5>', "os.date('%H:%M')", { expr = true })
--
-- 사용자가 삽입 모드에서 <F5>를 누릅니다.
-- Neovim은 expr = true를 보고 "아, os.date('%H:%M')를 먼저 계산해야겠군!" 하고 실행합니다.
-- 계산 결과가 "14:30"이라는 문자열로 나옵니다.
-- Neovim은 최종적으로 14:30을 타이핑합니다.
--
-- --------------------------------------
-- 예시 1. 자동완성 팝업 제어 (엔터 키의 변신)
--
-- 가장 많이 쓰이는 사례입니다. 보통 자동완성 목록이 뜨면 Tab이나 방향키로 선택하고 Enter를 눌러 확정하죠. 하지만 팝업이 없을 때 Enter는 그냥 줄바꿈 역할을 해야 합니다.
--
-- ```Lua
--
-- -- nvim-cmp 같은 플러그인 없이 기본 기능을 쓸 때의 예시
-- vim.keymap.set('i', '<CR>', [[pumvisible() ? "\<C-y>" : "\<CR>"]], { expr = true })
-- ```
--
-- pumvisible(): "Pop-Up Menu가 화면에 보이는가?"를 체크하는 함수입니다.
--
-- 상황 A (팝업이 떠 있음): Enter를 누르면 "\<C-y>"(자동완성 확정 키)가 실행됩니다.
--
-- 상황 B (팝업이 없음): Enter를 누르면 원래 기능인 "\<CR>"(줄바꿈)이 실행됩니다.
--
-- 결과: 엔터 키 하나가 상황에 따라 확정 버튼이 되기도 하고 줄바꿈 버튼이 되기도 합니다.
--

-- --------------------------------------
-- 2. 스마트 Tab 키 (들여쓰기 vs 자동완성)
-- Tab 키를 눌렀을 때, 앞에 글자가 있으면 자동완성을 띄우고, 아무것도 없으면 그냥 들여쓰기(Tab)를 하고 싶을 때 사용합니다.
--
-- ```Lua
--
-- vim.keymap.set('i', '<Tab>', function()
--   if vim.fn.pumvisible() == 1 then
--     return "\<C-n>" -- 팝업이 있으면 다음 항목으로 이동
--   elseif vim.fn.col('.') <= 1 or vim.fn.getline('.'):sub(vim.fn.col('.')-1, vim.fn.col('-1')):match('%s') then
--     return "\<Tab>" -- 커서 앞이 빈칸이면 그냥 Tab 입력
--   else
--     return "\<C-x>\<C-o>" -- 그 외엔 자동완성 메뉴 호출
--   end
-- end, { expr = true })
-- ```
--
-- 이처럼 expr = true는 단순한 한 줄 코드뿐만 아니라, 복잡한 Lua 함수를 실행해서 그 결과값을 반환할 수도 있습니다.
--
-- 핵심: 사용자는 Tab 하나만 누르지만, 에디터는 "주변 상황"을 다 계산해서 최적의 동작을 골라줍니다.
--
-- --------------------------------------
-- 3. 빈 줄에 대고 i를 누를 때 들여쓰기 자동 수정
-- Vim에서 빈 줄에서 i를 눌러 입력을 시작하면 들여쓰기가 안 잡힐 때가 있습니다. 이때 i가 똑똑하게 동작하게 만들 수 있습니다.
--
-- ```Lua
--
-- vim.keymap.set('n', 'i', function()
--   if #vim.fn.getline('.') == 0 then
--     return '"_cc' -- 줄이 비어있으면 들여쓰기를 맞추면서(cc) 입력 모드 진입
--   else
--     return 'i'    -- 내용이 있으면 그냥 평범하게 i
--   end
-- end, { expr = true })
-- ```
-- 작동 원리: 빈 줄에서 i를 누르면, Neovim은 현재 줄의 길이를 재고(getline), 0이라면 cc(기존 들여쓰기를 유지하며 수정) 기능을 실행하여 커서를 예쁜 위치에 갖다 놓습니다.
--

-- --------------------------------------
-- 왜 expr = true가 강력한가요? (요약)
--
-- - 사용자의 의도를 읽음: j를 눌렀을 때 이게 "한 줄 아래"인지 "5줄 아래"인지 구별합니다.
-- - UI 상태에 반응함: 자동완성 창이 떴는지 안 떴는지에 따라 키의 역할을 바꿉니다.
-- - 코드의 문맥을 파악함: 커서 앞이 공백인지 글자인지에 따라 다른 키를 입력합니다.
--
-- 💡 한 줄 정리: expr = true는 Neovim에게 **"행동하기 전에 상황 파악부터 해!"**라고 명령하는 장치입니다.
-- --------------------------------------
-- }}}
--
-- ********************************
-- 설정 파일 (config file/folder) 관련
-- ********************************

-- --------------------------------
-- init.lua (_vimrc) 파일 열기
-- :e $vimrc
-- $MYVIMRC(현재 설정파일)를 편집(edit) 모드로 여는 약어 설정
-- vim.cmd 'cabbrev vi $MYVIMRC' -- :e vi 이용
-- cf) cabbrev에 해당하는 전용 Lua 함수는 없음.
-- ==> 주의: Neovim에는 이미 :vi가 내장(built-in) 명령어로 있음.
-- :vi	:visual	비주얼 모드 진입, (무시 가능 수준)
-- :vi는 Neovim에서 :visual 명령어의 줄임말로 이미 등록되어 있습니다.
-- :vi	:visual	비주얼 모드 진입, (무시 가능 수준)
-- 기능: 현재 파일을 Visual 모드(일반적인 에디터 모드)로 엽니다. (과거 ex 모드에서 일반 에디터로 돌아올 때 쓰던 유산입니다.)
-- 충돌 문제: 만약 cabbrev vi edit $MYVIMRC를 설정하면, 원래의 :visual 기능을 사용하지 못하게 됩니다. 하지만 현대적인 Neovim 사용자가 :visual 커맨드를 직접 입력할 일은 거의 없으므로, 덮어쓰고 사용해도 실질적인 문제는 없습니다.

-- --------------------------------

-- --------------------------------

-- -----------------------------------
-- 설정 폴더(config)를 neo-tree로 열기
-- neo-tree.nvim 이용
--
-- cf) :e $myvimrc  : open init.lua
-- :e vim.fn.stdpath('config')
--
vim.keymap.set('n', '<leader>fc', function()
  -- Neovim의 표준 설정 경로(Windows는 AppData/Local/nvim)를 가져옵니다.
  local config_path = vim.fn.stdpath 'config'

  -- reveal: neo-tree를 해당 경로로 열기 (reveal 옵션으로 해당 폴더를 트리 최상단으로)
  -- dir=...: Neovim 전체의 cd를 바꾸지 않고, 탐색기 창의 '기준점'만 설정 폴더로 고정합니다.
  vim.cmd('Neotree reveal dir=' .. config_path)
end, { desc = 'Neo-tree: [F]ind [C]onfig files' })

-- -----------------------------------
--
-- Neovim의 명령줄(Command-line)에서 명령줄 완성 키바인딩
--
-- Neovim 자체의 기본 내장 탭 완성 창(wildmenu)을 사용 중이라면 (플러그인 없이 Neovim 순정 기능을 사용중이라면), 단순 전역 키 매핑으로 해결할 수 있습니다.
-- 명령줄 모드(c)에서 작동하도록 vim.keymap.set을 설정합니다. wildmenu가 켜져 있을 때만 매핑이 돌도록 하려면 내장 함수 wildmenumode()를 체크해야 합니다.

-- Ctrl + j : 목록이 열려있으면 아래(다음)로, 아니면 기본 동작
vim.keymap.set('c', '<C-j>', function()
  return vim.fn.wildmenumode() == 1 and '<C-n>' or '<C-j>'
end, { expr = true, desc = "명령줄 다음 후보 이동" })

-- Ctrl + k : 목록이 열려있으면 위(이전)로, 아니면 기본 동작
vim.keymap.set('c', '<C-k>', function()
  return vim.fn.wildmenumode() == 1 and '<C-p>' or '<C-k>'
end, { expr = true, desc = "명령줄 이전 후보 이동" })

-- Ctrl + y : 현재 선택된 후보로 확정 (wildmenu에서는 <Space>나 다른 키로 확정 효과를 냅니다)
-- vim.keymap.set('c', '<C-y>', function()
--   return vim.fn.wildmenumode() == 1 and '<C-y>' or '<C-y>'
-- end, { expr = true, desc = "명령줄 후보 확정" })

-- 엔터(<CR>)는 내장 wildmenu에서 자동으로 선택 및 실행되므로 별도 매핑이 필요 없습니다.



-- ---------------------------------------
-- folding 방법(foldmethod) 바꾸기 
--
-- 현재 파일을 '마커 방식'으로 전환하고 모두 접기 (개인 주석 읽기 모드)
vim.keymap.set('n', '<leader>fm', function()  -- fold by marker
  vim.opt_local.foldmethod = 'marker'
  vim.opt_local.foldmarker = '{{{,}}}'
  vim.opt_local.foldlevel = 0
end, { desc = "Fold by Marker, 주석 마커 폴딩 모드 켜기" })

-- 다시 원래 Treesitter 폴딩 모드로 돌아가기
vim.keymap.set('n', '<leader>ft', function()    -- fold by treesitter
  vim.opt_local.foldmethod = 'expr'
  vim.opt_local.foldlevel = 99
end, { desc = "Fold by Treesitter, 트리시터 폴딩 모드 복구" })
-- ---------------------------------------


-- ---------------------------------------
-- compile 관련
--
-- latex compile
-- ':!pdflatex %' or ':sileent !pdflatex %' 를 등록
vim.keymap.set('n', '<leader>cn', ':!pdflatex %<CR>:redraw!<CR>', { silent = true, desc = "compile (in normal)" })
vim.keymap.set('n', '<leader>cs', ':silent !pdflatex %<CR>:redraw!<CR>', { silent = true, desc = "compile (in silent)" })

-- 비동기 방식을 단축키 <leader>fb (File Background)에 할당
-- :call jobstart(['pdflatex', expand('%')])
vim.keymap.set('n', '<leader>cb', function()
  vim.fn.jobstart({'pdflatex', vim.fn.expand('%')})
end, { silent = true, desc = "latex compiling in background(asyn) mode" })

-- ---------------------------------------
-- Latex의 inverse sync를 위한 서버 설정
-- ---------------------------------------

-- 단축키 조합 형태
-- vim.keymap.set('n', '<leader>ts', ":call serverstart('localhost:12345')<CR>", {desc = "start local server"} )
vim.keymap.set('n', '<leader>ts', "<cmd>call serverstart('localhost:12345')<CR>", {desc = "start local server"} )

-- ----------------
-- 명령행 형태: lsv , lsvoff

-- 전역 변수로 서버 작동 여부 추적
-- lsv = local server
_G.is_lsv_server_running = false

-- 1. 개별 명령어: 서버 켜기 (:Lsv)
-- :lsv 명령어를 입력하면 로컬 서버가 개설되는 설정
vim.api.nvim_create_user_command('Lsv', function()
  if _G.is_lsv_server_running then
    vim.notify("이미 서버가 실행 중입니다.", vim.log.levels.WARN)
  else
    vim.fn.serverstart('localhost:12345')
    _G.is_lsv_server_running = true
    vim.notify("Neovim 서버가 개설되었습니다. (localhost:12345)", vim.log.levels.INFO)
  end
end, { desc = "Start local server for VimTeX" })
vim.cmd [[cabbrev lsv Lsv]] -- :lsv 이용

-- 2. 개별 명령어: 서버 끄기 (:LsvOff)
vim.api.nvim_create_user_command('LsvOff', function()
  if not _G.is_lsv_server_running then
    vim.notify("실행 중인 서버가 없습니다.", vim.log.levels.WARN)
  else
    vim.fn.serverstop('localhost:12345')
    _G.is_lsv_server_running = false
    vim.notify("Neovim 서버가 안전하게 종료되었습니다.", vim.log.levels.INFO)
  end
end, { desc = "Stop local server" })
vim.cmd [[cabbrev lsvoff LsvOff]] -- :lsvoff 이용

-- 3. 통합 명령어: 토글 방식 (:LsvToggle)
vim.api.nvim_create_user_command('LsvToggle', function()
  if _G.is_lsv_server_running then
    vim.cmd('LsvOff')
  else
    vim.cmd('Lsv')
  end
end, { desc = "Toggle local server ON/OFF" })
vim.cmd [[cabbrev lsvt LsvToggle]] -- :lsvt 이용


-- ---------------------------------------



-- ---------------------------------------


-- ---------------------------------------



-- ---------------------------------------











-- ---------------------------------------



-- ---------------------------------------



-- ---------------------------------------



-- ---------------------------------------



-- ---------------------------------------



-- ---------------------------------------



-- ---------------------------------------



-- ---------------------------------------



-- ---------------------------------------












-- --------------------------------
-- mdodeline
-- vim: set foldmethod=marker foldmarker={{{,}}}:
