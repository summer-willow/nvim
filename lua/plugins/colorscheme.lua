-- If you want to see what colorschemes are already installed,
-- you can use `:Telescope colorscheme`.

-- -----------------------------------------------
-- {{{ 'folke/tokyonight.nvim',
--[[
return {
  'folke/tokyonight.nvim',
  lazy = false,	-- colorscheme이므로 즉시 로딩
  priority = 1000, -- 로드 우선순위 최상위, Make sure to load this before all the other start plugins.
  -- by stc
  opts = {
    style = 'night',

    -- on_highlights = function(hl, c)
    on_highlights = function(hl, _)

      hl.Comment = { fg = '#a9b1d6', italic = true }

      -- :versobse map <leader>cf 와 같은 명령을 내렸을 때의 출력 색
      hl.SpecialKey = { fg = '#a6e3a1', italic = true },

      hl.CursorLine = {
        bg = '#3b4261', -- fixed by stc
        -- Or
        -- 테두리만 바꾸기: 배경은 그대로 두고 밑줄(underline)만 추가
        -- bg = c.bg_highlight, -- 원래 배경색 수준 유지, 밑줄이 현재 줄을 나타냄으로 뚜렷한 색 필요 없음
        -- underline = true, -- 밑줄 추가
        -- sp = c.magenta, -- 밑줄 색상을 보라색(magenta)으로 지정
      }

      hl.Visual = {
        bg = '#4e5a92',   -- good
        -- bg = '#696969', -- good
        -- bold = true, -- 선택된 글자를 굵게 표현해서 더 강조함
      }

      -- 검색 결과 강조색 (노란색 계열로 변경)
      -- -- hl.Search = { bg = c.yellow, fg = c.black }
      -- hl.Search = { bg = c.yellow }
      -- -- 현재 선택된 검색 결과
      -- -- hl.CurSearch = { bg = c.orange, fg = c.black }
      -- hl.CurSearch = { bg = c.orange }

      -- hl.ErrorMsg = { fg = "#FF8C8C", bold = true }
      hl.ErrorMsg = { fg = "#FFA07A", bold = true }

      -- --------------------------------------
      -- indent-blankline.nvim 관련 설정 추가
      hl.IblIndent = { fg = "#3b4261" } -- 일반 가이드 선 (어두운 파란/회색)
      hl.IblScope = { fg = "#be5046" }  -- 현재 스코프 가이드 선  ==> *4


      -- relative number 색 설정 
      hl.LineNr = { fg = "#a9b1d6", bold = true }
      hl.LineNrAbove = { fg = "#a9b1d6"}
      hl.LineNrBelow = { fg = "#a9b1d6"}
    end,
  },

  config = function(_, opts)
    require('tokyonight').setup(opts)
    -- vim.cmd.colorscheme 'tokyonight-night'
    vim.cmd("colorscheme tokyonight")
  end,
}
--]]

-- }}}

-- -----------------------------------------------
-- {{{ "rebelot/kanagawa.nvim",
--
-- reference로 참고 할 것: tokyonight의 설정을 그대로 복사한 것임.
-- tokyonight에서는 내 개인 취향에 맞추었는데, kanagawa 테마를 써서 그런지,
-- 약간은 어색하다.
-- ==> 수정하면서 설정할 것 !!!!
--
--  
-- Kanagawa (카나가와)
-- Kanagawa: 일본 전통 색상(가을색, 파도색 등)을 사용차분하고 고전적임
-- cf) Catppuccin (Mocha): 파스텔 톤의 부드럽고 현대적인 색감귀엽고 깔끔함
--
--
-- * Kanagawa의 세 가지 버전
-- wave: 기본 버전. '높은 파도' 그림에서 영감을 받은 깊은 바다색 배경입니다.
-- dragon: 훨씬 어두운 버전. 검은색에 가까운 배경을 선호하신다면 추천합니다.
-- lotus: 밝은 배경(Light theme). 종이 질감의 느낌을 줍니다.
--
-- 설정 적용 후 팁
-- 동작 확인: 설정을 저장한 뒤 Neovim을 다시 시작하면 자동으로 모든 플러그인을 로드하고 테마를 바꿀 것입니다.
--
-- 색상 수정: 만약 줄 번호가 여전히 너무 어둡거나 밝게 느껴진다면, LineNr 부분의 fg 값(#a9b1d6)을 더 밝은 색(예: #d5d6db)으로 수정해 보시기 바랍니다.
--
-- 우선순위: 이 설정은 다른 어떤 설정보다 먼저 실행되도록(priority = 1000) 되어 있어, 다른 플러그인들이 이 테마의 색상 값을 참고하여 본인들의 색을 정할 수 있게 해줍니다.
--
-- 이제 상세한 주석과 함께 나만의 맞춤형 kanagawa-dragon 환경을 즐겨보세요!

--[[
return {
  {
    -- 플러그인 경로: 일본 우키요에 화풍의 색감을 가진 테마
    'rebelot/kanagawa.nvim',
    -- 테마는 nvim 시작과 동시에 적용되어야 하므로 지연 로딩(lazy)을 끕니다.
    lazy = false, -- 에러 방지를 위해 즉시 로드,  -- 테마이므로 즉시 로딩
    -- 다른 플러그인(UI 관련 등)보다 먼저 로드되도록 최우선 순위를 부여합니다.
    priority = 1000, -- 다른 플러그인보다 먼저 로드,  -- 최상위 로드 우선순위

    -- 테마 고유의 옵션 설정 영역
    opts = {

      -- 테마 스타일 선택 (wave, dragon, lotus)
      -- dragon: 기본 wave보다 더 어둡고 짙은 배경을 사용하는 스타일
      theme = 'dragon', -- wave, dragon, lotus

      transparent = false,         -- 배경 투명도 여부-- 배경을 투명하게 할지 여부
      -- dimInactive = false,         -- 활성화되지 않은 창 어둡게 하기 -- 현재 포커스가 없는 창을 어둡게 할지 여부
      --
      compile = true,             -- 컴파일을 통해 속도 향상,-- 설정 변경이 잦을 때는 false, 확정되면 true로 속도 업 가능
      -- 에러나 경고 등을 표시할 때 물결 모양 밑줄(Undercurl)을 허용합니다.
      undercurl = true, -- 에러 표시 등의 밑줄을 물결 모양으로 표시
      -- 터미널 내장 색상도 Kanagawa 테마에 맞춰 변경합니다.
      terminalColors = true, -- 터미널 색상 적용 -- 내장 터미널 색상도 테마에 맞게 조정

      -- 텍스트 스타일 설정 (기울임꼴 및 굵게)
      commentStyle = { italic = true }, -- 주석은 코드와 구분하기 쉽게 기울임꼴 적용-- 주석을 기울임꼴로 표시
      functionStyle = {},
      keywordStyle = { italic = true }, -- if, return 등 키워드에 기울임꼴 적용-- Lua 키워드 등을 기울임꼴로 표시
      statementStyle = { bold = true }, -- 문법 구문들을 굵게 표현하여 가독성 향상-- if, for 같은 문구들을 굵게 표시
      typeStyle = {},

      -- 특정 하이라이트 그룹 직접 조정
      -- 테마의 기본 색상을 사용자 취향에 맞게 덮어쓰는(Override) 함수입니다.
      -- overrides = function(colors): tokyonight의 on_highlights와 같은 역할입니다. 테마가 정의한 기본 색상을 사용자 입맛대로 덮어씌우는 핵심 구간입니다.
      -- colors: Kanagawa가 제공하는 기본 색상 팔레트 정보가 담겨 있습니다.
      -- kanagawa는 tokyonight와 내부 구조가 조금 다르기 때문에, opts.overrides 함수를 사용하여 사용자님의 취향(주석 색상, 비주얼 모드 배경, 인덴트 가이드 등)을 그대로 반영했습니다.
      -- 기존 tokyonight의 on_highlights와 같은 역할입니다.
      overrides = function(colors)
        -- theme: UI 구성 요소들에 대한 색상 변수들을 가져옵니다.
        -- colors.theme를 통해 kanagawa의 기본 색상 팔레트에 접근합니다.
        local theme = colors.theme

        return {
          -- 1. [주석 색상]
          -- 기존 tokyonight에서 쓰시던 밝은 회청색(#a9b1d6)을 그대로 사용하여
          -- 주석이 너무 어둡지 않게 설정합니다.
          Comment = { fg = '#a9b1d6', italic = true },

          -- 2. [현재 커서 줄]
          -- 2. 현재 줄 하이라이트
          -- 커서가 위치한 줄의 배경색을 지정합니다.
          -- 너무 밝지도 어둡지도 않은 '#3b4261'로 설정하여 현재 위치를 명확히 합니다.
          CursorLine = { bg = '#3b4261' },

          -- 3. [비주얼 모드 선택 영역]
          -- 3. 비주얼 모드: 선택 영역 배경색  설정
          -- 텍스트를 드래그해서 선택했을 때의 배경색입니다.
          -- 기존에 만족하셨던 청보라색 계열('#4e5a92')을 적용했습니다.
          Visual = { bg = '#4e5a92' },
          -- Visual = { bg = "#2d3143" },

          -- 4. [에러 메시지]
          -- 코드 진단 시 나타나는 에러 텍스트 색상입니다.
          -- 눈에 잘 띄는 연어색(Salmon, #FFA07A)을 사용하여 경고 효과를 높였습니다.
          ErrorMsg = { fg = '#FFA07A', bold = true },

          -- 5. [인덴트 가이드 (indent-blankline)]
          -- 5. 인덴트 가이드 선 (indent-blankline 관련)
          -- 코드의 들여쓰기를 도와주는 수직선 설정입니다.
          -- IblIndent: 일반적인 들여쓰기 선 색상 (차분하게 설정)
          -- IblScope: 현재 커서가 속한 블록(Scope)의 선 색상 (붉은 계열로 강조)
          IblIndent = { fg = '#3b4261' }, -- 일반 가이드 선
          IblScope = { fg = '#be5046' }, -- 현재 스코프 가이드 선
          -- IblIndent = { fg = "#222224" },
          -- IblScope = { fg = "#be5046" },

          -- 6. 줄 번호 (Relative Number) 설정
          -- 6. [줄 번호 (Line Numbers)]
          -- relativenumber=true일 때 나타나는 숫자들의 색상입니다.
          -- LineNr: 현재 줄을 제외한 나머지 숫자들 (주석과 같은 색으로 통일)
          -- LineNrAbove/Below: 현재 줄 위/아래의 상대 숫자들
          -- 상대 줄 번호 설정
          LineNr = { fg = '#a9b1d6', bold = true },
          LineNrAbove = { fg = '#a9b1d6' },
          LineNrBelow = { fg = '#a9b1d6' },

          -- 3. 커서 라인 배경색 및 밑줄 설정
          -- underline = true, sp = "#7e9cd8": 현재 줄에 밑줄을 긋고, 그 밑줄의 색상(sp, Special color)을 차분한 파란색으로 지정하여 가독성을 높였습니다.
          -- CursorLine = { bg = "#18181a", underline = true, sp = "#7e9cd8" },

          -- 현재 줄의 실제 번호 (보통 오렌지나 노란색 계열이 기본값입니다.)
          -- 원하시면 여기서 CursorLineNr 그룹을 추가해 따로 설정 가능합니다.
          -- 1. 현재 줄 번호 강조 (오렌지 계열)
          CursorLineNr = { fg = theme.ui.fg_reverse, bold = true },
          -- 현재 줄 번호는 kanagawa dragon의 기본 오렌지색 계열을 유지하거나 
          -- 원하시면 아래 주석을 풀어 별도로 지정 가능합니다.
          -- CursorLineNr = { fg = "#ff9e64", bold = true },
        }
      end,

      -- 색상 팔레트 자체를 수정하고 싶을 때 사용
      -- colors = {                   -- 테마 색상 커스텀 가능
      --   theme = {
      --     all = {
      --       ui = {
      -- bg_gutter = "none": 줄 번호가 표시되는 왼쪽 영역(Gutter)의 배경색을 코드 배경색과 일치시켜 경계선 없이 일체감 있는 화면을 만듭니다.
      --         bg_gutter = "none"   -- 줄 번호 배경 제거,  -- 줄 번호 배경을 없애서 깔끔하게 만듦
      --       }
      --     }
      --   }
      -- },
    },

    -- 플러그인이 실제로 설치되고 실행될 때의 동작을 정의합니다.
    config = function(_, opts)
      -- 위에서 정의한 opts를 사용해 Kanagawa 설정을 초기화합니다.
      -- 1. 위에서 정의한 opts를 기반으로 테마 설정
      require('kanagawa').setup(opts)

      -- 2. 테마를 실제로 적용 (이 시점에 overrides 함수가 실행됨)
      -- 마지막으로 Neovim에 이 컬러스크립트를 사용하라고 명령합니다.
      -- 'kanagawa-dragon'이라고 정확히 명시해야 드래그 스타일이 적용됩니다.
      -- 테마 적용
      vim.cmd 'colorscheme kanagawa-dragon'
    end,
  },
}
--]]
-- }}}

-- -----------------------------------------------
-- "rebelot/kanagawa.nvim"의 github에서 default 설정을 가져온 것.
-- 바로 위, reference 설정을 참고하여, 내 취향으로 설정 할 것

-- {{{ "rebelot/kanagawa.nvim",

--[[
return {
  {

    -- 플러그인 경로: 일본 우키요에 화풍의 색감을 가진 테마
    'rebelot/kanagawa.nvim',
    -- 테마는 nvim 시작과 동시에 적용되어야 하므로 지연 로딩(lazy)을 끕니다.
    lazy = false, -- 에러 방지를 위해 즉시 로드,  -- 테마이므로 즉시 로딩
    -- 다른 플러그인(UI 관련 등)보다 먼저 로드되도록 최우선 순위를 부여합니다.
    priority = 1000, -- 다른 플러그인보다 먼저 로드,  -- 최상위 로드 우선순위

    opt = {

      compile = false,             -- enable compiling the colorscheme
      undercurl = true,            -- enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true},
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,         -- do not set background color
      dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
      terminalColors = true,       -- define vim.g.terminal_color_{0,17}
      colors = {                   -- add/modify theme and palette colors
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      overrides = function(colors) -- add/modify highlights
          return {}
      end,
      theme = "wave",              -- Load "wave" theme
      background = {               -- map the value of 'background' option to a theme
          dark = "wave",           -- try "dragon" !
          light = "lotus"
      },

    },

    config = function(_, opts)
      require('kanagawa').setup(opts)

    -- setup must be called before loading
      vim.cmd("colorscheme kanagawa")
      -- vim.cmd 'colorscheme kanagawa-dragon'
    end,




  }
}

--]]
-- }}}

-- -----------------------------------------------
-- catppuccin/nvim
-- {{{

return {
  {
    "catppuccin/nvim",
    name = "catppuccin", -- 플러그인 이름을 catppuccin으로 명시
    lazy = false,        -- 메인 테마이므로 즉시 로딩
    priority = 1000,     -- 다른 플러그인보다 먼저 로드되도록 우선순위 설정

    opts = {
      -- flavour: latte, frappe, macchiato, mocha 중 선택 가능
      -- mocha가 가장 어둡고 대중적인 스타일입니다.
      flavour = "mocha",

      -- 배경 투명화 여부 (false가 기본값이며 안정적입니다)
      -- transparent_background = true,
      transparent_background = false,

      -- 컴파일 기능을 활성화하여 Neovim 시작 속도를 높입니다.
      -- :lua print(vim.fn.stdpath("cache") .. "/catppuccin")
      -- ==> C:\Users\stc\AppData\Local\Temp\nvim/catppuccin
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",

      -- 하이라이트 스타일 설정
      term_colors = true, -- 내장 터미널 색상 활성화
      dim_inactive = {
        -- enabled = false, -- 비활성 창을 어둡게 할지 여부
        enabled = true, -- 비활성 창을 어둡게 할지 여부
      },

      -- 설치된 플러그인을 자동 통합(integration) 활성화
      auto_integrations = true,
      -- {{{
      -- auto_integrations: 설치된 플러그인을 탐지하여 자동으로 테마를 적용하는 자동화 기능.
      -- lazy.nvim에 등록된 플러그인 목록을 catppuccin이 직접 훑어보고, 지원할 수 있는 플러그인으로 판단하면 미리 정의된 해당 플러그인용 색상 프로필을 자동으로 적용
      -- }}}

      -- {{{
      -- 위에서 auto_integrations = true를 했는데, 왜 개별 integrations을 명시하는 이유,
      -- 특정 플러그인의 통합 설정을 커스텀하고 싶을 때는 여전히 integrations 항목이 필요.
      -- 예를 들어, indent_blankline의 경우 단순히 켜는 것뿐만 아니라 scope_color = "lavender" 같은 세부 옵션을 설정.
      -- 이런 세부 제어는 auto_integrations가 대신해주지 못하므로 integrations 안에 직접 적어야 한다.
      -- }}}
      integrations = {
        cmp = true,                -- 코드 완성창(nvim-cmp) 지원
        gitsigns = true,           -- Git 상태 표시 지원
        -- 만약 특정 플러그인은 통합을 끄고 싶다면 명시적으로 false 처리
        -- nvimtree = true,           -- NvimTree 파일 탐색기 지원
        neotree = true,            -- neo-tree 파일 탐색기 지원
        treesitter = true,         -- 문법 강조(Treesitter) 지원
        notify = true,             -- 알림창(nvim-notify) 지원
        indent_blankline = {
          enabled = true,          -- 들여쓰기 가이드 선 지원
          scope_color = "maroon", -- 현재 스코프 강조 색상
        },
        mason = true,              -- LSP 관리 도구(Mason) UI 지원
        native_lsp = {
          enabled = true,          -- Neovim 내장 LSP 지원
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
            hints = { "undercurl" },
          },
        },
      },

      -- custom_highlights = function(_)
      custom_highlights = function(colors)
        return {

          -- :versobse map <leader>cf 와 같은 명령을 내렸을 때의 출력 색
          SpecialKey = { fg = '#8ee4af', italic = true },

          -- commmande prompt에 나오는 'Press ENTER or type command to continue'와 같은 문구  색 지정
          -- Question = { fg = "#be5046" },

          -- 현재 줄 배경색
          CursorLine = { bg = "#45475a" },  -- good,
          -- CursorLine = { bg = "#4e5166" },  -- good 

          -- 비주얼 모드 선택 영역 배경색 (CursorLine보다 한 단계 밝은 색 추천)
          Visual = { bg = "#6c7086" },
          -- Visual = { bg = "#6c7086", fg = colors.text }, -- 만약 선택된 글자색까지 바꾸고 싶다면 (예: 흰색 계열)

          -- [indent-blankline 관련 설정 추가]
          IblIndent = { fg = "#45475a" },
          IblScope = { fg = "#be5046" },

          -- 현재 커서가 위치한 줄의 번호 
          CursorLineNr = { fg = "#ff9e64", bold = true },

          -- 현재 줄을 제외한 위/아래 상대 번호들
          LineNrAbove = { fg = "#7f849c" },
          LineNrBelow = { fg = "#7f849c" },

          -- (참고) 만약 절대 번호를 쓴다면 이 설정도 필요할 수 있음
          LineNr = { fg = "#a6e3a1", bold = true },
          -- {{{
          --[[
          Neovim에서 relativenumber를 사용할 때, 현재 커서가 있는 줄의 번호는 LineNr이 아니라 CursorLineNr 그룹의 영향을 받습니다. 
          LineNr은 보통 절대 번호(Absolute Number) 모드이거나, 상대 번호 모드에서 현재 줄을 제외한 나머지 번호들의 기본 스타일을 담당합니다.
          --]]
          -- }}}
        }
      end,
    },

    -- 설정을 적용하고 테마를 실행하는 부분
    config = function(_, opts)
      -- 1. 위 옵션들로 catppuccin 설정
      require("catppuccin").setup(opts)

      -- 2. 컬러스크립트 적용
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}

-- }}}




-- vim: set foldmethod=marker foldmarker={{{,}}}:
