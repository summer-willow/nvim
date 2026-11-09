-- ~/.config/nvim/after/ftplugin/markdown.lua

-- 들여쓰기 기본값 (가장 보편적인 2칸 들여쓰기 설정)
-- vim.opt_local.expandtab = true
vim.opt_local.tabstop = 2 -- 탭(\t) 문자가 차지하는 너비 
vim.opt_local.shiftwidth = 2  -- >>, << 키로 들여쓰기 하거나 자동 들여쓰기 시 4칸 이동
vim.opt_local.softtabstop = 2 -- 편집 중 탭/백스페이스를 누를 때 4칸 단위로 작동

-- 2. 자동 줄바꿈 및 서식 
vim.opt_local.wrap = true             -- 화면 끝에서 소프트 줄바꿈 (문서 작성 필수) 
vim.opt_local.linebreak = true        -- 단어 중간이 잘리지 않고 공백 단위로 줄바꿈 
vim.opt_local.breakindent = true      -- 줄바꿈된 뒷줄도 앞줄의 들여쓰기 위치를 유지 (들여쓰기 유지)

vim.opt_local.expandtab = true    -- 탭을 공백(Space)으로 변환
vim.opt_local.autoindent = true   -- 다음 줄 자동들여쓰기 , - 엔터를 쳐서 다음 줄로 갈 때, 이전 줄의 들여쓰기를 그대로 유지


-- -------------------------------------------------------------
-- {{{
--
--[[
# Neovim에 내장된 마크다운용 들여쓰기 엔진(indentexpr)의 기본 동작 방식 

Vim/Neovim은 마크다운 파일(ft=markdown)을 열 때 자체 내장된 들여쓰기 규칙 파일(indent/markdown.vim)을 자동으로 로드합니다. 이 규칙의 핵심은 다음과 같습니다.

빈 줄 다음의 일반 텍스트: 마크다운 문법상 빈 줄 뒤에 나오는 일반 텍스트는 새로운 문단(Paragraph)의 시작으로 간주합니다. 문단의 시작은 들여쓰기가 없는 0번 칸(첫 칸)에서 시작하는 것이 마크다운 표준 서식이기 때문에, 사용자가 의도적으로 <Tab>을 넣어 들여쓰기를 조절했더라도 엔터를 누르는 순간 Neovim이 "새 문단이니까 첫 칸으로 초기화해야지" 하고 강제로 커서를 맨 앞으로 당겨버립니다.

리스트 형태 (-, *, 1.): 리스트는 하위 항목을 가질 수 있는 구조적 요소이므로, Neovim 내장 엔진이 이전 줄의 들여쓰기 레벨을 기억하고 유지해 줍니다.

# 일관되게 자동 들여쓰기 유지하기
- 마크다운 들여쓰기 동작 규칙 무시하고, 무조건 윗줄에 따라서 들여쓰기가 되게 하기
==> 마크다운을 작성할 때 내장 문법 엔진의 강제 정렬을 끄고, 사용자가 입력한 들여쓰기 레벨(autoindent)이 엔터를 쳐도 일관되게 유지되도록 설정을 변경해야 합니다.

-- Neovim 내장 마크다운 들여쓰기 엔진 비활성화
vim.opt_local.indentexpr = ""


NOTE: cf) 진단 방법
위와 같이 설정으 바꾸었는데도, 여진히 '무조건 autoindent'가 안된다면, 다음과 같이 진단을 할 수 있다.
마크다운 파일을 열어둔 상태에서, 다음 명령어으로 무엇이 설정을 가로채고 있는지 확인 할 수 있다.
:verbose set indentexpr?
:verbose set smartindent?


## 만약 nvim=treesitter를 설치했다면, Treesitter 관련 설정이 들여쓰기 규칙을 다시 덮어써 버려서 다시 기본 마크다운 들여쓰기 동작 규칙을 따르게 된다(런타임 로드 순서 문제). 즉, 위의 vim.opt_local.indentexpr = ""가 효력을 발휘하지 못한다.

Neovim이 마크다운 파일을 파싱하면서 nvim-treesitter 플러그인의 들여쓰기 기능(indentexpr)을 그 이후에 강제로 덮어써 버립니다. Treesitter의 마크다운 들여쓰기 엔진 역시 마크다운 표준을 따르기 때문에 빈 줄 뒤의 일반 글을 첫 칸으로 초기화해 버렸던 것입니다.

이 문제를 해결하려면 Treesitter 설정에서  마크다운에 대한 Treesitter 들여쓰기 기능을 비활성화해야 합니다.

## 해결 방법 1: 
Treesitter의 마크다운 들여쓰기 끄기 사용 중인 Treesitter 설정 파일 내, nvim-treesitter.configs 설정 부분에서 indent 항목의 disable 리스트에 "markdown"을 추가해 주어야 합니다.

-- Treesitter 설정 파일 (예: lua/plugins/treesitter.lua 또는 관련 설정 위치)
require('nvim-treesitter.configs').setup {
  -- ... 다른 설정들 ...

  indent = {
    enable = true,
    disable = { "markdown" }, -- [핵심] 마크다운은 Treesitter 들여쓰기 계산에서 제외합니다.
  },
}

## 해결 방법 2: (가장 확실한 꼼수)
Neovim이 모든 파일 타입 설정을 끝낸 직후에 강제로 들여쓰기 계산식을 한 번 더 지워버리는 자동 명령(Autocmd)을 사용할 수 있습니다.

after/ftplugin/markdown.lua 파일의 맨 아래에 다음 코드를 추가해 주세요. 파일이 열린 후 수 밀리초 후에 실행되어 Treesitter가 덮어쓴 것을 다시 지워버립니다.

-- ~/.config/nvim/after/ftplugin/markdown.lua 맨 아래에 추가

-- Treesitter가 설정을 덮어쓰는 것을 방지하기 위해 파일이 열린 후(BufWinEnter) 다시 한 번 강제로 초기화
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*.md",
  callback = function()
    vim.opt_local.indentexpr = ""
    vim.opt_local.autoindent = true
  end,
})

이제 :verbose set indentexpr?을 입력했을 때 값이 비어있게(indentexpr=) 나오면서 일반 글에서도 원하는 대로 일관된 자동 들여쓰기가 작동할 것입니다!

--]]
--
-- }}}
--
-- -- Treesitter 나 다른 플러그인이 
-- -- vim.opt_local.indentexpr = ""  설정을 덮어쓰는 것을 방지하기 위해 
-- -- 파일이 열린 후(BufWinEnter) 다시 한 번 강제로 초기화
-- vim.api.nvim_create_autocmd("BufWinEnter", {
--   pattern = "*.md",
--   callback = function()
--     vim.opt_local.indentexpr = ""
--     -- vim.opt_local.autoindent = true
--   end,
-- })
-- -------------------------------------------------------------


-- {{{
-- breakindent = true를 켜두면 화면상 줄바꿈된 텍스트도 원래 시작했던 들여쓰기 깊이(인용구 내부나 리스트 내부 위치)에 맞춰서 시각적으로 들여쓰기를 해줍니다.  
-- breakindent가 없으면 줄바꿈된 글들이 화면 맨 왼쪽(공백 0인 곳)으로 붙어버려 가독성이 심하게 깨집니다.  
--}}}
--
-- vim.opt_local.spell = true      -- 영어 맞춤법 검사 활성화 (필요 시)

-- NOTE: How to - 현재 파일의 (특정)설정 확인
-- ex)
-- :verbose set autoindent?
-- :verbose set formatoptions?

