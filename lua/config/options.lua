
-- -------------------------------------------
-- See `:help vim.o`
-- NOTE: For more options, :help option-list`
-- -------------------------------------------

-- -------------------------------------------
-- 설정 카테고리 추천
--
-- 개인 설정 파일을 체계적으로 관리하고 싶으시다면, termguicolors는 보통 Appearance(외관) 혹은 UI 카테고리에 포함됩니다.
--
-- 사용자의 스타일(Comm. Engineering, Neovim 커스텀 등)을 고려하여 직관적으로 분류할 수 있는 카테고리 리스트를 제안해 드립니다.
--
-- -------------------------------------------

-- -------------------------------------------
-- 1. UI & Appearance (외관 관련) - termguicolors 포함
-- -------------------------------------------
-- Lua
-- -- ui & appearance
-- vim.opt.termguicolors = true
-- vim.opt.background = "dark"
-- vim.cmd("colorscheme tokyonight")
--
-- -------------------------------------------
-- 2. Editor Behavior (편집기 동작)
-- -------------------------------------------
-- Lua
-- -- editor behavior
-- vim.opt.number = true          -- numbering
-- vim.opt.relativenumber = true  -- 상대 줄 번호
-- vim.opt.cursorline = true      -- 현재 줄 강조
-- vim.opt.mouse = "a"            -- 마우스 사용 허용
--
-- -------------------------------------------
-- 3. Indentation & Tabs (들여쓰기)
-- -------------------------------------------
vim.opt.expandtab = true   -- 탭 키를 누르면 공백(Space)으로 변환
vim.opt.tabstop = 4        -- 기존의 탭 문자를 화면에 공백 4칸 크기로 표시
vim.opt.shiftwidth = 4     -- >>, << 키로 들여쓰기 하거나 자동 들여쓰기 시 4칸 이동
vim.opt.softtabstop = 4    -- 편집 중 탭/백스페이스를 누를 때 4칸 단위로 작동
vim.opt.autoindent = true  -- 엔터를 쳐서 다음 줄로 갈 때, 이전 줄의 들여쓰기를 그대로 유지

-- 파일 타입 감지 + 해당 파일에 맞는 인덴트 규칙 로드
-- (nvim의 default, 하지만 명시적으로 설정, 없어도 됨)
-- vim.cmd("filetype plugin indent on")

 -- syntax on(구문 강조 활성화)
-- default로 nvim에 setting 되어있음.
-- 소스 코드의 알록달록한 색상(Syntax Highlighting)을 자동으로 보여줌
-- nvim에서는 사용자 대부분이 treesitter를 사용하므로, 사실상 필요 없음.
-- vim.cmd("syntax on")  -- 예전 vim 명령어 사용
-- cf) 순수 Lua API를 사용하는 방법 (vim.api) -->  vim.api.nvim_command("syntax on")   



-- -------------------------------------------
-- 4. Search & General (검색 및 일반)
-- -------------------------------------------
-- Lua
-- -- search & general
-- vim.opt.ignorecase = true
-- vim.opt.smartcase = true
-- vim.opt.clipboard = "unnamedplus" -- 시스템 클립보드 연동
-- vim.opt.fileencoding = "utf-8"    -- encoding
--
-- -------------------------------------------
-- 5. Performance & System (성능 및 시스템)
-- -------------------------------------------
-- Lua
-- -- performance & system
-- vim.opt.updatetime = 250       -- 반응 속도 관련
-- vim.opt.timeoutlen = 300       -- 키 매핑 대기 시간
-- vim.opt.swapfile = false
--
-- -------------------------------------------
-- 6. Custom Icons & Fonts (폰트 관련)
-- -------------------------------------------
-- Lua
-- -- nerd font & symbols
-- -- 주로 lualine이나 nvim-web-devicons 설정 시 사용되는 개념들
-- 팁
-- 현재 Neovim 설정을 Kickstart.nvim 스타일로 모듈화하고 계시므로, 위 카테고리들을 아예 별도의 파일(예: options.lua)로 몰아넣거나, 주석을 이용해 위와 같이 그룹화하면 나중에 코드를 유지보수하기 훨씬 편해집니다.
-- -------------------------------------------




-- -------------------------------------------
-- leader
-- -------------------------------------------
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '
vim.g.maplocalleader = "\\"

-- -------------------------------------------
-- nerd font
-- -------------------------------------------
-- Set to true if you have a Nerd Font installed and selected in the terminal
-- vim.g.have_nerd_font = false
vim.g.have_nerd_font = true

-- -------------------------------------------
-- encoding
-- -------------------------------------------
-- 내부 인코딩 (nvim은 기본이 utf-8이지만 그래도 명확히 명시)
vim.opt.encoding = "utf-8"

-- 파일을 저장할 때 사용할 인코딩
vim.opt.fileencoding = "utf-8"

-- 파일을 읽어올 때 시도할 인코딩 순서 (한글 완성형 cp949 대응)
vim.opt.fileencodings = { "utf-8", "cp949", "korea" }

-- ----------------
-- 2. powershell 환경 설정 (가장 중요)
-- neovim 설정만 바꾼다고 해서 :term이나 외부 명령어 실행 결과가 한글로 잘 나오는 것은 아닙니다. 윈도우 터미널(powershell)의 출력 환경을 utf-8로 맞춰야 합니다.

-- 윈도우 터미널(powershell)의 출력 환경을 utf-8로 설정
-- 방법 A: init.lua에서 쉘 설정 강제하기
-- neovim이 실행될 때 powershell의 코드 페이지를 utf-8(65001)로 바꾸도록 설정
-- if vim.fn.has("win32") == 1 then
--     -- powershell 실행 시 utf-8 환경 강제
--     vim.opt.shell = "powershell.exe"
--     vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
-- end

-- cf) 방법 B: powershell 프로필 수정 (시스템 전체 적용)
-- 터미널에서 notepad $PROFILE을 입력하여 프로필 파일을 열고 아래 내용을 추가하면, neovim 밖에서도 한글 문제가 해결됩니다.
-- [Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
-- ----------------

-- -------------------------------------------
-- GUI color
-- Appearance(외관) 혹은 UI 카테고리에 포함됩니다.
-- -------------------------------------------

-- turn on termguicolors for tokyonight colorscheme to work
vim.opt.termguicolors = true -- the colorscheme can show up properly
-- termguicolors 설정이 필요한 이유: 24-bit True Color를 사용함으로 터미널에서도 
-- GUI 수준의 풍부한 색상 ( 2^24 = 16,777,216, 약 1,600만 가지 색상) 사용 가능.
-- colorscheme 설정 (tokyonight 등), nvim-colorizer.nvim 등등이 제대로 색 표현을 함.
vim.opt.background = 'dark' -- colorschemes that can be light or dark will be made dark. If a colorscheme support both light and dark, it will use the dark version.



-- -------------------------------------------
-- numbering
-- -------------------------------------------
-- Make line numbers default
vim.o.number = true	-- line number
vim.o.relativenumber = true	-- relative line number, to help with jumping

-- -- -------------
-- -- 현재 커서가 있는 줄 번호의 색상 (오렌지색)
-- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FFA500", bold = true })
--
-- -- 커서 위/아래의 상대적 줄 번호 색상 (빨간색)
-- -- 순정 상태에서는 'LineNr' 그룹이 상대 번호의 색상을 담당합니다.
-- vim.api.nvim_set_hl(0, "LineNr", { fg = "#FF0000" })
-- -- ------------




-- -------------------------------------------
-- -------------------------------------------
-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'
-- {{{ 설명
-- vim.o.mouse: Neovim의 마우스 동작 방식을 결정하는 옵션
-- 'a': All 모드를 의미합니다. 즉, 아래의 모든 모드에서 마우스를 활발하게 사용하겠다는 뜻입니다.
-- Normal 모드: 커서 이동, 창 크기 조절.
-- Visual 모드: 마우스 드래그로 블록 선택.
-- Insert 모드: 클릭한 지점으로 커서 이동 후 편집.
-- Command 모드: 클릭으로 커서 위치 변경.
-- }}}

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- --------------------------------
-- vim.opt.textwidth = 78 -- hard wrapping, 자동 줄바꿈 문자(\n) 삽임 위치. (물리적인 줄바꿈 = 해당 column 에 \n 를 실제로 삽입),
vim.opt.textwidth = 0 -- hard wrapping (자동 줄바꿈) 끄기
-- vim.opt.colorcolumn = '80'	-- column 줄 표시, guideline for text width

vim.opt.wrap = true -- 시각적 줄바꿈 활성화, soft wrapping
vim.opt.breakindent = true -- Enable break indent: wrapped-line의 들여쓰기 유지
vim.opt.linebreak = true -- 단어 중간이 아니라 공백에서 줄바꿈

-- 굽어진 줄 앞에 특정 기호를 넣어 "이건 이어진 줄이야"라고 표시하고 싶다면:
vim.opt.showbreak = '↳ ' -- wrapped-line 앞에 화살표 표시

-- --------------------------------
-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
-- vim.o.timeoutlen = 300      -- 키 매핑 대기 시간, 기본값: 보통 1000(1초) or 500(0.5초)
vim.o.timeoutlen = 800      -- 키 매핑 대기 시간, 기본값: 보통 1000(1초) or 500(0.5초)

-- Configure how new splits should be opened
vim.o.splitright = true -- 세로 분할시 새 창을 오른쪽에 띄움
vim.o.splitbelow = true -- 가로 분할시 새 창을 아래쪽에 띄움

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-guide-options`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
-- vim.o.scrolloff = 10
vim.o.scrolloff = 3

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
-- 저장없이 끝내려(:q) 할 때, 저장할 지 물어본다
vim.o.confirm = true


