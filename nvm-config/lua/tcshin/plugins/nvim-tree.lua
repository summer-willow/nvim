-- -----------------------------
-- by stc
-- nvim-tree : file explorer
-- g?	도움말	사용 가능한 모든 단축키 목록을 띄웁니다.
-- H	숨김 파일 토글	.으로 시작하는 파일을 보이거나 숨깁니다.
--
--

return {
  'nvim-tree/nvim-tree.lua',
  version = '*', -- 최신 안정화 버전을 사용
  lazy = false, -- 시작할 때 바로 로드되도록 설정
  dependencies = 'nvim-tree/nvim-web-devicons', -- 파일 아이콘을 위한 필수 플러그인
  config = function()
    local nvimtree = require 'nvim-tree'

    -- recommended settings from nvim-tree documentation
    -- disable netrw
    -- nvim-tree와 충돌하지 않도록 하기 위해, netrw(Vim 내장 탐색기)를 완전히 꺼버리는 설정
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup {
      sort = {
        -- sorter = 'case_sensitive', -- 파일명을 대소문자 무시 정렬
        sorter = 'name', -- 파일명을 대소문자 무시 정렬
        -- "name": 파일 이름을 기준으로 정렬. (대소문자 구분 없이 알파벳순으로 보여줌)
      },
      view = {
        width = 30, -- 탐색기 너비, default=30
        side = 'left', -- 왼쪽 배치
        relativenumber = true,
      },
      -- change folder arrow icons
      renderer = {
        group_empty = true, -- 내용 없는 폴더 그룹화, 한 줄로 합쳐서 보여줌
        indent_markers = {
          enable = true, -- 폴더 구조를 한눈에 볼 수 있게 수직 점선을 그려줌
        },
        icons = {
          glyphs = {
            -- 폴더가 닫혔을 때()와 열렸을 때()의 화살표 기호를 직접 지정
            folder = {
              arrow_closed = '', -- arrow when folder is closed
              arrow_open = '', -- arrow when folder is open
            },
          },
          show = {
            -- Git 상태, 폴더 아이콘, 파일 아이콘을 모두 보여주도록 설정
            git = true,
            folder = true,
            file = true,
          },
        },
      },
      -- disable window_picker for explorer to work well with window splits
      actions = {
        open_file = {
          quit_on_open = true, -- 파일 열면 트리 닫기
          window_picker = {
            enable = false, -- 파일을 열 때 어느 창에 열지 묻는 '창 선택' 기능을 off
          },
        },
      },
      filters = { -- "무언가를 걸러내서 안 보이게 하겠다"는 뜻
        custom = { '.DS_Store' }, -- .DS_Store(맥용 설정파일) 같은 파일은 목록에서 숨김
        dotfiles = false, -- 숨김 파일(.) 표시하라
      },
      git = {
        ignore = false, -- .gitignore에 등록된 파일이라도 탐색기 목록에는 보여주도록 설정
      },
      -- 현재 편집 중인 파일에 맞춰 탐색기의 위치와 루트를 자동으로 동기화하는 설정
      update_focused_file = {
      enable = true,	-- 현재 열린 파일로 탐색기 포커스 자동 이동
      update_root = true,	-- 파일 위치에 맞춰 탐색기 상단 기준 폴더(Root)까지 강제 업데이트
      },
    }

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set('n', '<leader>ee', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' }) -- toggle file explorer
    keymap.set('n', '<leader>ef', '<cmd>NvimTreeFindFileToggle<CR>', { desc = 'Toggle file explorer on current file' }) -- toggle file explorer on current file
    keymap.set('n', '<leader>ec', '<cmd>NvimTreeCollapse<CR>', { desc = 'Collapse file explorer' }) -- collapse file explorer, 펼쳐진 모든 폴더를 한꺼번에 닫기
    keymap.set('n', '<leader>er', '<cmd>NvimTreeRefresh<CR>', { desc = 'Refresh filk explorer' }) -- refresh file explorer, 파일 목록을 새로고침
    --
    -- -- test
    -- vim.notify("nvim-tree 로드 완료!", "info", { title = "플러그인 상태" })
    -- -- end test
  end,
}
