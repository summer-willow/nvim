-- Bootstrap lazy.nvim
--
--
--
--
--
--
-- See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
-- To check the current status of your plugins, run
--    :Lazy
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Setup lazy.nvim
require('lazy').setup {
  spec = {
    -- import your plugins
    -- { import = "plugins" },
    { import = 'tcshin.plugins' },
    { import = 'tcshin.plugins.lsp' },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { 'habamax' } },
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
}