-- --------------------------------
-- by stc
-- {{{ 줄의 시작/끝에서 이전/다음 줄로 이동하기
--
-- Automatically wrap left and right
-- ~/.config/nvim/lua/config/options.lua
-- 줄의 시작/끝에서 h/l을 눌렀을 때 다음 줄로 이동하게 해준다.
-- whichwrap은 커서가 줄의 시작/끝에 있을 때 특정 키 입력으로 다음/이전 줄로 넘어가도록 제어합니다.
--
-- h → 줄 시작에서 누르면 이전 줄 끝으로 이동
-- l → 줄 끝에서 누르면 다음 줄 시작으로 이동
-- < / > → 방향키 왼쪽/오른쪽도 같은 방식으로 동작
-- [ / ] → [, ] 키도 줄 경계를 넘어 이동
-- b →  Backspace	→ 일반/비주얼 모드에서 이전 줄 끝으로 이동
-- s → Space → 일반/비주얼 모드에서 다음 줄 처음으로 이동
-- }}}
vim.opt.whichwrap:append '<,>,h,l,[,]'
-- vim.opt.whichwrap = "b,s,h,l,<,>,[,]"
-- {{{ Vimscript 스타일 그대로 사용 가능
-- vim.cmd("set whichwrap+=<,>,h,l,[,]")
-- }}}
-- --------------------------------

-- --------------------------------
-- 마크다운을 위한 Neovim 기본 옵션
-- markdown(md) conceal level 설정
-- obsidian.nvi에서 md를 사용하므로, 필요함
-- ==> after/ftplugin/markdown.lua 에서 martkdown엑 관계된 모든 설정을 관리하므로 여기서는 생략
vim.opt.conceallevel = 2     -- 렌더링된 마크다운 기호(#, *, _ 등)를 숨겨서 예쁘게 보여줍니다.
-- vim.opt.concealcursor = "nc" -- 일반(n), 명령(c) 모드에서는 숨기고, 입력(i) 모드에선 원래 문자가 보이게 합니다.
-- vim.opt.autoindent = true   -- 다음 줄 자동들여쓰기






-- --------------------------------
--   command-line completion , 명령행 완성 목록 표시
-- :h wildmode
-- :h wildmenu
-- wildmenu: 명령행(:)에서 <Tab>을 눌렀을 때 나타나는 완성 목록 표시 기능을 제어
-- 목록 이동: <Tab> or <Ctrl-p>/<Ctrl-n>
-- NOTE:==> 명령행 자동완성을 위해 'hrsh7th/cmp-cmdline'를 설치했으므로 
-- 이 설정은 취소

-- -- 명령행 완성 모드 설정
-- vim.opt.wildmode = "longest:full,full"
--
-- -- Neovim 0.10 이상에서는 'pum'을 추가하면 팝업 메뉴 형태로 뜹니다.
-- vim.opt.wildoptions = "pum"
--
-- -- 목록의 높이를 조절 (예: 10개까지 표시)
-- vim.opt.pumheight = 10
-- --------------------------------

-- -------------------------------------------
-- folding
-- -------------------------------------------

-- Treesitter 기반 폴딩 설정
-- ==> 이미 nvin-treesitter.nvim에서 설정했음.
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- 파일 오픈 시 기본 폴딩 레벨 (모두 펼침)
vim.opt.foldlevel = 99      -- 99: 모두 펼침
vim.opt_local.foldlevel = 99    -- 99: 모두 펼침
-- foldlevel: "현재 창의 폴딩 제한 수위"
-- foldlevel은 코딩을 하는 도중에 실시간으로 변하는 '현재 점수'입니다. 예를 들어 모든 코드를 접는 단축키(zM)를 누르면 foldlevel은 순식간에 0으로 바뀝니다. 다시 모든 코드를 여는 단축키(zR)를 누르면 foldlevel은 99로 올라갑니다.
-- 이전에 다른 파일을 보다가 변경된 foldlevel의 영향이 새 파일에 그대로 적용되어 파일마다 열리는 모습이 제각각이 될 수 있습니다. 

vim.opt.foldlevelstart = 99     -- 99: 모두 펼침

-- "파일을 새로 열었을 때, 폴딩을 몇 단계까지 열어둘 것인가?"를 결정하는 초기화 설정
-- 존재 이유: foldlevel이 조작에 따라 변하는 값이므로, 변화된 foldlevel 값으로 파일을 열면, 열리는 파일의 folding이 일관성이 없다.
-- foldlevelstart는 파일을 처음 딱 로딩하는 시점의 기준점을 잡아줍니다.
-- "어떤 파일을 열든 항상 다 펼쳐진 상태로 시작하겠다"를 보장해 주는 안전장치입니다.

-- 너무 작은 블록(예: 1~2줄짜리 함수)은 접히지 않도록 제한 (선택 사항)
-- vim.opt.foldminlines = 3    -- 3 줄 이상의 블록을 fold 하다
-- 최소 몇 줄 이상인 블록만 접을 수 있게 허용할 것인가?"를 정하는 필터링 설정
-- folding 명령들에 (za, zo, zc, zM, zR 등등) 대해서도 적용된다: 만약 이 설정이 없으면, 코드를 전체 접기(zM) 했을 때 2줄짜리 코드들까지 모조리 접혀버려서 오히려 화면이 지저분해지고 가독성이 떨어집니다.




-- ---------------------------------------

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "markdown",
--   callback = function()
--     -- 1. Neovim 내장 마크다운 폴딩 식 사용 (또는 nvim-treesitter#foldexpr())
--     vim.opt_local.foldmethod = "expr"
--     -- vim.opt_local.foldexpr = "v:lnum=~'^##* '\\?'>'.count(matchstr(getline(v:lnum),'^##*'),'#'):'='"
--     vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
--
--     -- 2. 핵심: 파일을 열었을 때 헤딩은 다 보여주고 본문만 접는 깊이 설정
--     -- 보통 마크다운 헤딩은 최대 6단계이므로, 6레벨까지는 다 펼치고 그 안의 본문(텍스트)만 접습니다.
--     vim.opt_local.foldlevel = 6
--   end,
-- })






-- ----------------------------------------
--

-- ----------------------------------------

-- --------------------------------
-- --------------------------------
-- --------------------------------
-- --------------------------------
