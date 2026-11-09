--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================
--]]
--
-- ~/AppData/Local/nvim
-- ├── lua
-- │   └── tcshin
-- │       ├── config
-- │       │   └── lazy.lua
-- │       └── plugins
-- │           ├── spec1.lua
-- │           ├── **
-- │           └── spec2.lua
-- └── init.lua
--



-- # Information
-- modularization
--
-- For Lua language, see
-- https://learnxinyminutes.com/docs/lua/
-- :help lua-guide
-- (or HTML version): https://neovim.io/doc/user/lua-guide.html
--
-- :Tutor
-- :help
-- a keymap: <leader>sh   ==> to search the help-doc.
--



-- ----------------------------------------

-- ----------
-- Splitted window management
-- keymap.set('n', 'sh', '<C-w>h', vim.tbl_extend('force', opts, {desc = 'Go to left window' })) -- Go to the left window
keymap.set('n', 'sh', '<C-w>h', { noremap = true, silent = true, desc = 'Go to left window' }) -- Go to the left window
keymap.set('n', 'sl', '<C-w>l', { noremap = true, silent = true, desc = 'Go to right window' }) -- Go to the right window
keymap.set('n', 'sj', '<C-w>j', { noremap = true, silent = true, desc = 'Go to below window' }) -- Go to the below window
keymap.set('n', 'sk', '<C-w>k', { noremap = true, silent = true, desc = 'Go to upper window' }) -- Go to ghe upper windows

-- Splitting window
keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Split window vertically' }) -- split window vertically
keymap.set('n', '<leader>sh', '<C-w>s', { desc = 'Split window horizontally' }) -- split window horizontally
keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Make splits equal size' }) -- make split windows equal width & height
keymap.set('n', '<leader>sx', '<cmd>close<CR>', { desc = 'Close current split' }) -- close current split window
keymap.set('n', '<leader>so', '<cmd>only<CR>', { desc = 'Only current window' }) -- only current window will be shown. 이미 Nvim의 기본 단축키인(built-in) Ctrl+W + o에 할당되어 있음. 따라서 별도로 키 바인딩을 설정할 필요가 없습니다. Nvim을 설치한 후 바로 사용할 수 있습니다. 구지 위의 단축키, <leader>so,를 정의해서 쓰지 않아도 된다. 여기서는 split window에 대한 key binding을 한 곳에 모아서 관리하고자, 그냥 key binding 한 것이디.

-- Resize split window with arrows
keymap.set('n', '<C-Up>', ':resize +2<CR>', { noremap = true, silent = true, desc = 'size up vertically' })
keymap.set('n', '<C-Down>', ':resize -2<CR>', { noremap = true, silent = true, desc = 'size down vertically' })
keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true, desc = 'size down horizontally' })
keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true, desc = 'size up horizontally' })

-- tap management
keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', { desc = 'Open new tab' }) -- open new tab
-- cf) 위에서 정의한 opts와 새로 작성할 desc=',,,'를 합치기
-- vim.tbl_extend("force", A, B)는 A 테이블에 B 테이블의 내용을 합쳐서 새로운 테이블을 반환
-- 'force'는 중복 키가 있을 때 뒤의 값을 우선한다는 뜻입니다.
-- keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', vim.tbl_extend('force', opts, { desc = 'Open new tab' })) -- open new tab
-- vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'New Tab' }) -- 새로운 탭 열기
--
keymap.set('n', '<leader>tx', '<cmd>tabclose<CR>', { desc = 'Close current tab' }) -- close current tab
-- vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = 'Close Tab' }) -- 현재 탭 닫기
--
keymap.set('n', '<leader>tn', '<cmd>tabn<CR>', { desc = 'Go to next tab' }) --  go to next tab
-- vim.keymap.set('n', 'gt', '<cmd>tabnext<CR>', { desc = 'Next Tab' }) ---- 다음 탭으로 이동 (기본 설정)
--
keymap.set('n', '<leader>tp', '<cmd>tabp<CR>', { desc = 'Go to previous tab' }) --  go to previous tab
-- vim.keymap.set('n', 'gT', '<cmd>tabprevious<CR>', { desc = 'Previous Tab' }) -- 이전 탭으로 이동 (기본 설정)
--
keymap.set('n', '<leader>tf', '<cmd>tabnew %<CR>', { desc = 'Open current buffer in new tab' }) --  move current buffer to new tab
-- vim.keymap.set('n', '<leader>ty', ':tabonly<CR>', { desc = 'Only Current Tab' }) -- 현재 탭만 남기고 모두 닫기