-- 3. 리스트(-, *, 1.), 인용구(>) 자동화 설정 : ormatoptions 
-- ormatoptions나 comments는 주로 리스트 마커(-, *, 1.)나 인용구(>)에 대한 제어를 제공.
-- 💡 일반적인 텍스트 자동 서식(t)을 제외하고, 주석과 리스트 들여쓰기 제어 위주로 설정합니다.
-- vim.opt_local.formatoptions = "jcqlntro"
-- vim.opt_local.formatoptions = "jcqlnro"
vim.opt_local.formatoptions = "jcqlnt"   -- my choice
-- j : 주석 삭제 시 불필요한 공백 제거
-- c : 주석/텍스트 자동 래핑 (필요 시)
-- q : gq 명령어로 텍스트 정렬 가능
-- l : 삽입 모드에서 긴 줄이 있어도 자동으로 끊기지 않음 (작성 중 끊김 방지)
-- n : 번호 리스트 인식 정렬. 즉, 숫자로 된 리스트(예: 1. , 2.  등)를 입력할 때, 들여쓰기 정렬 기준을 숫자가 아닌 텍스트가 시작되는 위치로 맞춰줍니다.
-- t : 텍스트 너비에 맞춰 자동 줄바꿈
-- r : Enter 입력 시 리스트 마커/인용구 자동 삽입. 즉, 삽입 모드(Insert mode)에서 글을 쓰다가 <Enter>를 누르면, 윗줄에 있던 리스트 마커(-, *, 1.)나 인용구 기호(>)를 다음 줄에 자동으로 삽입해 줍니다.
-- o : Normal 모드에서 o, O 입력 시 리스트 마커/인용구 자동 삽입. 즉, 일반 모드(Normal mode)에서 o나 O를 눌러 새 줄을 열 때도 자동으로 리스트 마커를 붙여줍니다.

-- 4. 리스트 기호 및 인용구 정밀 인식을 위한 정규식 패턴 (Vim 내장 기능)
-- 엔터나 gq를 누를 때 마크다운의 리스트와 blockquote를 정확히 인식하게 만듭니다.
vim.opt_local.comments = "b:*,b:-,b:+,b:1.,n:>"
-- vim.opt_local.comments: 이 설정이 바로 Vim에게 무엇이 리스트 마커이고 무엇이 인용구 기호인지 알려주는 지도 역할을 합니다. 
-- n:>는 > 기호 뒤에 글이 이어지는 인용구(blockquote) 레벨을 뜻하므로, 윗줄이 > 상태라면 다음 줄 엔터를 쳤을 때 자동으로 >를 붙이고 들여쓰기 정렬을 유지해 줍니다.


-- Conceal 설정 (Markdown 기호를 숨겨서 깔끔하게 보기)
vim.opt_local.conceallevel = 2



-- -----------------------------------------------------
-- aerial.nvim에서 markdown 파일의 outline의 icon 서정
-- -----------------------------------------------------
-- 마크다운 파일이 열렸을 때만 aerial의 아이콘 설정을 숫자 형태로 덮어씁니다.
local status_ok, aerial = pcall(require, "aerial")
if status_ok then
  aerial.setup({
    icons = {
      -- 마크다운 전용 헤딩 레벨별 아이콘 지정
      -- Module    = "1󰫎", -- # (H1)
      -- Interface = "2󰫎", -- ## (H2)
      -- String    = "3󰫎", -- ### (H3)
      -- Constant  = "4󰫎", -- #### (H4)
      -- Variable  = "5󰫎", -- ##### (H5)
      -- Fields    = "6󰫎", -- ###### (H6)

      Module    = "󰎥 ", -- # (H1)
      Interface = "󰎨 ", -- ## (H2)
      String    = "󰎫 ", -- ### (H3)
      Constant  = "󰎲 ", -- #### (H4)
      Variable  = "󰎯 ", -- ##### (H5)
      Fields    = "󰎴 ", -- ###### (H6)
    }
  })
end
-- -----------------------------------------------------


-- vim: set foldmethod=marker foldmarker={{{,}}}:
