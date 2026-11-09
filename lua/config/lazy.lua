-- Bootstrap lazy.nvim

-- See `:help lazy.nvim` or https://github.com/folke/lazy.nvim for more info
--
-- To check the current status of your plugins, run
--    :Lazy
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
    -- { import = "tcshin.plugins" },
    -- { import = "tcshin.plugins.lsp" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  -- checker: 업데이트 체크 설정
  checker = {
    enabled = true, -- Neovim을 실행할 때마다 설치된 플러그인들의 새로운 업데이트가 있는지 백그라운드에서 자동으로 확인
    notify = false, -- (중요) 업데이트가 있을 때 화면 우측 하단에 팝업 알림을 띄우지 않도록 함
  },
  -- change_detection : 설정 변경 감지
  change_detection = {
    notify = false, -- 설정 변경 감지 후 자동 로드될 때, 알림 메시지를 띄우지 않음
  },

  -- Nerd Font가 설치되지 않았을 때를 위한, lazy.nvim 자체의 모양새(아이콘)를 설정하는 부분
  ui = {
    -- 1. 아이콘 설정 (Nerd Font 사용 여부에 따른 자동 전환)
    -- 만약 'vim.g.have_nerd_font' 변수가 true(참)라면 빈 테이블 {} 을 반환하여
    -- lazy.nvim이 기본으로 제공하는 예쁜 너드 폰트 아이콘들을 사용합니다.
    -- 만약 false(거짓)라면 'or' 뒤에 정의된 이모지(Unicode) 테이블을 사용합니다.
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',      -- 명령어로 인해 실행될 때
      config = '🛠',    -- 플러그인 설정 관련
      event = '📅',    -- 특정 이벤트 시 로드
      ft = '📂',      -- 파일 타입별 로드
      init = '⚙',      -- 초기화 관련
      keys = '🗝',     -- 단축키 관련
      plugin = '🔌',   -- 플러그인 자체 표시
      runtime = '💻',  -- 런타임 관련
      require = '🌙',  -- 모듈 호출 관련
      source = '📄',   -- 소스 파일 관련
      start = '🚀',    -- 시작 시 바로 실행
      task = '📌',    -- 작업/프로세스 관련
      lazy = '💤 ',   -- 지연 로딩(나중에 실행) 중임을 표시
    },

    -- 참고: 여기에 border = 'rounded' 같은 설정을 추가하여 
    -- 관리창의 테두리를 둥글게 만들 수도 있습니다.
  },
})
