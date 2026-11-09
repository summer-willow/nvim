
-- -----------------------------------------------
-- cf) lazyvim의 config 폴더 위치 (keymaps.lua, options.lua, autocmds.lua)
-- GitHub 주소: LazyVim/lua/lazyvim/config/keymaps.lua
-- c:\Users\stc\AppData\Local\nvim-lazy-data\lazy\LazyVim\lua\lazyvim\config\
-- Neovim 안에서 확인하는 가장 빠른 방법: :lua print(require("lazyvim.config.keymaps"))를 입력한 뒤 경로를 추적하거나, :verbose map <C-s>를 쳐서 어디서 정의되었는지 확인할 수 있습니다.

-- -----------------------------------------------
-- cf) lazyvim의 config 폴더 위치 (keymaps.lua, options.lua, autocmds.lua)
-- GitHub 주소: LazyVim/lua/lazyvim/config/keymaps.lua
-- c:\Users\stc\AppData\Local\nvim-lazy-data\lazy\LazyVim\lua\lazyvim\config\
-- Neovim 안에서 확인하는 가장 빠른 방법: :lua print(require("lazyvim.config.keymaps"))를 입력한 뒤 경로를 추적하거나, :verbose map <C-s>를 쳐서 어디서 정의되었는지 확인할 수 있습니다.
--
--




-- -----------------------------------------------
-- Sync clipboard between OS and Neovim.
--  {{{
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
--  }}}
 vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
-- {{{
-- win32yank가 이미 설치 되어 있어야 한다.  scoop install win32yank
-- win32yank는 도구이고, unnamedplus 설정은 그 도구를 쓰라는 명령
--
-- vim.schedule()을 쓰는 이유는 Neovim이 더 빨리 켜지게 하기 위해서
-- vim.schedule: "지금 당장 하지 말고, Neovim이 하던 일(부팅) 다 끝내고 잠시 후에 한가할 때 실행해줘"라고 예약하는 함수
-- **vim.schedule()은 "메인 작업이 끝날 때까지 기다렸다가 (nvim이 하던 일(부팅) 다 끝난 뒤) 실행해라"**라는 뜻
-- 따라서 결과적으로, nvim의 화면(UI)이 다 나타난 후에 (UiEnter 이벤트), vim.schedule()이 실행
-- UiEnter: Neovim의 '이벤트' 이름 중 하나. "Neovim의 화면(UI)이 사용자 눈앞에 막 나타난 순간"을 의미
--
-- cf) 만약 정확히 UiEnter 이벤트에 딱 맞춰서 실행하고 싶다면 원래는 아래처럼 써야 합니다.
--
-- Lua
--
-- -- 이 코드가 더 명시적인 'UiEnter' 방식입니다.
-- vim.api.nvim_create_autocmd("UiEnter", {
--   callback = function()
--     vim.opt.clipboard = "unnamedplus"
--   end,
-- })
--
-- 하지만 vim.schedule()을 쓰는 쪽이 훨씬 코드가 짧고 간결하며, 실제 동작 시간 차이도 거의 없기 때문에 Kickstart.nvim에서는 이 방식을 택한 것입니다.
--}}}
-- ----------------



-- ---- ----
-- by stc
--



-- ---- ----

-- Save undo history
vim.o.undofile = true
-- {{{
-- 실제 저장 우치 확인
-- :echo stdpath('data') . '/undo'
-- 보통 C:\Users\사용자이름\AppData\Local\nvim-data\undo 경로
-- }}}

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true -- 대/소문자 무시
vim.o.smartcase = true -- 지능형 대소문자 구분
-- {{{
-- smartcase는 반드시 ignorecase가 true일 때만 작동
-- \C : 대소문자 구별하라고 강제함. ex) \Capple : 반드시 소문자 apple 만 검색
-- \c : 대소문자 구별하지 말라고 강제함. ex) \cApple : 대문자가 포함되어 있어도 강제로 대소문자를 무시하고 다 검색
-- }}}

-- stc-here, 2026-01-20, 02:00
--
-- ---------------------------------------

--
-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'
-- vim.opt.signcolumn = "yes"
-- 표시되는 정보: Git 정보, LSP 경고/에러, 디버깅의 중단점(Breakpoint)
-- 설정값:
-- 'yes'--> 항상 공간을 확보,
-- 'number'--> 별도의 칸을 만들지 않고, 줄 번호 위에 아이콘을 겹쳐서 보여줌. (공간 절약형)
--

-- Decrease update time
-- "입력을 멈추고 updatedime가 지나면 에러 팝업을 띄우거나 수정한 내용을 임시 저장해라"
-- default : 4000 ms (= 4 sec)
-- 250ms~500ms 사이가 성능과 편의성 사이에서 가장 균형 잡힌 updatetime
-- vim.o.updatetime = 250 -- 커서 멈춤 후 반응 속도 (LSP, Git 등)
vim.o.updatetime = 450 -- 커서 멈춤 후 반응 속도 (LSP, Git 등)

-- Decrease mapped sequence wait time
-- 연속 단축키 입력 시, 다음 키를 기다려주는 유효 시간
-- default time: 1000 ms (1 sec)
-- 가장 권장되는 골든 타임은 300ms ~ 500ms 사이
-- vim.o.timeoutlen = 300 -- 단축키 대기 시간
-- vim.o.timeoutlen = 1000 -- 단축키 대기 시간
vim.o.timeoutlen = 500 -- 단축키 대기 시간

-- stc-here, 2026-01-21, 17:30
-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- {{{
-- '리스트 모드'를 활성화, 이 옵션을 켜야만 아래에서 설정할 listchars들이 화면에 실제로 보이기 시작
-- 보이지 않는 문자들을 어떤 기호로 대체해서 보여줄지 정의
-- tab = '» ': 탭(Tab) 문자가 들어간 곳에 » 기호를 표시
-- trail = '·': 줄 끝에 불필요하게 붙어 있는 공백(Trailing whitespace)을 · 기호로 표시
-- nbsp = '␣': **줄 바꿈 없는 공백(Non-breaking space)**을 ␣ 기호로 표시
-- }}}

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'
-- {{{
-- substitution 명령을 ( ex, :%s/old/new/g) 할 때, 문서의 텍스트가 실제로 바뀐 것처럼 화면에 보입니다.
-- vim.o.inccommand = 'split' (추천): 화면 밖에 있는 변화까지 보여주기 위해 임시 창을 열어줍니다(split).
-- vim.o.inccommand = 'nosplit': 현재 내 눈에 보이는 화면 범위 내에서만 미리보기를 보여줍니다. 화면 밖의 변화는 보여주지 않습니다.
-- }}}




