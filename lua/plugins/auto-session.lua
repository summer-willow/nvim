-- 자동화된 세션 저장/복원 및 디렉토리/Git 브랜치별 관리 기능을 갖춘 세션 관리 플러그인
-- Neovim이 켜지자마자 완전 자동 복원.
-- NOTE: AutoSession delete ==> session 정보 모두 지우기 (즉, 초기화)

return {
  "rmagatti/auto-session",
  lazy = false,

  -- {{{
  -- ----------------------------------------
  -- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  --
  -- 이 설명은 "Neovim이 작업 환경을 세션 파일로 저장할 때, 과연 '어디까지 기억할 것인가'를 지정하는 설정"에 대한 가이드입니다.
  --
  -- auto-session 플러그인은 Neovim 내장 기능인 세션 생성 기능을 활용해 동작하는데, 이때 저장 대상에 무엇을 포함할지 결정하는 기본 값이 Neovim 내장 변수인 vim.o.sessionoptions입니다.
  --
  -- sessionoptions: Neovim이 세션 저장 파일에 기록할 요소(버퍼, 창 크기, 접기 상태 등)를 지정하는 Neovim 내장 설정
  -- vim.o.sessionoptions: Neovim Lua 환경에서 global 세션 옵션을 설정하는 변수
  --
  -- 보통 Neovim 설정 구조상, vim.o.sessionoptions는 Neovim의 기본 옵션 파일 (예: lua/config/options.lua 또는 init.lua)에 위치하는 편이다.
  --
  -- 하지만, auto-session 설정 파일 안에서 init 함수를 사용해 sessionoptions까지 한 번에 깔끔하게 적용하는 가장 이상적인 방법입니다.
  -- 
  -- init = function() ... end 안에 내장 옵션을 선언해 두시면, 외부 설정 파일을 이리저리 찾을 필요 없이 auto-session 플러그인이 켜짐과 동시에 GitHub에서 권장하는 최적의 세션 환경이 완벽하게 세팅됩니다!
  -- ----------------------------------------
  -- }}}
  -- 플러그인이 로드되기 직전에 Neovim 내장 세션 옵션을 먼저 맞춰줍니다.
  init = function()
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    -- 1. 저장/복원을 하지 않을 디렉토리 지정 (세션 꼬임 방지)
    suppressed_dirs = {
      "~/",
      "~/Projects",
      "~/Downloads",
      "~/Documents",
      "~/Desktop",
      "/",
    },

    -- 2. Git 브랜치별로 세션을 따로 관리할지 여부 (필요 시 true로 변경)
    git_use_branch = false,

    -- 3. 저장 시 사용할 Neovim 세션 옵션 (기본값 추천)
    -- Telescope와 연동하여 저장된 세션 목록을 대화형 팝업 창으로 검색하고 전환할 수 있게 도와주는 auto-session 전용 도구
    -- 필요할 때 세션 검색 도구(session-lens)를 바로 호출할 수 있도록 키맵을 엮은 구성입니다.
    session_lens = {
      -- Telescope / Picker 등을 이용한 세션 검색 창 설정
      load_on_setup = true,
      theme_conf = { border = true },
    },
  },

  keys = {
    -- 세션 검색 및 선택 (Telescope / Picker 연동)
    -- 저장된 모든 세션 목록을 열어 원하는 프로젝트 세션으로 전환.
    { "<leader>wr", "<cmd>AutoSession search<CR>", desc = "Search session" },

    -- 현재 작업 디렉토리 세션 수동 저장
    { "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save session" },

    -- 현재 작업 디렉토리 세션 자동 저장 끄기/삭제
    { "<leader>wd", "<cmd>AutoSession delete<CR>", desc = "Delete session" },
  },

}