-- buffer management
keymap.set('n', '<leader>bn', ':bnext<CR>', { desc = 'Next Buffer' }) -- 다음 버퍼로 이동
keymap.set('n', '<leader>bp', ':bprev<CR>', { desc = 'Previous Buffer' }) -- 이전 버퍼로 이동
keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete Buffer' }) -- 현재 버퍼 닫기
keymap.set('n', '<leader>bl', ':ls<CR>', { desc = 'List Buffers' }) -- 현재 버퍼 목록 보기 (버퍼 번호, 이름 등을 확인)


-- -- Buffer navigation
-- -- Normal 모드: Ctrl-h → 이전 버퍼(순환), Ctrl-l → 다음 버퍼(순환)
-- -- keymap.set("n", "<leader>bn", "<cmd>:bnext!<CR>", opts,  { desc = "go to next buffer" })
-- -- keymap.set("n", "<leader>bp", "<cmd>:bprevious!<CR>", opts,  { desc = "go to previous buffer" })
-- keymap.set("n", "<C-l>", ":bnext!<CR>", opts, { desc = "go to next buffer" })
-- keymap.set("n", "<C-h>", ":bprevious!<CR>", opts, { desc = "go to previous buffer" })
--
--
-- " move vertically by visual line
-- j와 k를 화면상 줄(wrapped line) 단위로 이동하도록 매핑
-- (Wrapped lines: 줄 바꿈이 된 긴 줄을 쉽게 탐색)
--
-- -- 일반 모드 (Normal mode)
-- keymap.set('n', 'j', 'gj', { noremap = true, silent = true, desc = "Move down by display line (Normal mode)" })
-- keymap.set('n', 'k', 'gk', { noremap = true, silent = true, desc = "Move up by display line (Normal mode)" })
-- --
-- -- 비주얼 모드 (Visual mode)
-- keymap.set('v', 'j', 'gj', { noremap = true, silent = true, desc = "Move down by display line (Visual mode)" })
-- keymap.set('v', 'k', 'gk', { noremap = true, silent = true, desc = "Move up by display line (Visual mode)" })
--
-- -- Toggle line wrapping
-- keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts, { desc= 'toggle line wrapping' })

--
--

--
--
-- vim.cmd("echo '👉👉👉👉 nvim-jo2222 : keymaps.lua, Ok!!!'")
-- --------------------------------------------

--

-- --------------------------------------------
--
-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- ---------------------------
-- stc-here, 2026-01-19, 12:30
--
-- {{{
-- 한눈에 비교하는 표
-- ---------------------------
-- vim.g : 전역 변수 : 리더 키 설정, 플러그인 옵션 제어
-- vim.o : 기본 옵션 : 일반적인 option 설정, 기존 vim의 set 과 가장 유사
-- vim.wo : window-scoped option
-- vim.bo : buffer-scoped option
-- vim.opt : 옵션 객체 (option objects : 복잡한 설정 및 리스트 조작
-- 	-  Lua 전용 옵션 객체
-- 	- 용도: vim.o보다 더 똑똑하고 강력하게 옵션을 다룸
-- 	- 특징: 단순 대입뿐만 아니라, 리스트에 값을 추가(:append)하거나 제거(:remove)하는 등의 Lua 함수형 조작이 가능
-- 	- ex)
-- 	- vim.opt.number = true          -- (vim.o와 동일하게 작동)
-- 	- vim.opt.relativenumber = true  -- 상대 줄 번호 표시
-- 	- -- 리스트 형태의 옵션을 다룰 때 매우 강력함
-- 	- vim.opt.formatoptions:append("j") -- 기존 설정에 'j' 옵션 추가
-- 	- vim.opt.wildignore:remove("*.obj") -- 목록에서 특정 패턴 제거
--
-- ----------------
-- * 실전에서는 무엇을 써야 할까요?
-- - 리더 키나 플러그인 옵션을 정할 때는 무조건 **vim.g**를 씁니다.
-- - 일반적인 에디터 설정(number, tabstop 등)을 할 때는 **vim.opt**를 사용하세요.
-- cf) **vim.opt**는 똑똑해서 알아서 전역(Global), 창(Window), 버퍼(Buffer) 범위를 판단해 적용해 줍니다. 그래서 초보자나 중급자 모두 vim.opt 하나로 통일해서 사용하는 것이 정신 건강에 가장 좋습니다!
--

-- -----------------------------------------------

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- {{{
-- 현재 파일에서 발견된 모든 진단(Diagnostic, 에러/경고/정보) 내용을 (setloclist에 의해) Location List에 담아 화면 하단에 목록 창으로 보여줌 (Quickfix 창이 아님)
-- 추가 팁: 만약 리스트를 띄우지 않고, 그냥 다음 에러 지점으로 바로 점프하고 싶다면
-- [ + d: 이전 에러로 점프
-- ] + d: 다음 에러로 점프
-- cf) diagnostics 관련 keymapping
-- <leader>d : show Diagnostics in floating windown
-- <leader>sd : search Diagnositc (in Telescope)
-- }}}

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- {{{
-- 내장 터미널 모드에서 쉽게 빠져나오기
-- 원래는 <Ctrl + \> <Ctrl + n> ----> <Esc><Esc>
--
-- :term --> nvim에서 파일 편집 중에 terminal 모드로 들어가기
-- 't' (Terminal 모드): 터미널 모드란 Neovim 안에서 :term 명령어로 쉘을 실행하고 글자를 입력 중인 상태를 의미
--
-- terminal 모드에서 작업을 마치고 다시 편집 중인 파일로 돌아가기
--
-- <C-\\><C-n>: 터미널 모드에서 Normal 모드로 전환하는 Neovim의 기본 내장 명령, (이걸 눌러야 터미널 안에서 normal 모드로 전환되어 j, k로 위아래를 훑거나 창을 닫을 수 (:q) 있습니다.) (아직 터미널 안)
-- 원래는 <Ctrl + \> <Ctrl + n> ----> <Esc><Esc>
--
-- 터미널 창 닫기: 터미널에서 작업을 마치고 창을 완전히 없애고 싶다면: <Esc><Esc>를 눌러 Normal 모드로 나온 후, :q를 입력하거나, 창 닫기 단축키를 누르면 터미널 창이 사라집니다.
--
-- ---- ----
-- :q를 눌르면, 이전 편집중인 파일로 돌아가지 않고, nvim이 꺼지는 이유 :
--
-- 그 현상은 현재 Neovim에 창(Window)이 하나만 열려 있기 때문입니다.
-- Vim/Neovim에서 :q는 '현재 창을 닫아라'라는 명령인데, 마지막 남은 창을 닫으면 프로그램 자체가 종료되는 것이 기본 동작입니다. :term을 실행했을 때 기존 편집 화면이 사라진 것처럼 보이는 이유는, 새 창을 열지 않고 현재 창에서 터미널을 덮어씌웠기 때문입니다.
--
-- 사용자님이 원하시는 "편집 화면을 유지하면서 터미널을 다루는 방법"은 크게 두 가지가 있습니다.
--
-- ---- ----
-- 방법 1: 창을 나누어서 터미널 열기 (가장 추천)
-- 기존 코드를 화면에 띄워둔 채로, 별도의 분할 창에서 터미널을 여는 방식입니다. 이렇게 하면 터미널 창을 닫아도 코드가 있는 창은 그대로 남습니다.
-- 세로 분할 터미널: :vsplit | term (오른쪽에 터미널 오픈)
-- 가로 분할 터미널: :split | term (아래쪽에 터미널 오픈)
--
-- 작업 순서:
-- :split | term 입력 (아래쪽에 터미널이 생깁니다)
-- terminal 모드에서 필요한 작업 수행
-- <Esc><Esc>로 Normal 모드 진입
-- :q 입력 -> 터미널 창만 닫히고, 위쪽의 편집 화면으로 포커스가 돌아갑니다.
--
-- ---- ----
-- 방법 2: 버퍼(Buffer) 개념 이해하기 (현재 상태에서 복귀)
-- 만약 이미 현재 창에서 :term을 실행해버렸다면, nvim을 끄지 않고 편집 화면으로 돌아가는 방법은 다음과 같습니다.
-- ----
-- 방법 A (버퍼 이동): :b# 또는 :bp
--
-- 터미널도 하나의 '버퍼'입니다. :b#를 입력하면 "직전 에 사용했던 버퍼(편집하던 코드)"로 화면을 전환합니다. 터미널 버퍼는 배경에서 계속 돌아가고 있습니다.
--
-- ----
-- 방법 B (터미널 버퍼 삭제): :bd!
--
-- bd는 Buffer Delete의 약자입니다. 현재 터미널 버퍼를 강제로 종료하고 삭제하면, 자연스럽게 이전 버퍼(코드 화면)가 다시 나타납니다.
--
-- ---- ----
-- 3. 더 편하게 사용하는 꿀팁 (단축키 설정)
-- 매번 :split | term을 치는 건 귀찮으므로, init.lua에 아래 설정을 추가해 보세요. LazyVim처럼 편리하게 터미널을 여닫을 수 있습니다.
--
-- 아래쪽에 작은 터미널 창 열기 (높이 10줄) --> :q 사용
vim.keymap.set('n', '<leader>st', '<cmd>split | term<cr><cmd>resize 10<cr>', { desc = 'Terminal (split)' })

-- 현재 창에서 터미널 열기 --> :b# , :bd! 사용
--
vim.keymap.set('n', '<leader>tt', '<cmd>term<cr>', { desc = 'Terminal (current)' })
--
-- cf) ToggleTerm 플러그린 : 특정 키 하나로 터미널이 아래에서 슥 올라왔다 내려갔다 하는 ToggleTerm 플러그인
-- }}}

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- --------------------------------------


-- --------------------------------

--
--

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
--
--
-- ----------------------------
-- by stc
--
-- -- ------------------------
-- -- 모든 플로팅 창(Floating Window)에서 q 허용하기
-- -- 이 방법은 marks.nvim뿐만 아니라 다른 플러그인의 팝업창에서도 q로 쉽게 닫을 수 있게 해주므로 매우 범용적입니다.
-- -- 팝업(Floating) 창에서 q와 Esc로 쉽게 닫기 위한 전역 설정
-- vim.api.nvim_create_autocmd('WinEnter', {
--   group = vim.api.nvim_create_augroup('PopUpClose', { clear = true }),
--   callback = function()
--     -- 0은 현재 창(window)을 의미합니다.
--     local config = vim.api.nvim_win_get_config(0)
--
--     -- 창의 설정 중 'relative'가 비어있지 않다면 플로팅(팝업) 창입니다.
--     if config.relative ~= '' then
--       vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = true, silent = true })
--       vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', { buffer = true, silent = true })
--     end
--   end,
-- })
-- -- ------------------------
--
-- -- ------------------------
-- marks.nvim 관련 keymapping
-- 모든 마크를 리스트로 보기 (Project Overview),
vim.keymap.set('n', '<leader>mla', '<cmd>MarksListAll<CR>', { desc = 'View All Marks in List' })
-- 현재 파일의 마크만 리스트로 보기
vim.keymap.set('n', '<leader>mlb', '<cmd>MarksListBuf<CR>', { desc = 'View Buffer Marks in List' })
-- -- ------------------------
--
-- -- --------------------------
-- -- by stc
-- -- nvim-tree을 위한 설정
--
-- -- disable netrw at the very start of your init.lua
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
--
-- -- optionally enable 24-bit colour
-- vim.opt.termguicolors = true
--
-- -- -- empty setup using defaults
-- -- require("nvim-tree").setup()
--
-- -- OR setup with some options
-- require('nvim-tree').setup {
--   sort = {
--     sorter = 'case_sensitive',
--   },
--   view = {
--     width = 30,
--   },
--   renderer = {
--     group_empty = true,
--   },
--   filters = {
--     dotfiles = true,
--   },
-- }
-- -- --------------------------
--
-- ----------------------------
-- by stc
--
-- -----------------
-- 1. which-key를 활용한 그룹화 설정
-- which-key 제작자가 권장하는 방식은 require("which-key").add() (v3 기준)를 사용하여 단축키를 계층적으로 등록하는 것입니다. 이렇게 하면 Alt 관련 기능들을 하나의 그룹으로 묶어 볼 수 있습니다.

--
--
--
--
-- vim: set foldmethod=marker foldmarker={{{,}}}:
