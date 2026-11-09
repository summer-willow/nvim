return {
  "stevearc/aerial.nvim",
  -- 파일을 직접 열 때만 플러그인을 로드하여 네오빔의 초기 시작 속도를 최적화합니다.
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- 마크다운, 레이텍(LaTeX) 문서 구조 분석을 위한 핵심 엔진
    "nvim-tree/nvim-web-devicons",     -- 목차 옆에 파일 및 심볼별 예쁜 아이콘을 표시하기 위한 플러그인
  },
  opts = {
    -- 1. 백엔드 및 필터링 설정
    -- 목차가 감지할 파일 타입 설정 (원하시는 md, tex 지정 및 가독성 최적화)
    -- 문서 구조 분석에 사용할 엔진 우선순위 (Treesitter와 LSP를 기반으로 마크다운 구조 분석)
    backends = { "treesitter", "lsp", "markdown", "man" },
    -- backends = { "lsp", "treesitter", "markdown", "man" },

    -- 목차 창에 어떤 요소(헤더, 함수, 클래스 등)를 추출해서 보여줄지 결정
    -- filter_kind = {
    --   "Class", "Constructor", "Enum", "Function", "Interface", "Method", "Module", "Struct",
    -- },
    -- [수정] 마크다운의 헤더 및 문서 구조를 안정적으로 추출할 수 있도록 종류를 확장합니다.
    -- Interface, Module, String 등은 마크다운 대형 제목/내용 분석 시 백엔드에 따라 매핑되는 심볼들입니다.
    filter_kind = {
      "Class", "Constructor", "Enum", "Function", "Interface", "Method",
      "Module", "Struct", "String", "Number", "Boolean", "Package",
    },
    -- [수정] 마크다운 헤딩 레벨이 매핑되는 심볼 종류들을 필터에 반드시 포함합니다.
    -- filter_kind = {
    --   "Class", "Constructor", "Enum", "Function", "Interface", "Method",
    --   "Module", "Struct", "String", "Number", "Boolean", "Package",
    --   "Constant", "Variable", -- 4~5레벨 헤딩 대응용 추가
    -- },

    -- -----------------------------------------------------------------
    -- 2-A. [사이드바 전용 설정] 일반 코딩/편집용 (<leader>aos 단축키가 사용하는 영역)
    -- -----------------------------------------------------------------
    layout = {
      max_width = { 40, 0.25 },    -- 사이드바의 최대 너비는 40칸 또는 에디터 화면의 25% 중 작은 값
      width = nil,                 -- 고정 너비를 해제하여 최소/최대 범위 내에서 유연하게 대처
      min_width = 30,              -- 목차 가독성을 위해 최소 30칸의 너비는 항상 유지
      default_direction = "right", -- 코딩 및 문서 작업 시 시야를 방해하지 않도록 우측에 배치
    },

    -- -----------------------------------------------------------------
    -- 2-B. [플로팅 팝업 전용 설정] 마크다운 문서 뼈대 조망용 (<leader>aof 단축키가 사용하는 영역)
    -- -----------------------------------------------------------------
    float = {
      relative = "editor", -- 팝업 창의 배치 기준점을 현재 분할 창이 아닌 에디터 전체 화면으로 고정

      -- [핵심 정공법] 플러그인이 플로팅 창을 그리기 직전에 가로채는 공식 네이티브 훅(Hook)
      -- 하단의 aerial.open({direction = "float"}) 기능이 실행될 때만 이 훅이 발동합니다.
      override = function(conf, source_winid)
        -- 위의 layout(30~40칸 제한) 설정을 완벽히 우회하고, 화면 대비 85% 대형 격자로 실시간 빌드합니다.
        conf.width = math.floor(vim.o.columns * 0.85)              -- 전체 화면 가로 폭의 85%
        conf.height = math.floor(vim.o.lines * 0.85)               -- 전체 화면 세로 높이의 85%
        conf.row = math.floor((vim.o.lines - conf.height) / 2) - 1 -- 화면 세로 축 기준 정중앙 정렬 좌표
        conf.col = math.floor((vim.o.columns - conf.width) / 2)    -- 화면 가로 축 기준 정중앙 정렬 좌표
        return conf                                                -- 보정된 커스텀 설정을 순정 엔진에 반환
      end,
    },

    -- -----------------------------------------------------------------
    -- 3. 자동화 트리거 및 상태 동기화
    -- -----------------------------------------------------------------
    -- "window" 모드: 아웃라인이 현재 커서가 위치한 분할 창(Window)의 버퍼 구조를 유연하게 추적함
    -- 아웃라인 데이터가 '개별 창(Window)'에 종속딤. 즉, 아웃라인은 현재 커서를 두고 있는 '창'이 바뀌면, 바뀐 창의 파일 구조로 바뀜.
    -- cf) "global" 모드: 아웃라인 데이터가 네오빔 전체에서 가장 마지막으로 활성화된 단 하나의 파일 버퍼에 고정
    attach_mode = "window",

    -- 목차에서 항목을 엔터(<CR>)로 선택해도 목차 창이 자동으로 닫히지 않고 유지되어 연속 탐색 가능
    close_on_select = false,

    -- 본문 내용을 수정하거나(TextChanged) 입력 모드를 빠져나올 때(InsertLeave) 실시간으로 목차 갱신
    update_events = "TextChanged,InsertLeave",

    -- -----------------------------------------------------------------
    -- 4. 문서(Markdown, LaTeX) 가독성 최적화
    -- -----------------------------------------------------------------
    show_trailing_blankline = false, -- 목차 창 맨 아래에 불필요한 빈 줄 표시 금지
    nerd_font = true,                -- 개발자 전용 가독성 아이콘 활성화

    -- -----------------------------------------------------------------
    -- 아웃라인 아이콘 커스텀 설정 (일반 코딩 언어용 기본값)
    -- -----------------------------------------------------------------
    icons = {

      -- ------------------
      -- 코딩용 심볼 스타일 
      -- ------------------
      -- 스타일 A: 미니멀 & 깔끔 (추천 🌟)
      -- Interface = "󰏚 ",  -- 또는 " " 이나 "# " 등 선호하는 모양으로 변경 가능
      -- Module    = "󰏗 ",  -- 또는 " "
      -- String    = "󰜎 ",  -- 텍스트성 심볼

      -- ------------------
      -- 스타일 B: 문서/텍스트 특화 스타일
      Interface = "󰧮 ", -- 리스트 포인트/체크 기호 느낌
      Module    = "󰈙 ", -- 문서/텍스트 파일 모양
      String    = "󰦨 ", -- 인용구 모양

      -- ------------------
      -- 필요한 경우 다른 심볼들도 함께 커스텀 가능합니다.
      Class     = "𝓒 ",
      Function  = "󰊕 ",
    },

    -- -----------------------------------------------------------------
    -- 5. 목차(Aerial) 창 내부 전용 단축키 매핑 (커서가 목차 창에 있을 때만 작동)
    -- -----------------------------------------------------------------
    keymaps = {
      ["?"] = "actions.show_help",        -- ? : 단축키 도움말 팝업 열기
      ["<CR>"] = "actions.jump",          -- Enter : 해당 헤더(위치)로 본문 커서 이동
      ["<2-LeftMouse>"] = "actions.jump", -- 마우스 더블클릭 : 해당 위치로 이동
      ["p"] = "actions.scroll",           -- p : 커서는 목차에 둔 채 본문 화면만 해당 위치로 스크롤 (미리보기)
      ["<C-v>"] = "actions.jump_vsplit",   -- Ctrl + v : 본문 창을 세로로 분할하며 해당 위치 열기
      ["<C-s>"] = "actions.jump_split",    -- Ctrl + s : 본문 창을 가로로 분할하며 해당 위치 열기
      ["{"] = "actions.prev",             -- { : 목차 창 내부에서 이전 헤더 항목으로 이동
      ["}"] = "actions.next",             -- } : 목차 창 내부에서 다음 헤더 항목으로 이동
      ["[["] = "actions.prev_up",         -- [[ : 현재 위치의 상위 레벨(부모 헤더)로 이동
      ["]]"] = "actions.next_up",         -- ]] : 다음 상위 레벨 헤더 항목으로 이동

      -- 아웃라인 창 안에서 아래 키들를 누르면 aerial 내부 액션인 'close'를 실행.
      -- 기본 q 키로도 닫히지만 <leader>aos/aof 키 연속성 확보
      -- 즉, 포커스가 본문이든 사이드바든 상관없이 열려 있으면 깔끔하게 닫기
      ["q"] = "actions.close",            -- q : 아웃라인 창을 닫고 원래 편집하던 본문 위치로 완전 복귀
      ["<leader>aos"] = "actions.close",
      ["<leader>aof"] = "actions.close",

    },
  },
  config = function(_, opts)
    -- 위에서 작성한 정교한 옵션 명세들을 가져와서 aerial 엔진 초기화
    require("aerial").setup(opts)

    -- -----------------------------------------------------------------
    -- 6. 네오빔 전역 단축키 바인딩 (본문 편집 중에 사용하는 키맵)
    -- -----------------------------------------------------------------

    -- vim.keymap.set("n", "<leader>aos", "<cmd>AerialToggle!<CR>", { desc = "Toggle [A]erial [O]utline [S]idebar" })
    -- ==> <cmd>AerialToggle!<CR>과 같은 단순 명령어 실행 방식은 플러그인의 기본 동작(사이드바를 켜고 끄기만 함)을 따르기 때문에 커서가 자동으로 이동하지 않는다.

    -- [사이드바 모드] <leader>aos : 코딩용 우측 고정 사이드바 완벽 토글 및 자동 포커스 이동
    vim.keymap.set('n', '<leader>aos', function()
      local aerial = require("aerial")
      if aerial.is_open() then
        aerial.close() -- 포커스가 본문이든 사이드바든 상관없이 열려 있으면 깔끔하게 닫기
      else
        aerial.open({ focus = true }) -- 닫혀 있다면 창을 열면서 커서(Focus)까지 즉시 진입
      end
    end, { silent = true, desc = "Toggle [A]erial [O]utline [S]idebar" })

    -- [플로팅 모드] <leader>aof : 마크다운 문서 뼈대 조망용 85% 대형 정중앙 팝업 창 토글
    vim.keymap.set('n', '<leader>aof', function()
      local aerial = require("aerial")
      if aerial.is_open() then
        aerial.close() -- 열려 있다면 즉시 닫기
      else
        -- direction = "float" 명세를 넘겨줌으로써 최상단의 'opts.float.override' 훅을 트리거합니다.
        aerial.open({ focus = true, direction = "float" })
      end
    end, { silent = true, desc = "Toggle [A]erial [O]utline [F]loat" })

    -- [본문 내 퀵 점프] 목차 창이 닫혀 있어도 본문에서 곧바로 이전/다음 헤더로 신속 이동
    vim.keymap.set("n", "[[", "<cmd>AerialPrev<CR>", { desc = "Aerial Previous Header" })
    vim.keymap.set("n", "]]", "<cmd>AerialNext<CR>", { desc = "Aerial Next Header" })

    -- [Telescope 연동] <leader>sa : 화면 중앙에 텔레스코프 전용 검색 창을 띄워 실시간 목차 실시간 검색
    vim.keymap.set("n", "<leader>sa", "<cmd>Telescope aerial<CR>", { desc = "Search Outline (Aerial)" })

  end,
}



-- vim: set foldmethod=marker foldmarker={{{,}}}:

