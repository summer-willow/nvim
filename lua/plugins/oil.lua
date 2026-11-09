return {
  -- - : open oil.nvim
  -- q : close oilnvim (keymapping)
  -- ctrl + c : close oil.nvim (default of oil.nvim)
  -- Ctrl + 6 : close oil.nvim (Vim 순정 이전 버퍼 복구 단축키)
  -- :h oil
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  -- dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  dependencies = { "nvim-tree/nvim-web-devicons" },

  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,

  config = function()
    require("oil").setup({

      -- Neovim 기본 내장 탐색기 대체
      default_file_explorer = true,

      -- 1. 🌟 창 UI 및 커서 설정
      -- skip_confirm_for_simple_edits = true, -- 파일명 한두 개 고칠 때 자꾸 뜨는 확인 팝업창을 꺼서 속도를 높입니다.

      delete_to_trash = true,               -- 💡 중요: 파일 삭제 시 영구 삭제 대신 실제 OS '휴지통'으로 보내 안전하게 보호합니다.

      -- 2. 🌟 화면에 보여지는 요소 제어 (View)
      view_options = {
        show_hidden = true, -- .git, .gitignore 등 숨김 파일을 기본적으로 항상 보여줍니다.

        -- 아래 설정은 복잡한 바이너리나 컴파일된 폴더(.git 등)를 트리에서 은은하게 흐린 색으로 처리해 시야를 쾌적하게 만듭니다.
        is_ignored = function(name, _)
          return vim.startswith(name, ".git") or name == "node_modules"
        end,
      },

      -- 3. 🌟 창을 띄우는 스타일 (Floating 레이아웃 많이 씀)
      -- 왼쪽 사이드바인 neo-tree와 차별화를 두기 위해, 화면 중앙에 이쁜 팝업창으로 띄우는 레이아웃이 유저들 사이에서 대세입니다.
      -- 이제 - 키를 누르면 화면 전체가 바뀌는 게 아니라, 코딩하던 화면 위에 둥근 테두리의 이쁜 팝업 창이 정중앙에 톡 튀어나옵니다. 주변 소스 코드를 시야에 유지한 채 파일 조작이 가능해집니다.
      float = {
        padding = 3,
        max_width = 80,
        max_height = 0,
        border = "rounded", -- 테두리를 둥글고 부드럽게 처리
        win_options = {
          -- winblend = 4, -- 살짝 투명하게 만들어 뒤쪽 코드가 비치게 함
          winblend = 30,  -- 살짝 투명하게 만들어 뒤쪽 코드가 비치게 함
          -- 0(불투명) ~ 100(완전투명) -> 30 정도로 주면 뒤쪽 코드가 은은하게 보입니다.
        },
      },

      -- 4. 🌟 마우스보다 빠른 핵심 키맵 (Keymaps)
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",          -- Enter: 파일 열기 또는 폴더 진입
        ["q"] = "actions.close",              -- q: 탐색기 닫고 내 코딩 화면으로 복귀
        -- ["<Esc>"] = "actions.close",              -- <Esc>: 탐색기 닫고 내 코딩 화면으로 복귀
        ["-"] = "actions.parent",             -- -: 한 단계 상위 폴더로 이동

        -- 💡 고수들이 무조건 등록하는 미친 편의 기능 2가지
        ["<C-p>"] = "actions.preview",        -- Ctrl + p: 팝업창으로 파일 내용 미리보기 (열어보지 않고 소스 코드 확인 가능!)
        ["_"] = "actions.open_cwd",           -- 하이픈 아래바(_): 프로젝트의 최상위 루트(Root) 폴더로 한 번에 순간이동

        -- Telescope 와 동일하게 Ctrl+u (up), Ctrl+d (down) 으로 preview 스크립 보기
        -- 🔥 Oil 팝업창 안에서 커서를 움직이지 않고 
        -- 옆에 뜬 미리보기(Preview) 문서만 위아래로 슥슥 스크롤 하는 키맵!
        ["<C-u>"] = "actions.preview_scroll_up",
        ["<C-d>"] = "actions.preview_scroll_down",

        -- 🌟  Neovim 설정 폴더로 즉시 순간이동하는 단축키
        ["N"] = function()
          local config_path = vim.fn.stdpath("config")
          require("oil").open(config_path)
        end,



      },
    })

    -- 노멀 모드에서 '-' 키를 누르면 현재 파일이 있는 폴더가 oil 편집 화면으로 열립니다.
    -- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory in Oil" })
    -- 🌟 진입 단축키도 floating 창에 맞게 <CMD>Oil --float<CR> 로 업그레이드합니다.
    vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open Oil in Floating Window" })
  end,
}











-- vim: set foldmethod=marker foldmarker={{{,}}}:
