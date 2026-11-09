
--[[
Being familiar with Neovim 
  
  For Lua language
    - https://learnxinyminutes.com/docs/lua/

  For a reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

  For the using o Neovim
    :Tutor

  For universal help
    :help
    use a keymap "<space>sh" to [s]earch the [h]elp documentation,

--]]

require("config.options")
require("config.keymaps")
require("config.autocmds")
require('config.commands')
require("config.lazy")

-- ------------------------------------------------
-- Neovim이 켜질 때 자동으로 VimTeX 연동용 로컬 서버를 개설 (부하 걱정 없음)
-- Neovim이 부팅될 때 무조건 백그라운드에 서버를 자동으로 개설하도록 Neovim 설정
-- nvim와 SumatraPDF와 inverse sync에서 사용됨.
-- 아무곳에 놓아도 됨 (ex, config.options.lua)
-- vim.fn.serverstart('localhost:12345')
-- ------------------------------------------------


-- ------------------------------------------------
-- colorscheme 선택
-- 모든 플러그인 로드가 끝난 후, 테마 선택
-- ----------------------
-- vim.cmd.colorscheme("catppuccin-mocha")
-- vim.cmd.colorscheme("tokyonight-night")
-- or
-- :colorscheme tokyonight-night --> nvim command로 테마 교체 가능
-- ------------------------------------------------


