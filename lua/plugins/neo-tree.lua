return {
  --[[

    -- 설정 폴더(config)를 neo-tree로 열기
    vim.keymap.set("n", "<leader>fc", function()
      local config_path = vim.fn.stdpath("config")
      vim.cmd("Neotree reveal dir=" .. config_path)
    end, { desc = "Neo-tree: [F]ind [C]onfig files" })

    ==> cf) kickstart.nvim에서 telescope를 이용해서 이미 제공하고 있음
    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })

  --]]

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
      -- 기본 탐색기(netrw)를 대신해서 neo-tree가 실행
      -- hijack_netrw_behavior = "open_default",
      -- oil.nvim와 기본 내장 탐색기의 주도권을 갖기위해 충돌하는 것을 막기 위해
      -- neo-tree의 주도권을 disable 시킴
      -- 🌟 Neo-tree가 기본 내장 탐색기를 가로채지 못하도록 완전히 끕니다!
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

  },

  -- 4. 실행 및 단축키 설정
  config = function(_, opts)
    -- 설정값을 적용하여 neo-tree 실행
    require("neo-tree").setup(opts)

    -- 탐색기를 열고 닫기(toggle) 
    vim.keymap.set(
      "n",
      -- "<leader>e",
      "<leader>ee",
      -- "<leader>te",
      -- "<leader>to",
      ":Neotree toggle<CR>",
      -- { desc = "Neo-tree [E]xplorer" }
      { desc = "Neo-tr[e]e [E]xplorer" }
      -- { desc = "Neo-[T]ree [E]xplorer" }
      -- { desc = "Neo-[T]ree [O]pen" }
    )

    -- 현재 파일 위치로 탐색기 포커스 맞추기 
    -- :Neotree reveal
    -- reveal: 현재 열려 있는 파일이 트리 어디에 있는지 찾아가서 보여주는 기능
    -- 만약 현재 파일 위치를 트리에서 못 찾고 있다면, 명령줄에 :Neotree reveal을 입력해 보세요. 트리가 해당 파일 위치로 이동합니다.
    -- vim.keymap.set("n", "<leader>fe", ":Neotree reveal<CR>", { desc = "Neo-tree [F]ocus [E]xplorer" })

    -- -----------------------------------
    -- 설정 폴더(config)를 neo-tree로 열기
    -- cf) :e $myvimrc  : open init.lua 
    -- :e vim.fn.stdpath('config')
    --
    -- vim.keymap.set("n", "<leader>fc", function()
    --   -- Neovim의 표준 설정 경로(Windows는 AppData/Local/nvim)를 가져옵니다.
    --   local config_path = vim.fn.stdpath("config")
    --
    --   -- reveal: neo-tree를 해당 경로로 열기 (reveal 옵션으로 해당 폴더를 트리 최상단으로)
    --   -- dir=...: Neovim 전체의 cd를 바꾸지 않고, 탐색기 창의 '기준점'만 설정 폴더로 고정합니다.
    --   vim.cmd("Neotree reveal dir=" .. config_path)
    -- end, { desc = "Neo-tree: [F]ind [C]onfig files" })
    -- -----------------------------------


  end,


}

