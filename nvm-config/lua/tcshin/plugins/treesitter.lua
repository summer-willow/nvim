
return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- See `:help nvim-treesitter`

    -- v1.0.0 이상의 최신 기능과 안정성을 위해 공식 메인 브랜치 사용
    branch = "main",

    -- {{{
    -- Treesitter는 하이라이트, 폴딩, 인덴트의 핵심 엔진이므로 
    -- 지연 로딩(Lazy) 대신 시작 시 즉시 로드(false)하여 안정성을 확보함
    -- }}}
    lazy = false, -- nvim이 시작할 때, 바로 load

    -- 플러그인 업데이트 시 파서(Parser)들도 최신 버전으로 자동 컴파일
    build = ":TSUpdate", -- 설치/업데이트 시 파서 자동 갱신

    -- dependencies = {
      -- 아래의 'nvim-treesitter/nvim-treesitter-textobjects', 의 전체 부분이 있었는데, 독립 module로 분리 시킴
    -- }

    opts = {

      -- {{{
      -- [파서 자동 설치 목록]
      -- 아래 리스트에 적힌 언어들은 Neovim 시작 시 설치 여부를 확인하고 없으면 자동 설치함
      --
      -- :TSUpdate ==> ensure_installed에 적힌 모든 언어가 설치됨
      -- 
      -- 만약 원하는 parser가 설치가 안되어 있다면, 
      -- :TSInstall, :TSUninstall, :TSUpdate 등을 적절히 이용해서 설치할 것.
      -- }}}
      ensure_installed = { 
        -- 기본
        "c", "cpp", "lua", "vim", "vimdoc", "query", 
        -- 웹 / 스크립트
        "javascript", "typescript", "html", "css", "python", "bash",
        -- 문서 및 설정
        "markdown", "markdown_inline", "json", "yaml", "toml",
        -- 기타 유틸리티
        "diff", "luadoc", "printf", "regex"
      },

      -- {{{
      -- [자동 설치 활성화]
      -- 목록에 없는 언어 파일을 열었을 때 자동으로 파서 설치 여부
      -- ensure_installed에 없더라도 새로운 종류의 파일을 열면 
      -- Treesitter가 자동으로 해당 파서를 감지하고 설치를 시도함
      -- }}}
      auto_install = true,

      -- [하이라이트 설정]
      highlight = {
        enable = true, -- 하이라이트 기능 활성화, Treesitter 구문 분석 기반 색상 적용
        -- additional_vim_regex_highlighting = false,
        additional_vim_regex_highlighting = { 'ruby' },
        -- {{{
        -- additional_vim_regex_highlighting 설정의 차이
        -- false (기본값): Vim의 옛날 방식(정규표현식)을 완전히 끄고, 100% Treesitter 분석 결과만 사용합니다. 성능이 빠르고 깔끔합니다.
        --
        -- { 'ruby' }: Ruby 같은 언어는 문법이 매우 복잡하여, 가끔 Treesitter가 모든 색상을 다 잡아내지 못할 때가 있습니다. 이때 Vim의 기존 하이라이트 규칙을 보조적으로 덧칠하는 것입니다.
        --
        -- 결과: Ruby 파일에서 색상이 더 풍성해지지만, 성능은 약간 느려질 수 있습니다. Kickstart에서 Ruby를 예로 든 이유는 Ruby의 문법 구조가 유독 까다롭기 때문입니다.
        -- }}}
      },

      -- {{{
      -- [들여쓰기(Indent) 기능 활성화]
      -- 문법 구조를 분석하여 코드가 다음 줄로 넘어갈 때 정확한 위치를 잡아줌 (실험적 기능)
      -- indent = { enable = true },  -- indent 기능 활성화
      -- 특정 언어에서 Treesitter 들여쓰기가 오작동할 경우 제외 설정
      -- }}}
      indent = { enable = true, disable = { 'ruby' } },
      -- {{{
      -- indent 설정의 차이
      -- enable = true: 모든 언어에서 Treesitter가 계산한 스마트한 들여쓰기를 사용합니다.
      --
      -- disable = { 'ruby' }: "다른 건 다 좋은데 Ruby 파일에서는 Treesitter가 들여쓰기를 자꾸 이상하게 하네?" 싶을 때 해당 언어만 Treesitter 들여쓰기 기능을 끄는 것입니다.
      --
      -- 결과: Ruby 파일에서는 Vim 기본 들여쓰기 엔진이 작동하게 됩니다.
      -- }}}

    },

    config = function(_, opts)

      -- ----------------------
      -- {{{
      -- [파서 설치 경로 고정]
      -- 파서가 설치될 경로를 명시적으로 지정합니다.
      -- vim.fn.stdpath("data")는 보통 AppData/Local/nvim-data를 가리킴
      -- cf) [parser 설치 경로]를 꼭 할 필요는 없다. 여기서는 단지 이렇게 설치 경로를 명시적으로 할 수 있다는 것을 알리기 위해서 설정한 것이다.
      -- 그럼 config = function() 내의 parser 설치 경로에 관한 설정도 필요없고, 설정이 간단해진다.
      -- }}}
      -- install_dir = vim.fn.stdpath("data") .. "/site",
      local install_dir = vim.fn.stdpath("data") .. "/site"
      -- ----------------------

      -- ----------------------
      -- parser 설치 경로 관련 설정
      -- {{{
      -- 1. Neovim에게 "앞으로 모든 파서는 여기서만 찾아라"라고 강하게 명령
      -- Telescope 와 연동을 휘해 Parser나 Query 파일의 경로 명시
      -- 
      -- Telescope와 연동해서 사용하려 할 때, 
      -- ex) keymap.set("n", "<leader>fs", builtin.treesitter, { desc = "Telescope Treesitter Symbols" })
      -- Telescope는 기본 경로(stdpath("data"))에서만 쿼리 파일을 찾으려 함으로
      -- 위에서 install_dir을 이용해 수동으로 지정한 parser나 query 파일의 경로를
      -- Neovim의 전체 탐색 경로(runtimepath)에 추가 해야 telescope에서 treesitter의 parser/query 정보를 제대로 접근할 수 있다.
      --
      -- [추가] 수동 설치 경로를 runtimepath에 추가하여 Telescope가 찾을 수 있게 함
      -- }}}
      -- local parser_install_dir = vim.fn.stdpath("data") .. "/site"
      -- vim.opt.runtimepath:prepend(parser_install_dir)
      -- vim.opt.runtimepath:prepend(opts.install_dir)
      vim.opt.runtimepath:prepend(install_dir)

      -- 2. 설치 모듈에게도 수동 경로를 명시적으로 전달
      -- require("nvim-treesitter.install").outer_cache_dir = opts.install_dir
      require("nvim-treesitter.install").outer_cache_dir = install_dir
      -- ----------------------

      require("nvim-treesitter").setup(opts)

      -- -- ----------------------
      -- -- {{{
      -- -- ----------------------
      -- -- [코드 접기(Folding) 설정]
      -- -- Neovim 본체의 접기 기능을 Treesitter 엔진과 연결함
      -- --
      -- -- cf) 나중에 nvim-ufo 설치 시, 제거해야 함.
      -- -- 이유: nvim-ufo는 내부적으로 Treesitter 파서를 직접 활용하여 더 고성능의 접기를 제공합니다. nvim-ufo가 스스로 최적의 접기 방식을 제어하도록 내버려 두는 것이 가장 깔끔하게 작동합니다.
      -- --
      -- -- Neovim의 접기 방식을 '계산식(expr)'으로 설정
      -- -- }}}
      --
      --
      -- -- vim.opt.foldmethod = "expr"
      -- -- -- Treesitter가 계산해주는 함수를 Vim의 접기 공식으로 할당함
      -- -- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      -- -- -- 파일을 열었을 때 모든 코드가 접혀있지 않고 다 펴진 상태(Level 99)로 시작하게 함
      -- -- vim.opt.foldlevel = 99
      --
      -- -- [추가] 모든 버퍼에서 Treesitter 접기 강제 활성화
      -- -- Neovim이 파일을 열 때(FileType 이벤트) 실행됩니다.
      -- vim.api.nvim_create_autocmd("FileType", {
      --     pattern = { "c", "cpp", "lua", "python" }, -- 필요한 언어 추가
      --     callback = function()
      --         -- Treesitter를 이용해 접기를 수행하도록 설정
      --         vim.opt_local.foldmethod = "expr"
      --         vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      --         -- 파일을 열었을 때 모든 접기를 펼쳐둔 상태로 시작 (취향껏 조절)
      --         vim.opt_local.foldlevel = 99
      --     end,
      -- })
      -- ====> ~~/config/autocmds.lua 로 옮김.
      -- -- ----------------------


      -- -- test
      -- vim.notify("nvim-treesitter 로드 완료!", "info", { title = "플러그인 상태" })
      -- -- end test



    end,
  },

  -- 위의 dependencies를 아래 모듈로 이동시킴
  {
    -- {{{
    -- ② nvim-treesitter-textobjects (텍스트 오브젝트)
    -- 기능: Vim의 기본 동작(diw - 단어 삭제 등)을 함수 단위, 매개변수 단위로 확장합니다.
    -- 예: dif (Delete In Function) - 함수 내용만 싹 지우기.
    -- 예: vaf (Visual Around Function) - 함수 전체를 비주얼 모드로 잡기.
    -- 사용 이유: "마우스 없이" 코드 구조를 통째로 옮기거나 지울 때 혁명적으로 빠릅니다.
    -- }}}
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',  -- 부모와 브랜치를 맞춤

    -- 추가
    event = "VeryLazy",
    -- {{{
    -- (VeryLazy): Neovim UI가 먼저 뜨고 나서, 내부적인 초기화가 모두 끝난 후(한가해졌을 때) 배경에서 로드합니다.
    -- 결과: 사용자님의 경우 부모(nvim-treesitter)가 lazy = false이므로 핵심 엔진은 먼저 뜨고, 확장 기능인 textobjects는 약간 뒤에 로드되게 됩니다. 이 짧은 시차 덕분에 부모-자식 간의 로딩 순서 꼬임 에러를 방지할 수 있습니다.
    -- 없을 때 (Immediate): Neovim이 시작될 때 즉시 플러그인 파일을 읽고 로드합니다. 플러그인이 많아지면 시작 속도가 느려집니다.
    -- }}}

    init = function()
      -- {{{
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      -- init vs config 차이점
      -- init은 플러그인이 로드되기 전, config는 로드된 후 실행됩니다.
      --
      -- init : 플러그인이 로드되기 전에 (설치 폴더를 읽기도 전) 실행됨 : Neovim 전역 변수 설정(vim.g.xxx), 사전 환경 설정 에 사용
      -- config : 플러그인이 로드된 직후에 실행됨 : 플러그인의 setup() 함수 호출, 실제 단축키 매핑에 사용
      -- 차이점: init에 쓴 코드는 플러그인 파일 자체가 메모리에 올라가기 전에도 실행됩니다. 반면 config는 플러그인 코드가 준비되어야만 실행 가능합니다.
      -- }}}

      -- {{{
      -- Neovim 기본 내장 단축키들과의 충돌을 원천 차단
      -- Neovim은 기본적으로 각 언어별 설정(ftplugin)을 내장하고 있으며, 이들이 멋대로 단축키를 만들기도 합니다.
      -- [충돌 방지] Neovim 기본 내장 ftplugin 단축키를 비활성화하여 
      -- textobjects 단축키와 겹치지 않게 합니다.
      -- }}}
      vim.g.no_plugin_maps = true -- Neovim 기본 내장 단축키들과의 충돌을 원천 차단

      -- {{{
      -- 개별 설정 : 모든 언어를 끄는 대신 특정 언어만 골라 끄고 싶을 때 사용
      -- Or, disable per filetype (add as you like)
      -- vim.g.no_python_maps = true
      -- vim.g.no_ruby_maps = true
      -- vim.g.no_rust_maps = true
      -- vim.g.no_go_maps = true
      -- }}}
    end,
    config = function()
      -- ------------------------------
      -- keymap 정리
      -- -- select
      -- am : select, select_textobject, @function.outer
      -- im : select, select_textobject, @funcion.inner
      -- ac : select, select_textobject, @class.outer
      -- ic : select, select_textobject, @class.inner
      -- as : select, select_textobject, @local.scope
      --
      -- -- move
      -- ]m : move, goto_next_start, @function.outer
      -- ]M : move, goto_next_end, @function.outer
      -- [m : move, goto_previous_start, @function.outer
      -- [M : move, goto_previous_end, @function.outer
      --
      -- ]] : move, goto_next_start, @class.outer
      -- ][ : move, gotto_next_end, @class.outer
      -- [[ : move. goto_previous_start, @class.outer
      -- [] : move, goto_previous_end, @class.outer
      --
      -- ]o : move, goto_next_start, @loop.inner
      -- ]s : move, goto_next_start, @local.scope, locals
      -- ]z : move, goto_next_start, @fold, folds
      --
      -- ]d : move, goto_next, @conditional.outer
      -- [d : move, goto_previous, @conditional.outer
      -- ------------------------------

      -- -------------------------------
      -- Text objects: select
      -- Define your own text objects mappings similar to ip (inner paragraph) and ap (a paragraph).
      -- -------------------------------
      -- 플러그인 본체에 최소한의 옵션만 전달 (자동 점프 기능만 활성화)
      require('nvim-treesitter-textobjects').setup {
        select = {
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
--           -- 커서가 대상(함수 등) 위에 없어도 다음 대상을 찾아서 선택해주는 똑똑한 기능
          -- lookahead = true: 커서가 현재 함수(또는 클래스) 위에 있지 않더라도, 단축키(vam 등)를 누르면 가장 가까운 다음 함수를 자동으로 찾아가서(Jump forward) 선택하라는 뜻입니다.
          --
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            -- ['@class.outer'] = '<c-v>', -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true of false
          include_surrounding_whitespace = false,
        },
      }

      -- {{{
      -- "수동 제어" 방식
      -- 사용자가 직접 Lua 함수를 호출하여 단축키를 수동으로 매핑

      -- 기존의 '자동 설정' 방식이 아닌, '수동 명령' 방식을 택했기 때문에 Windows 환경이나 최신 브랜치에서도 흔들림 없이 작동
      -- }}}

      -- {{{
      -- 💡 참고: 단축키가 am, im으로 바뀌었습니다!
      -- 사용자님이 가져오신 코드에서는 기존의 af, if 대신 am, im (Around Method, Inner Method)을 사용하고 있습니다.
      --
      -- 함수 전체 선택: vam
      --
      -- 함수 내부 선택: vim (Vim의 기본 'inner 모드'와 이름이 같아 헷갈릴 수 있으니 주의하세요!)
      --
      -- 함수 삭제: dam
      --
      -- 이제 ]m으로 휙휙 이동하고, vam으로 함수를 덩어리째 잡는 쾌감을 느껴보세요! 정말 긴 싸움이었지만 결국 승리하셨습니다.
      -- }}}

      -- 선택(Select) 단축키 수동 매핑
      -- x: visual 모드, o: operator pending 모드 (d, y, c 등 뒤에 오는 모드). 즉, vam(선택)도 되고 dam(삭제)도 가능
      local select = require('nvim-treesitter-textobjects.select')

      -- am: around method (함수 전체), im: inner method (함수 내부)
      -- @function.outer: 함수의 선언부터 끝까지 전체 선택
      -- cf) 다른키로도 많이 쓰임 : af, if
      -- vim.keymap.set({ 'x', 'o' }, 'am', function()
      --   require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
      -- end)
      vim.keymap.set({ 'x', 'o' }, 'am', function()
        select.select_textobject('@function.outer', 'textobjects')
      end)

      -- @function.inner: 함수의 본문(내용)만 선택
      -- vim.keymap.set({ 'x', 'o' }, 'im', function()
      --   require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
      -- end)
      vim.keymap.set({ 'x', 'o' }, 'im', function()
        select.select_textobject('@function.inner', 'textobjects')
      end)

      -- ac: around class, ic: inner class
      -- @class.outer: 클래스(또는 테이블 구조) 전체 선택
      -- vim.keymap.set({ 'x', 'o' }, 'ac', function()
      --   require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
      -- end)
      vim.keymap.set({ 'x', 'o' }, 'ac', function()
        select.select_textobject('@class.outer', 'textobjects')
      end)

      -- @class.inner: 클래스 내부 내용만 선택
      -- vim.keymap.set({ 'x', 'o' }, 'ic', function()
      --   require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
      -- end)
      vim.keymap.set({ 'x', 'o' }, 'ic', function()
        select.select_textobject('@class.inner', 'textobjects')
      end)
      -- desc = "Select inner part of a class region"

      -- You can also use captures from other query groups like `locals.scm`
      -- (6) as 매핑: local.scope란?
      -- 이것은 Treesitter만의 아주 지능적인 기능입니다.
      --
      -- 정의: 현재 커서가 속한 **가장 가까운 유효 범위(Variable Scope)**를 의미합니다.
      --
      -- 동작: if 문 안에 있다면 그 if 블록을, for 문 안에 있다면 그 for 블록을 선택합니다. 즉, 특정 문법(함수, 클래스)에 국한되지 않고 "현재 내가 갇혀 있는 논리적인 코드 덩어리"를 똑똑하게 찾아냅니다.
      --
      -- 용도: "아, 이 if 문 블록 전체를 복사하고 싶은데?" 할 때 vas를 누르면 됩니다.
      -- vim.keymap.set({ 'x', 'o' }, 'as', function()
      --   require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
      -- end)
      vim.keymap.set({ 'x', 'o' }, 'as', function()
        select.select_textobject('@local.scope', 'locals')
      end)


      -- -------------------------------
      -- incremental-selection
      --
      -- config = function() 내부 단축키 설정 구역

      -- [Incremental Selection 대체 구현]
      -- v를 누른 상태에서 'v'를 더 누르면 영역이 확장되고, 'V'를 누르면 영역이 축소됩니다.

      -- 1. 영역 확장 (Expand): 함수 단위로 확장
      vim.keymap.set('x', 'v', function()
        -- require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
        select.select_textobject('@function.outer', 'textobjects')
      end, { desc = "Expand selection to function" })

      -- 2. 영역 확장 (Expand): 클래스/스코프 단위로 더 크게 확장
      vim.keymap.set('x', 's', function()
        -- require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
        select.select_textobject('@local.scope', 'locals')
      end, { desc = "Expand selection to scope" })

      -- 3. (참고) 영역 축소는 기본 비주얼 모드의 기능을 활용하거나 
      -- 다시 처음부터 선택하는 방향이 Treesitter에서는 훨씬 안정적입니다.
      --
      --
      -------------------------

      -- {{{
      -- 예전 treesitter에서 사용했던 incremental-selection 기능
      -- cf) nvim-treesitter-textobjects 로 이전. 
      -- 증분 선택(Incremental Selection) 기능
      -- 코드 블록을 논리적 단위(단어 -> 문장 -> 함수 -> 클래스)로 빠르게 선택
      -- incremental_selection = {
      --   enable = true,
      --   keymaps = {
      --     init_selection = "<C-space>", -- 선택 시작
      --     node_incremental = "<C-space>", -- 선택 범위 확대 (함수 -> 클래스 등)
      --     scope_incremental = false,       -- (선택사항) 코드 스코프 단위 확대
      --     node_decremental = "<bs>", -- 선택 범위 축소 (BackSpace 키)
      --   },
      -- },
      -- }}}

      -- -------------------------------
      -- Text objects: swap
      -- Define your own mappings to swap the node under the cursor with the next or previous one, like function parameters or arguments.
      -- -------------------------------

      local swap = require('nvim-treesitter-textobjects.swap')

      -- keymaps
      vim.keymap.set("n", "<leader>a", function()
        -- require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
        swap.swap_next "@parameter.inner"
      end)
      vim.keymap.set("n", "<leader>A", function()
        swap.swap_previous "@parameter.outer"
      end)

      -- -------------------------------
      -- Text objects: move
      -- Define your own mappings to jump to the next or previous text object. This is similar to ]m, [m, ]M, [M Neovim's mappings to jump to the next or previous function.
      -- -------------------------------
      require("nvim-treesitter-textobjects").setup {
        move = {
          -- whether to set jumps in the jumplist
          set_jumps = true,
        },
      }

      -- 이동(Move) 단축키 수동 매핑
      -- n: normal 모드에서도 작동하도록 추가: 이동(move)은 단순히 커서를 옮기는 것이므로 Normal 모드(n)에서도 작동해야 함
      local move = require('nvim-treesitter-textobjects.move')

      -- ]m / [m : 다음/이전 함수 시작 부분으로 이동
      -- vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
      --   require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
      -- end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
        move.goto_next_start('@function.outer', 'textobjects')
      end)

      -- ]] / [[ : 다음/이전 클래스(테이블) 시작 부분으로 이동
      -- vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
      --   require('nvim-treesitter-textobjects.move').goto_next_start('@class.inner', 'textobjects')
      -- end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
        move.goto_next_start('@class.outer', 'textobjects')
      end)

      -- ]o: 루프(for, while)의 시작 부분으로 점프.
      -- You can also pass a list to group multiple queries.
      vim.keymap.set({ 'n', 'x', 'o' }, ']o', function()
        -- require('nvim-treesitter-textobjects.move').goto_next_start({ '@loop.inner', '@loop.outer' }, 'textobjects')
        move.goto_next_start({ '@loop.inner', '@loop.outer' }, 'textobjects')
      end)

      -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
      vim.keymap.set({ 'n', 'x', 'o' }, ']s', function()
        -- require('nvim-treesitter-textobjects.move').goto_next_start('@local.scope', 'locals')
        move.goto_next_start('@local.scope', 'locals')
      end)

      -- ]z: 코드 접기(Fold) 단위로 점프.
      vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
        -- require('nvim-treesitter-textobjects.move').goto_next_start('@fold', 'folds')
        move.goto_next_start('@fold', 'folds')
      end)

      -- ]M / [M: 다음/이전 함수의 끝(End) 부분으로 점프.
      -- vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
      --   require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
      -- end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
        move.goto_next_end('@function.outer', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
        -- require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
        move.goto_next_end('@class.outer', 'textobjects')
      end)

      -- vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
      --   require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
      -- end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
        move.goto_previous_start('@function.outer', 'textobjects')
      end)

      -- vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
      --   require('nvim-treesitter-textobjects.move').goto_previous_start('@class.inner', 'textobjects')
      -- end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
        move.goto_previous_start('@class.outer', 'textobjects')
      end)

      -- vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
      --   require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
      -- end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
        move.goto_previous_end('@function.outer', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
        -- require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
        move.goto_previous_end('@class.outer', 'textobjects')
      end)

      -- Go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      vim.keymap.set({ "n", "x", "o" }, "]d", function()
        -- require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects")
        move.goto_next("@conditional.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[d", function()
        -- require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
        move.goto_previous("@conditional.outer", "textobjects")
      end)


      -- -- test
      -- vim.notify("nvim-treesitter-textobjects 로드 완료!", "info", { title = "플러그인 상태" })
      -- -- end test
    end,
  },


}




-- {{{ 추가 확장 기능: nvim-treesitter-context
-- 추가 확장 기능: nvim-treesitter-context
--
-- ① nvim-treesitter-context (현재 위치 고정)
-- - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
-- 기능: 긴 함수나 if문을 코딩하다 보면, 현재 내 커서가 어떤 함수 안에 있는지 화면 위쪽이 가려져서 안 보일 때가 있죠? 이때 함수 이름이나 for문 시작 줄을 화면 최상단에 고정시켜 줍니다.
-- 사용 이유: "지금 내가 어느 블록에서 작업 중이지?"를 잊어버리지 않게 해줍니다.
-- }}}


-- vim: set foldmethod=marker foldmarker={{{,}}}:
--
--
--
--
--
--
--
--
--
--
-- end of file

-- --------------------------------------------------
-- --------------------------------------------------
-- --------------------------------------------------

