
return {

  -- 1. 플러그인 경로 및 버전 지정
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x", -- v3 대역의 최신 안정 버전을 사용 (현재 2026-04-25)

  -- 2. 보조 플러그인들 
  dependencies = {
    "nvim-lua/plenary.nvim",       -- 다양한 루아 함수 라이브러리
    "nvim-tree/nvim-web-devicons", -- 파일 옆에 예쁜 아이콘을 그려줌
    "MunifTanjim/nui.nvim",        -- UI 구성 요소 라이브러리
  },

  -- 3. 플러그인 세부 설정 (가장 대중적으로 많이 쓰이는 표준 설정)
  opts = {
    -- [창 UI 설정]
    window = {
      position = "left", -- 화면 왼쪽에서 나타남
      width = 30,        -- 탐색기 창의 가로 너비 (취향에 따라 30~40 사이 조절)
      mappings = {
        ["<space>"] = "none", -- 스페이스바가 기존 동작과(ex, <leader>) 충돌하지 않게 해제
      },

    },

    -- [파일 시스템 동작 설정]
    filesystem = {
      hijack_netrw_behavior = "disabled",

      follow_current_file = {
        -- 현재 편집 중인 파일이 위치한 곳으로 파일 트리가 열리게 함
        enabled = true,
        -- neo-tree가 현재 파일을 찾기 위해 펴쳐놓은 포더들을, 열린 상태로 둠
        leave_dirs_open = true, -- (기본값/추천)
      },

      -- Neovim 밖(윈도우 탐색기, git 추가/수정 상태 등)에서 파일을 지우거나 만들어도 neo-tree 화면에 즉시 반영됩니다.
      use_libuv_file_watcher = true, -- Neovim 밖에서의 파일 변경도 감지해서 반영

      -- .git 폴더나 설정 파일 등 숨김 파일 표시 여부
      filtered_items = {
        visible = true, -- 숨김 파일(.git 등)도 보이게 설정 (설정 파일 편집 시 편리)
        hide_dotfiles = false, -- 점(.)으로 시작하는 설정 파일들을 숨기지 않음
        hide_gitignored = false, -- .gitignore에 등록된 파일들도 보여줌
      },
    },

    -- [에러/경고 표시 설정] (LSP와 연동)
    diagnostics = {
      enable = true,      -- 코드에 에러가 있으면 트리 옆에 아이콘(x, !) 표시
      show_symbols = true,
    },

    -- ----------------------
    -- by stc
    -- document_symbols(아웃라인)  :
    -- 아웃라인 창 내에서 헤딩의 이름을 바꾸면 본문이 동기화되는 리팩토링 기능
   -- 아웃라인(구문 트리) 설정
    document_symbols = {
      keymaps = {
        -- 여기서 r 또는 e를 눌러 헤딩 이름을 수정하면 본문이 바뀝니다.
        ["r"] = "rename",
        ["a"] = "add",
      }
    },
    -- by stc, end
    -- ----------------------
  },

  -- 4. 실행 및 단축키 설정
  config = function(_, opts)
    -- 설정값을 적용하여 neo-tree 실행
    require("neo-tree").setup(opts)


    -- 탐색기를 열고 닫기(toggle) 
    vim.keymap.set(
      "n",
      -- "<leader>e",
      -- "<leader>te",
      "<leader>to",
      ":Neotree toggle<CR>",
      -- { desc = "Neo-tree [E]xplorer" }
      -- { desc = "Neo-[T]ree [E]xplorer" }
      { desc = "Neo-[T]ree [O]pen" }
    )


    -- -----------------------------------
    -- 필요할 때 아웃라인 창을 여는 키맵
    -- outline 창을 open (document_symbols 기능 이용) 
-- document_symbols: 현재 파일(버퍼) 내의 클래스, 함수, 변수, 헤딩 등 구조적 요소들의 목록
    -- 코드의 구조를 가질 수 있는 거의 모든 프로그래밍 언어와 마크업 언어를 지원
    --
    -- vim.keymap.set("n", "<leader>so", "<cmd>Neotree close<cr><cmd>Neotree document_symbols left<cr>", { desc = "Symbol Outline" })
    vim.keymap.set("n", "<leader>tl", "<cmd>Neotree close<cr><cmd>Neotree document_symbols left<cr>", { desc = "[T]ree out{L}ine (document_symbols))" })

  end,


}

