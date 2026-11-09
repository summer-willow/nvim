-- {{{
-- 활용: 
-- 만약 수동으로 "이 플러그인 로드됨!" 같은 메시지를 띄워보고 싶다면, 각 플러그인 설정의 config 함수 안에 아래 코드를 한 줄 넣어보세요.
-- syntax: vim.notify(알림 메세지, 알림 타입, 알림창제목)
--  알림 타입 : Info, Warn, error
-- ex)
--  vim.notify("Treesitter 로드 완료!", "info", { title = "플러그인 상태" })
--
--  vim.notify("Hello Neovim!", "info", {title = "테스트 알림"})
--
-- 추가 명령
--  to clear the history.
-- :NotificationsClear
-- Or clear the histroy with the clear history function
-- require("notify").clear_history()
-- }}}

return {
  {
    "rcarriga/nvim-notify",
    -- 다른 플러그인들보다 가급적 먼저 로드되도록 설정
    lazy = false, -- 지연 로딩을 하지 않음. Neovim 시작 시 즉시 로드.
    opts = {  -- (설정 데이터 테이블)
      timeout = 3000, -- 알림이 유지되는 시간(ms)

      -- 알림창의 최대 높이 설정
      max_height = function()
        -- 알림창 최대 높이
        return math.floor(vim.o.lines * 0.75) -- -- 전체 화면 높이의 75%를 넘지 않게 함.
        -- math.floor: 소수점을 버리고 정수로 만듭니다. 
      end,

      -- 알림창의 최대 너비 설정
      max_width = function()
        -- 알림창 최대 너비
        return math.floor(vim.o.columns * 0.75) -- -- 전체 화면 너비의 75%를 넘지 않게 함.
      end,

      on_open = function(win)
        -- 알림창 창(window)이 열릴 때 실행되는 함수
        vim.api.nvim_win_set_config(win, { zindex = 100 })
        -- zindex = 100: 알림창이 다른 부유 창(Floating Window)보다 항상 위에 보이도록 우선순위를 높이는 설정입니다. (숫자가 높을수록 앞쪽에 배치됨)
      end,

      stages = "fade_in_slide_out",  -- 애니메이션 스타일: 서서히 나타나고 옆으로 미끄러지듯 사라짐. (fade, slide, static 등)
      render = "default",            -- 렌더링 스타일: 아이콘과 제목이 있는 기본 스타일 사용.
      background_colour = "#000000", -- 알림창 뒤의 배경색을 검정색으로 설정.
    },

    
    -- config (실행 로직) : 설정한 opts를 실제로 적용하고 Neovim 시스템에 연결
    config = function(_, opts)
      local notify = require("notify") -- nvim-notify 모듈 불러오기
      notify.setup(opts)               -- 위에서 설정한 opts 적용
      vim.notify = notify              -- Neovim 내장 알림 함수(print, echo 등)를 nvim-notify로 교체
      -- vim.notify = notify: 이 코드가 있어야 print()나 vim.api.nvim_echo() 같은 칙칙한 메시지들이 오른쪽 상단의 예쁜 알림창으로 변하게 됩니다.

      -- -- test
      -- vim.notify("nvim-notify 로드 완료!", "info", { title = "플러그인 상태" })
      -- -- end test
    end,

    keys = {
      {
        "<leader>un",
        function()
          -- 모든 알림창을 즉시 닫음
          require("notify").dismiss({ silent = true, pending = true })
          -- dismiss: 화면에 알림이 너무 많이 쌓여서 방해될 때, 단축키 한 번으로 싹 지우는 기능
        end,
        desc = "Dismiss all Notifications",
      },
    },
  },

}


