return {
  "stevearc/aerial.nvim",
  event = { "BufReadPost", "BufNewFile" }, -- 파일을 열 때 지연 로딩하여 시작 속도 최적화
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- 마크다운, 텍스트 구조 분석용 필수 엔진, (treesitter 쓰면 레이아웃이 더 정확해짐)
    "nvim-tree/nvim-web-devicons",     -- 목차 옆에 예쁜 아이콘을 띄우기 위한 플러그인
  },
  opts = {
    -- 1. 목차가 감지할 파일 타입 설정 (원하시는 md, tex 지정 및 가독성 최적화)
    -- 파일 형식별로 무엇을 트리 구조에 보여줄지 세부 설정 
    -- backends = { "treesitter", "markdown", "man" },
    backends = { "treesitter", "lsp", "markdown", "man" },


    filter_kind = {
      "Class", "Constructor", "Enum", "Function", "Interface", "Method", "Module", "Struct",
      -- 마크다운/텍스트 문서를 위해 헤더(Interface, Module 등으로도 매핑됨) 활성화
    },

    -- -----------------------------------------------------
    -- 2. 레이아웃 및 윈도우 설정 (가장 인기 있는 우측 고정 사이드바 형식으로 복구)
    -- -----------------------------------------------------
    layout = {
      max_width = { 40, 0.25 }, -- 최대 가로 크기는 40칸 혹은 화면의 25%
      width = nil,
      min_width = 30,           -- 최소 가로 크기 30칸 유지
      default_direction = "right", -- 코딩/문서 작업 시 시야를 가리지 않게 우측에 배치
    },

    -- -----------------------------------------------------

    -- 3. 유용한 자동화 트리거 기능 (대중적인 필수 활성화 옵션)
    -- attach_mode = "window",  -- 아웃라인 데이터가 '개별 창(Window)'에 종속딤. 즉, 아웃라인은 현재 커서를 두고 있는 '창'의 파일 구조를 따라감.
    attach_mode = "global",   -- 아웃라인 데이터가 네오빔 전체에서 가장 마지막으로 aerial이 활성화(Attach)된 단 하나의 파일 버퍼에 고정.


    close_on_select = false,     -- 목차에서 항목을 엔터로 선택해도 목차 창이 닫히지 않고 유지됨
    update_events = "TextChanged,InsertLeave", -- 글을 작성하거나 수정하면 실시간으로 목차 갱신

    -- 4. 문서(md, tex) 전용 가독성 옵션
    show_trailing_blankline = false,
    nerd_font = true, -- Nerd Font 아이콘 사용 활성화

    -- 5. 목차(Aerial) 창 내부에서 사용할 전용 단축키 매핑 (직관적인 디폴트)
    -- (커서가 목차에 있을 때만 작동)
    keymaps = {
      ["?"] = "actions.show_help",
      ["<CR>"] = "actions.jump",        -- 엔터: 해당 목차 위치로 본문 커서 이동
      ["<2-LeftMouse>"] = "actions.jump", -- 마우스 더블클릭: 해당 위치 이동
      ["p"] = "actions.scroll",         -- p: 본문을 해당 목차 위치로 스크롤하되, 커서는 목차에 유지 (미리보기 용도)
      ["<C-v>"] = "actions.jump_vsplit", -- 세로 분할로 열기
      ["<C-s>"] = "actions.jump_split",  -- 가로 분할로 열기
      ["{"] = "actions.prev",           -- 이전 목차로 이동
      ["}"] = "actions.next",           -- 다음 목차로 이동
      ["[["] = "actions.prev_up",       -- 부모(상위 레벨) 목차로 이동
      ["]]"] = "actions.next_up",       -- 다음 상위 레벨 목차로 이동
      ["q"] = "actions.close",          -- q: 아웃라인 창 닫고 원래 본문으로 복귀
    },
  },
  config = function(_, opts)
    require("aerial").setup(opts)

    -- 6. 전역 단축키 바인딩 (가장 직관적이고 인기 있는 키 구조)
    -- -----------------------------------------------------
    -- [수정 부분] <leader>ao : 일반적인 코딩/편집용 우측 고정 사이드바 토글
    -- -----------------------------------------------------
    vim.keymap.set("n", "<leader>ao", "<cmd>AerialToggle!<CR>", { desc = "Toggle [A]erial [O]utline Sidebar (Right)" })

    -- -----------------------------------------------------
    -- [추가 부분] <leader>mh : 문서의 전체 뼈대를 감상하기 위한 정중앙 전체화면 플로팅 뷰 토글
    -- -----------------------------------------------------
    vim.keymap.set('n', '<leader>mh', function()
      local aerial = require("aerial")
      if aerial.is_open() then
        aerial.close() -- 이미 열려 있다면 닫기
      else
        -- 네오빔 전체 편집 화면의 실제 가로/세로 격자 크기를 가져옵니다.
        local total_width = vim.o.columns
        local total_height = vim.o.lines

        -- 전체 화면 대비 대형 95% 팝업 크기를 계산합니다.
        local win_width = math.floor(total_width * 0.95)
        local win_height = math.floor(total_height * 0.95)

        -- 가로/세로 완전히 정중앙에 위치시키기 위한 격자 시작 좌표 연산
        local row_pos = math.floor((total_height - win_height) / 2) - 1
        local col_pos = math.floor((total_width - win_width) / 2)

        -- 계산된 95% 정중앙 좌표를 들고 플로팅 모드로 창을 강제 오버라이드하여 엽니다.
        aerial.open({
          focus = true,
          direction = "float",
          opts = {
            win_opts = {
              relative = "editor",
              row = row_pos,
              col = col_pos,
              width = win_width,
              height = win_height,
            }
          }
        })
      end
    end, { silent = true, desc = 'Markdown 문서 뼈대 정중앙 전체화면 보기' })

    -- 본문 이동 단축키 유지
    -- { , } 단축키로 목차 창이 닫혀있어도 본문에서 바로 이전/다음 헤더로 점프할 수 있습니다. (문서 편집 생산성 극대화)
    -- vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { desc = "Aerial Previous Header" })
    -- vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { desc = "Aerial Next Header" })
    -- 3. 본문 내 퀵 점프 (Vim 순정 { } 문단 이동을 지키기 위해 [[ ]] 로 변경)
    vim.keymap.set("n", "[[", "<cmd>AerialPrev<CR>", { desc = "Aerial Previous Header" })
    vim.keymap.set("n", "]]", "<cmd>AerialNext<CR>", { desc = "Aerial Next Header" })


    -- Telescope 연동 단축키 매핑 변경
    -- Telescope 검색 검색: 일반 모드에서 <leader>sa (Search Aerial Outline)를 누르면 화면 중앙에 팝업 창이 뜨며 전체 목차를 검색할 수 있습니다.
    vim.keymap.set("n", "<leader>sa", "<cmd>Telescope aerial<CR>", { desc = "Search Outline (Aerial)" })


  end,
}
-- vim: set foldmethod=marker foldmarker={{{,}}}:
