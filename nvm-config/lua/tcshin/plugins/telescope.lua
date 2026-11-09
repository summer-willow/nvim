-- --------------------------------------------
-- Telescope 표준 설정
-- --------------------------------------------
--
-- * Telescope 창에서 쓸 수 있는 모든 단축키 도움말 보기
--    Insert mode: <c-/>
--    Normal mode: ?
--
-- cf) Telescope 창도 결국 하나의 작은 "버퍼(창)"이기 때문에 일반적인 Vim의 규칙이 그대로 적용됨.
-- telescope 창 내에서 <Esc>를 누르면 normal mode가 되고, 여기서 필요한 동작을 하고, 다시 insert mode로 돌아가려면 i/a 를 이용.
--
-- <Esc> (또는 <C-c>)	Telescope 창 닫기
--

return {
  {
    "nvim-telescope/telescope.nvim",
    version = '*',  -- Git의 브랜치(Branch)가 아니라, 가장 최근에 발행된 안정적인 릴리스 태그(Release Tag)를 자동으로 선택
    event = 'VimEnter', -- Neovim이 완전히 켜진 직후 로드 (사용자 경험 향상)

    dependencies = {
      "nvim-lua/plenary.nvim", -- 공통 유틸리티 함수 (필수)
      { 
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make", -- 설치 시 C 코드를 컴파일하여 fzf 검색 속도를 극대화 (GnuWin32/Make 필요)
        cond = function()
          return vim.fn.executable 'make' == 1
        end,-- 시스템에 make가 있을 때만 설치 (방어적)
        -- make 설치 확인 : make --version
        -- make 설치 : scoop install make
      },

      -- 코드 액션/선택창을 Telescope UI로 바꿔주는 확장
      { "nvim-telescope/telescope-ui-select.nvim" },

      { 'nvim-telescope/telescope-ui-select.nvim' }, -- Neovim의 기본 선택창을 Telescope로 교체. LSP를 쓸 때 선택창이 훨씬 예뻐짐

      "nvim-tree/nvim-web-devicons", -- 파일 아이콘 표시용
      "rcarriga/nvim-notify", -- nvim-notify 연동 keymapping 을 위해서 필요
    },

    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")
      local themes = require("telescope.themes")

      telescope.setup({
        -- [Defaults] 모든 피커(picker)에 공통으로 적용되는 설정들
        -- cf) Telescope에서 find_files, live_grep, help_tags 같은 하나하나의 검색 도구들을 **Picker(피커)**라고 부릅니다.
        -- 기본 동작 및 외관 설정
        defaults = {
          -- 레이아웃 전략을 'horizontal'(가로 나열)로 강제 지정
          -- 창이 좁을 때 위아래로 쌓이는 'vertical' 모드로 변하는 것을 방지하고, 최대한 가로로 나란히 보여주도록 고정
          layout_strategy = "horizontal",

          -- 검색창의 모양과 미리보기 창의 배치를 설정
          layout_config = {
            horizontal = {
              -- Result 창과 Preview 창이 나란히 뜰 때의 설정
              preview_width = 0.5,      -- 전체 창 너비의 50%를 Preview에 할당
              results_width = 0.5,      -- 전체 창 너비의 50%를 Result에 할당
            },

            vertical = {
              mirror = false,
            },
            -- {{{
            -- Telescope의 창이 세로(Vertical) 레이아웃으로 표시될 때, 검색창과 미리보기창의 순서를 뒤집을지 결정하는 옵션
            -- when morror=false (default) :
            -- [preview 창] -> [Results 창] -> [Prompt 창] 순
            -- when mirror=true :
            -- [prompt 창] -> [Results 창] -> [Preview 창] 순
            -- }}}

            width = 0.95,               -- 터미널 전체 가로폭의 95% 사용
            height = 0.85,              -- 터미널 전체 세로폭의 85% 사용

            -- Preview 창이 나타나는 최소 기준(Cutoff)
            -- 터미널 가로 칸수가 이 숫자(cutoff)보다 작으면 Preview를 숨깁니다.
            -- 기본값이 120인데, 이를 60~80 정도로 낮추면 작은 창에서도 Preview가 보입니다.
            preview_cutoff = 60, 
          },

          -- 검색 결과 창에서 사용할 단축키
          mappings = {
            i = { -- Insert 모드일 때
              ["<C-j>"] = actions.move_selection_next, -- Ctrl+j로 다음 항목
              ["<C-k>"] = actions.move_selection_previous, -- Ctrl+k로 이전 항목
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist, -- 검색 결과를 Quickfix 리스트로 전송

              ['<c-enter>'] = 'to_fuzzy_refine',
              -- {{{
              -- 검색 결과가 너무 많을 때 "2차 필터링"을 하게 해주는 기능
              -- 검색 결과 안에서 다시 검색.
              -- 현재 리스트에 떠 있는 항목들만 따로 모아서 새로운 검색 세션을 시작
              -- 그 결과들 안에서 다시 타이핑하여 범위를 좁혀나가는 방식
              -- 검색 결과가 너무 많아서(예: 수천 개의 파일) 키워드 하나만으로는 도저히 원하는 것을 찾기 힘들 때, 단계를 나누어 필터링할 수 있게 해줍니다.
              -- }}}

            },
          },
        },


        -- {{{
        -- [pickers] 특정 picker 전용 설정
        -- Telescope에서 find_files, live_grep, help_tags 같은 하나하나의 검색 도구들을 **Picker(피커)**라고 부릅니다.
        -- pickers: 특정 picker만 커스터마이징하고 싶을 때 사용.
        -- defaults가 "모든 검색 창"에 적용되는 설정이라면, pickers는 "특정 검색 창에만" 개별 설정을 줄 때 사용
        --
        -- 예시: "다른 건 다 괜찮은데, find_files를 쓸 때만 미리보기 창을 끄고 싶어!"라고 한다면 다음과 같이 설정합니다.
        -- pickers = {
        --   find_files = {
        --     previewer = false, -- 파일 찾기에서만 미리보기 끔
        --     theme = "dropdown", -- 파일 찾기만 드롭다운 테마 사용
        --   }
        -- }
        -- }}}
        pickers = {},

        -- [Extensions] 확장 기능들의 상세 설정
        extensions = {
          -- fzf 확장 기능을 Telescope에 등록
          fzf = {
            fuzzy = true,                   -- 퍼지 검색 활성화
            override_generic_sorter = true, -- 일반 소터 덮어쓰기
            override_file_sorter = true,    -- 파일 소터 덮어쓰기
            case_mode = "smart_case",       -- 대소문자 구분 (스마트 케이스)
          },

          -- ui-select를 드롭다운 테마로 설정
          ['ui-select'] = {
            themes.get_dropdown(),
            -- require('telescope.themes').get_dropdown(), -- ui-select를 드롭다운 테마로 설정
          },
          -- 이걸 설정하면 나중에 LSP가 "이 코드 어떻게 고칠까요?"라고 물어볼 때 화면 하단이 아니라 화면 중앙에 예쁜 Telescope 창이 뜹니다

        },
      })

      -- [Extension Loading] extension을 안전하게 로드
      -- telescope.load_extension("fzf")
      pcall(telescope.load_extension, "fzf") -- fzf 확장을 실제로 로드
      pcall(telescope.load_extension, "ui-select")
      pcall(telescope.load_extension, "notify")

      local keymap = vim.keymap

      -- 파일 찾기: 프로젝트 내의 모든 파일 검색
      keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope Find Files" })
      
      -- 실시간 검색: 파일 내용 속의 단어를 실시간으로 검색 (Live Grep)
      keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope Live Grep" })
      
      -- 버퍼 검색: 현재 열려 있는 파일들 목록 검색
      keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope Buffers" })
      
      -- 도움말 검색: Neovim 내장 도움말 문서 검색
      keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope Help Tags" })
      
      -- 최근 파일: 내가 최근에 열었던 파일 목록 검색
      keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Telescope Recent Files" })

      -- Treesitter 심볼: 현재 파일의 함수, 변수 목록 검색 (Treesitter 연동)
      keymap.set("n", "<leader>ft", builtin.treesitter, { desc = "Telescope Treesitter Symbols" })


      -- cf) Kickstart.nvim에서 가져온 강력한 추가 기능들
      
      -- [Resume]: 방금 전 검색했던 결과와 검색어를 그대로 다시 열기
      keymap.set("n", "<leader>f.", builtin.resume, { desc = "[S]earch [R]esume" })

      -- [/]: 현재 버퍼(파일) 안에서만 퍼지 검색 (드롭다운 테마 적용)
      keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(themes.get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      -- [Grep Open Files]: 현재 열려 있는 모든 버퍼들 안에서 단어 검색
      keymap.set("n", "<leader>f/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "[S]earch [/] in Open Files" })


      -- [Search Neovim]: 내 설정 파일(nvim 폴더, 'config' ) 내의 파일들을 즉시 검색
      keymap.set("n", "<leader>fc", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[S]earch [N]eovim files" })


      -- 현재 내 Neovim에서 사용 가능한 모든 단축키 검색
      -- {{{
      -- 전체 단축키 검색: 내가 직접 설정한 단축키뿐만 아니라, 설치된 플러그인들이 자동으로 등록한 단축키, 그리고 Neovim의 순정 단축키를 모두 모아서 보여줌
      -- desc 값을 기반으로 검색
      -- 즉시 실행: 목록에서 원하는 단축키를 찾고 <Cr>를 누르면, 해당 단축키를 실제로 누른 것과 똑같이 그 기능이 바로 실행됨
      -- 활용: 
      -- 단축키가 기억 안 날 때: "아... 아까 설정한 알림 히스토리 단축키가 <leader>fn이었나? <leader>fh였나?" 헷갈릴 때 <leader>fk를 누르고 notify라고 검색하면 바로 나옵니다.
      -- 단축키 충돌 확인
      -- }}}
      keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })


      -- {{{
      -- builtin.builtin : Telescope의 모든 기능을 보여주는 마스터 메뉴
      --
      -- Telescope 기능의 카탈로그: 현재 사용 가능한 모든 Telescope 내장 함수(Pickers)의 목록을 보여줍니다.
      -- 확장 기능(Extensions) 포함: fzf, notify, ui-select 같은 확장 기능들도 이 목록에서 찾아 실행할 수 있습니다.
      --
      -- 💡 언제 사용하면 유용할까요?
      -- 단축키를 안 만든 기능을 써야 할 때: 가끔씩만 사용하는 기능(예: spell_suggest - 맞춤법 제안, colorscheme - 테마 변경 등)을 쓰고 싶을 때 사용합니다.
      -- Telescope 기능 탐색: Telescope에 어떤 기능들이 있는지 쭉 훑어보고 싶을 때 유용합니다.
      -- 설정 확인: 내가 설치한 확장 프로그램들이 Telescope에 제대로 등록되었는지 확인할 때 사용합니다.
      --
      -- 🛠️ 사용 시나리오
      -- **<leader>ss**를 누릅니다.
      -- Telescope 창에 find_files, live_grep, help_tags 등 우리가 이미 단축키로 만든 것들부터 시작해서 수많은 목록이 뜹니다.
      -- 여기서 commands라고 입력해 봅니다.
      -- 엔터를 치면 Neovim에서 실행 가능한 모든 명령어(:) 목록이 Telescope 창으로 다시 뜹니다.
      -- }}}
      vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })


      -- {{{
      -- builtin.grep_string : 현재 단어 즉시 검색
      -- 커서가 올라가 있는 단어를 그대로 검색어로 사용하여 프로젝트 전체에서 찾아줍니다.
      --
      -- 💡 언제 사용하면 가장 유용한가요?
      -- 변수 사용처 추적: "이 my_variable이라는 변수가 이 파일 말고 다른 파일 어디어디에서 쓰이고 있지?" 궁금할 때 변수 위에 커서를 두고 바로 누르면 됩니다.
      -- 함수 호출 확인: 특정 함수를 호출하는 모든 곳을 찾아서 한꺼번에 수정하거나 로직을 파악해야 할 때 유용합니다.
      -- 코드 탐색: live_grep(<leader>fg)처럼 타이핑할 필요가 없어서 검색 속도가 훨씬 빠릅니다.
      -- }}}
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[S]earch current [W]ord' })


      -- {{{
      -- 🔍 builtin.diagnostics의 핵심 기능
      -- 에러/경고 한눈에 보기: 현재 작성 중인 코드의 문법 오류(Error), 권장하지 않는 방식(Warning), 단순 정보(Info), 힌트(Hint)를 모두 모아서 보여줍니다.
      -- 프로젝트 전체 진단: 현재 열려 있는 파일뿐만 아니라, 열려 있는 모든 버퍼(문서)에서 발생한 에러들을 한꺼번에 리스트로 만들어줍니다.
      -- 필터링 및 이동: 수많은 경고 중에서 특정 에러만 검색해서 찾고, 엔터를 누르면 해당 에러가 발생한 정확한 코드 줄로 이동합니다.
      --
      -- 💡 언제 사용하면 가장 유용한가요?
      -- 빌드 전 에러 체크: 코드를 다 짜고 저장하기 전에, 내가 놓친 오타나 문법 에러가 다른 파일에 남아있는지 확인할 때 유용합니다.
      -- 대규모 수정 후 여파 확인: 변수 이름을 하나 바꿨는데, 그 영향으로 다른 파일들에서 에러가 터져 나올 때 그 에러들을 하나하나 찾아다니지 않고 이 리스트를 보며 하나씩 해결할 수 있습니다.
      -- 코드 퀄리티 관리: 에러는 아니지만 'Warning(경고)'으로 뜨는 비효율적인 코드들을 찾아 개선할 때 좋습니다.
      -- }}}
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })


      -- view notifications-history (using nvim-notify)
      -- Notify 연동
      keymap.set("n", "<leader>fn", function()
        require("telescope").extensions.notify.notify()
      end, { desc = "알림 기록 검색" })
      -- cf) 명령어 방식으로 keymapping 가능
      -- keymap.set("n", "<leader>fn", "<cmd>Telescope notify<cr>", { desc = "알림 기록 검색" })

      -- -- test
      -- vim.notify("telescope 로드 완료!", "info", { title = "플러그인 상태" })
      -- -- end test
    end,
  },
}

