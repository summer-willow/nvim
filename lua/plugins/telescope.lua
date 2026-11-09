return {

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    -- By default, Telescope is included and acts as your picker for everything.

    -- If you would like to switch to a different picker (like snacks, or fzf-lua)
    -- you can disable the Telescope plugin by setting enabled to false and enable
    -- your replacement picker by requiring it explicitly (e.g. 'custom.plugins.snacks')

    -- Note: If you customize your config for yourself,
    -- it’s best to remove the Telescope plugin config entirely
    -- instead of just disabling it here, to keep your config clean.
    enabled = true,
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },

      -- LuaSnip 전용 Telescope 익스텐션, luasnip 스니펫 검색/조회
      -- 현재 파일 타입(예: tex, lua, markdown)에 해당하는 스니펫 목록을 대화형 탐색 창으로 한눈에 보고 검색할 수 있습니다.
      'benfowler/telescope-luasnip.nvim',

    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!


      -- ------------------------
      -- by stc
        -- <C-j/k>를 목록 아래/위 이동에 쓰기 위해서
      -- 필요한 부분
      -- local actions = require('telescope.actions') 추가: 
      -- Telescope 내부에서 목록을 위아래로 움직이는 제어 함수(move_selection_next, move_selection_previous)를 꺼내 쓰기 위해 모듈을 미리 로드.
      -- 
      local actions = require('telescope.actions')
      -- by stc, end
      -- ------------------------


      -- ---------------------------------------
      -- Telescope 실행 중에 '키 매핑'으로 즉시 전환하기
      -- "전체 검색 ↔ 현재 폴더 검색"을 왔다 갔다 스위칭하는 방식
      -- ---------------------------------------
      -- local telescope = require("telescope")
      local action_state = require("telescope.actions.state")
      -- local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")

      -- ---------------------------------------


      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- ------------------------------------
        -- by stc
        -- <C-j/k>를 목록 아래/위 이동에 쓴다

        -- -----------------------------------------------------------
        -- 핵심 설정 추가: 입력 모드(i)에서 Ctrl+j / Ctrl+k로 목록 이동
        -- -----------------------------------------------------------
        defaults = {

          -- ---------------------------------------
          -- telescope 창 내용 표시 방식
          -- ---------------------------------------
          -- 파일 이름과 확장자를 무조건 끝까지 보여주고, 앞의 경로는 창 크기에 맞춰 자동으로 줄여주는 설정
          --
          -- 두 가지 스타일 중 선택하기
          -- 1. filename_first 방식 (강력 추천)
          -- path_display = { "filename_first" }, 
          -- 표시 예시: blink.lua Appdata/Local/nvim/lua/plugins
          -- 장점: 파일 이름이 무조건 맨 앞에 나오기 때문에 화면이 아무리 작아도 파일명과 확장자가 절대 잘리지 않습니다. 최근 Neovim 유저들 사이에서 가장 선언되는 방식입니다.
          --
          -- 2. truncate 방식 (요청하신 스타일)
          -- path_display = { truncate = 3 },
          -- 표시 예시: ...local/nvim/lua/plugins/blink.lua
          -- 장점: 기존 경로 구조를 그대로 유지하면서, 창이 작아지면 앞부분을 고정된 숫자(예: 3개 폴더 뒤부터 표시 등)를 기준으로 생략해 줍니다.

          -- 파일 이름을 앞에 보여주고, 경로는 뒤에 흐릿하게/줄여서 표시하는 강력한 옵션
          path_display = { "filename_first" },
          -- 또는 기존 스타일을 유지하면서 앞을 자르고 싶다면 아래 주석을 풀고 사용하세요.
          -- path_display = { truncate = 3 },
          -- ---------------------------------------


          mappings = {
            i = { -- 입력 모드(Insert mode)일 때의 단축키
              ['<C-j>'] = actions.move_selection_next,     -- 아래 목록으로 이동
              ['<C-k>'] = actions.move_selection_previous, -- 위 목록으로 이동

              -- ---------------------------------------
              -- Telescope 실행 중에 '키 매핑'으로 즉시 전환하기
              -- "전체 검색 ↔ 현재 폴더 검색"을 왔다 갔다 스위칭하는 방식
              -- ---------------------------------------

              -- 검색 도중 Ctrl + y를 누르면 현재 파일 폴더로 즉시 재실행
              ["<C-y>"] = function(prompt_bufnr)
                -- 1. 현재 입력창에 타이핑된 검색어를 백업합니다.
                local current_picker = action_state.get_current_picker(prompt_bufnr)
                local text = current_picker:_get_prompt() 
                local current_file_dir = vim.fn.expand("%:h")

                -- 2. 현재 열려 있는 Telescope 검색창을 공식 API로 안전하게 닫습니다.
                actions.close(prompt_bufnr)

                -- 3. 현재 파일의 폴더를 cwd로 지정하여 find_files를 즉시 새로 엽니다.
                builtin.find_files({
                  cwd = current_file_dir,
                  prompt_title = "Find Files (Current Dir)",
                  default_text = text, -- 기존에 치고 있던 검색어를 그대로 이어받습니다.
                })
              end,

              -- ---------------------------------------
            },
          },
        },

        -- cf) preview window - scroll keymap
        -- default로 <C-u> (up), <C-d> (down)이 preview window 내용을 스크롤 한다.
        --
        -- by stc, end
        -- -----------------------------------------------------------
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- telescope-luasnip 로드
      pcall(require('telescope').load_extension, 'luasnip')

      -- 🚀 스니펫 탐색 키맵 등록 (<Leader>si 등), (search(s) snippet(i))
      vim.keymap.set("n", "<leader>si", "<cmd>Telescope luasnip<cr>", { desc = "Search Snippets" })

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })

      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      -- {{{ tip: Live Grep 결과 안에서 '텍스트'로 더 좁히고 싶을 때 (추천 팁)
      --
      -- Live Grep 결과 안에서 '텍스트'로 더 좁히고 싶을 때 (추천 팁)
      -- 프로젝트 전체에서 텍스트를 찾는 <leader>sg (Live Grep)의 경우, 결과가 너무 많으면 타이핑할 때 속도가 느려지거나 원하는 파일만 골라내기 힘들 수 있습니다.
      --
      -- 만약 '검색어로 1차 필터링된 결과' 안에서 특정 파일 이름이나 추가 단어로 정밀하게 더 좁히고 싶다면, Telescope 창이 열려 있는 상태(입력 모드)에서 다음 기본 내장 단축키를 활용해 보세요.
      --
      -- <C-space> (Ctrl + Space): 현재 입력한 검색어로 1차 고정(Freeze)을 시킨 후, 그 결과 안에서만 다시 검색할 수 있는 서브 프롬프트를 제공합니다. (Telescope 버전 및 환경에 따라 작동 여부에 차이가 있을 수 있습니다.)
      -- }}}

      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      -- {{{ Search Resume 활용 : <leader>sr
      -- Search Resume : 이미 한 번 검색된 결과(목록) 안에서 한 단계 더 필터링(검색 결과 내 재검색)을 하거나, 이전 검색 상태를 그대로 이어받아 원하는 대상을 더 정확하게 좁혀나가는 방법은
      -- 사용 방법:
      -- 방법 2 : 가장 추천하는 워크플로우는 무언가를 찾다가 놓쳤을 때 <leader>sr을 눌러 직전 검색을 소환한 뒤, 공백을 입력하고 키워드를 덧붙여 나가는 방식입니다.
      --
      --       방법 2:
      -- 1. <leader>sg (Live Grep) 등으로 광범위하게 1차 검색을 수행합니다.
      --
      -- 2. 원하는 결과가 바로 안 보여서 일단 <Esc>를 눌러 창을 닫거나 특정 파일로 이동합니다.
      --
      -- 3. 다시 <leader>sr을 누르면, 방금 전에 입력했던 검색어와 결과 목록이 그 상태 그대로 다시 열립니다.
      --
      -- 4. 거기서 글자를 더 추가하거나 수정하면서 원하는 목적지를 정확하게 찾으실 수 있습니다.
      -- }}}

      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- This runs on LSP attach per buffer (see main LSP attach function in 'neovim/nvim-lspconfig' config for more info,
      -- it is better explained there). This allows easily switching between pickers if you prefer using something else!
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf

          -- Find references for the word under your cursor.
          vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })

          -- Jump to the implementation of the word under your cursor.
          -- Useful when your language has ways of declaring types without an actual implementation.
          vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })

          -- Jump to the definition of the word under your cursor.
          -- This is where a variable was first declared, or where a function is defined, etc.
          -- To jump back, press <C-t>.
          vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })

          -- Fuzzy find all the symbols in your current document.
          -- Symbols are things like variables, functions, types, etc.
          vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })

          -- Fuzzy find all the symbols in your current workspace.
          -- Similar to document symbols, except searches over your entire project.
          vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })

          -- Jump to the type of the word under your cursor.
          -- Useful when you're not sure what type a variable is and you want to see
          -- the definition of its *type*, not where it was *defined*.
          vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
        end,
      })

      -- Override default behavior and theme when searching
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set(
        'n',
        '<leader>s/',
        function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        { desc = '[S]earch [/] in Open Files' }
      )

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
    end,
  },
}


