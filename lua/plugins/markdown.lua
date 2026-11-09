return {
  {
    "MeanderingProgrammer/render-markdown.nvim",

    -- 이 플러그인이 실행되기 전에 먼저 로드되어야 하는 의존성 플러그인들
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- 마크다운 구조 분석용 필수 파서
      "nvim-tree/nvim-web-devicons",  -- 또는 'echasnovski/mini.icons'  -- 마크다운 요소에 입혀질 예쁜 아이콘 세트
    },

    -- Neovim 시동 속도를 위해 파일이 열리거나 새 파일이 생성될 때 지연 로딩(Lazy Load)
    event = { "BufReadPost", "BufNewFile" },

    -- 아래에 지정된 파일 타입(확장자 등) 버퍼가 활성화될 때 이 플러그인을 작동시킴
    ft = { "markdown", "Avante", "avante" },

    opts = {
      -- 1. 적용 범위 설정
      -- 일반 .md 파일, 오브시디언 보관소 내부 노트, 그리고 avante(AI 채팅창) 버퍼까지 
      -- 모두 하나의 동일한 UI 스타일 설정을 따르도록 지정합니다.
      file_types = { "markdown", "Avante", "avante" },


      -- 2. 헤딩(Heading, # ## ### 등) 스타일 설정
      heading = {
        enabled = true,

        -- icons = {},
        -- icons = { "󰫎 ", "󰫏 ", "󰫐 ", "󰫑 ", "󰫒 ", "󰫓 " },
        icons = { "󰎥 ", "󰎨 ", "󰎫 ", "󰎲 ", "󰎯 ", "󰎴 " }, 
        -- icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " }, 
        -- icons = { "❶  ", "❷  ", "❸  ", "❹  ", "❺  ", "❻  " },    -- my choice
        -- icons = { "❶  ", "❷  ", "❸  ", "❹  ", "❺  ", "❻  " },
        -- icons = { "🔲 ", "🔲 ", "🔲 ", "🔲 ", "🔲 ", "🔲 " },

        -- sign = true, -- 에디터 맨 왼쪽 줄번호 라인(Sign Column)에도 헤딩 아이콘을 표시합니다.
        -- signs = { "󰫎1", "󰫎2", "󰫎3", "󰫎4", "󰫎5", "󰫎6" },
        signs = { "1󰫎", "2󰫎", "3󰫎", "4󰫎", "5󰫎", "6󰫎" },

        -- 가독성을 높이기 위해 각 헤딩 레벨별로 배경색(Background) 하이라이트를 다르게 입힙니다.
        -- (현재 테마의 컬러셋에 맞게 텍스트 뒤에 은은한 음영 배경이 들어갑니다.)
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
      },

      -- 3. 소스 코드 블록(Code Block, ```lua 등) 디자인 설정
      code = {
        enabled = true,
        sign = false,     -- 코드 블록 영역은 왼쪽 줄번호 라인에 따로 표시를 안 합니다.
        style = "full",   -- 코드 블록 전체 면적에 은은한 배경색을 가득 채웁니다.
        position = "right", -- 해당 코드의 언어 이름(예: Lua, Python 등)을 우측 상단에 정렬합니다.
        width = "block",  -- 코드 블록의 가로 너비를 화면 끝까지 꽉 차게 넓힙니다.
        left_pad = 2,     -- 코드 시작 부분 왼쪽에 여백(공백 2칸)을 주어 들여쓰기 효과를 만듭니다.
      },

      -- 4. 할 일 목록(Todo List) 체크박스 스타일 고도화
      checkbox = {
        enabled = true,
        position = "inline", -- 체크박스 아이콘을 텍스트 줄 안에 자연스럽게 배치합니다.

        -- unchecked = { icon = "󰄱 " }, -- 아직 완료되지 않은 빈 체크박스 모양 [ ]
        -- checked = { icon = " " },   -- 완료된 체크박스 모양 [x]
        -- ----------------
        -- by stc
        -- 아이콘 대신 직관적인 플레인 텍스트 형태로 지정
        unchecked = { icon = "[ ] " },
        checked = { icon = "[x] " },   -- 또는 취향에 따라 "[X] "
        -- by stc end
        -- ----------------

        -- 오브시디언에서 표준으로 자주 쓰이는 확장 체크박스 마크업 기호들을 추가 지원합니다.
        custom = {
          -- [-] 기호는 "진행 중"을 의미하는 시계 아이콘과 노란색 하이라이트로 매핑
          todo = { raw = "[-]", icon = "󰥔 ", highlight = "RenderMarkdownTodo" },
          -- [!] 기호는 "중요/경고"를 의미하는 느낌표 아이콘과 붉은색 하이라이트로 매핑
          important = { raw = "[!]", icon = " ", highlight = "RenderMarkdownWarn" },
        },
      },

      -- 5. 마크다운 표(Table) 스타일 레이아웃 설정
      table = {
        enabled = true,
        style = "full", -- 표의 세로선, 가로선 격자를 모두 활성화합니다.

        -- 원시 텍스트 표 기호( |, - )들을 부드럽고 수려한 선 구조로 바꾸는 테두리 에셋입니다.
        border = {
          "┌", "┬", "┐",
          "├", "┼", "┤",
          "└", "┴", "┘",
          "│", "─",
        },
      },

      -- 6. 하이퍼링크 및 오브시디언 위키링크([[ ]]) 아이콘 바인딩
      link = {
        enabled = true,
        image = "󰥶 ",     -- 마크다운 이미지 링크 앞에 붙을 아이콘
        email = "󰇮 ",     -- 이메일 주소 링크 앞에 붙을 아이콘
        hyperlink = "󰌹 ", -- 일반 인터넷 웹사이트(http/https) 주소 앞에 붙을 아이콘
        wiki = { icon = "󰧮 " }, -- 오브시디언 전용 대괄호 위키링크([[노트명]]) 앞에 붙을 아이콘
      },

      -- 7. 편집 모드 가독성 방어 기능 (가장 중요)
      anti_conceal = {
        -- 커서가 특정 줄에 위치하더라도 마크다운 문법 기호(예: #, *, [ ])들이 
        -- 갑자기 날것의 텍스트로 튀어나와 화면을 흔들리게 만드는 현상을 억제합니다.
        -- 편집 중에도 render-markdown이 제공하는 예쁜 UI 레이아웃을 최대한 고정해 줍니다.
        enabled = true,
      },
    },

    config = function(_, opts)
      -- 1. 위에서 정의한 opts 설정을 바탕으로 플러그인을 실행합니다.
      require("render-markdown").setup(opts)

    end,

  },


  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },


    -- install with yarn or npm
    -- 윈도우 전용 pre-compiled 바이너리 다운로드 방식 채택
    -- 이 플러그인의 개발자는 윈도우나 맥 유저들이 빌드 과정에서 스트레스를 받지 않도록, 내부 스크립트를 직접 컴파일하는 대신 "이미 다 만들어진 윈도우용 실행 파일(.exe)을 깃허브에서 직접 내려받는 옵션"을 공식적으로 제공하고 있습니다.
    -- 이 방식을 쓰면 Neovim 내부 루아 함수 충돌이나 yarn/npm 같은 복잡한 도구 설치 없이 1초 만에 오류가 깔끔하게 해결됩니다.

    -- build = "cd app && npx --yes yarn install", 의미
    -- 의미: "컴퓨터야, app 폴더로 들어간 뒤에, 만약 컴퓨터에 yarn이 안 깔려 있다면 Node.js 클라우드(npx)에서 yarn을 임시로 즉석 다운로드해서(--yes) 곧바로 실행해 버려!"
    build = "cd app && npx --yes yarn install",

    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,

    config = function()
      -- 💡 유저들이 가장 많이 쓰는 편의 설정들을 추가해 둡니다.

      -- 1. 마크다운 파일을 열자마자 자동으로 브라우저를 띄우고 싶지 않다면 0으로 설정 (필요할 때 명령어로 켜기)
      -- set to 1, nvim will open the preview window after entering the Markdown buffer
      -- default: 0
      vim.g.mkdp_auto_start = 0

      -- 2. 다른 버퍼로 전환했을 때 브라우저 미리보기 창을 자동으로 닫을지 여부
      -- " set to 1, the nvim will auto close current preview window when changing
      -- " from Markdown buffer to another buffer
      -- " default: 1
      -- vim.g.mkdp_auto_close = 1
      vim.g.mkdp_auto_close = 0

      -- 3. 브라우저 창에서 내 에디터 커서 위치를 실시간으로 쫓아오며 스크롤 되도록 설정
      -- " set to 1, Vim will refresh Markdown when saving the buffer or
      -- " when leaving insert mode. Default 0 is auto-refresh Markdown as you edit or
      -- " move the cursor
      -- " default: 0
      vim.g.mkdp_refresh_slow = 0

      -- [추가] 4. 마크다운 내부 렌더러(markdown-it)의 Heading ID 확장 기능 활성화
      -- markdown-it의 환경 설정을 주입하여 확장 문법을 인지하도록 만듭니다.
      -- 이 설정을 통해 {#id-name} 문법이 브라우저에서 텍스트로 노출되지 않고, 정상적인 책갈피(Anchor) 링크로 작동합니다.
      --
      -- markdown-it-anchor는 사용자가 텍스트를 기반으로 자동 생성된 ID에 앵커 아이콘을 붙여주는 플러그인입니다.
      -- Heading 뒤에 사용자가 직접 커스텀 ID를 수동으로 명시하는 문법인 {#id-name}을 파싱하여 화면에서 숨기려면 markdown-it-attrs라는 별도의 플러그인을 활성화해야 합니다.
      -- vim.g.mkdp_preview_options = {
      --   mkit = {
      --     plugins = {
      --       { "markdown-it-anchor", { permalink = true, permalinkBefore = true, permalinkSymbol = "🔗" } }
      --     }
      --   }
      -- }

      -- [수정 완료] 4. 마크다운 내부 렌더러(markdown-it)의 수동 속성 지정(Attributes) 기능 활성화
      -- markdown-it-attrs 플러그인을 활성화해야 {#id-name} 문법을 파싱하여 화면에서 깔끔하게 지워주고 속성으로 인식합니다.
      -- vim.g.mkdp_preview_options = {
      --   mkit = {
      --     plugins = {
      --       { "markdown-it-attrs" }
      --     }
      --   }
      -- }

      -- 해결책 1: 문자열 배열 형태로 설정 변경 (가장 확실함 🌟)
      -- [최종 보정] 4. 마크다운 내부 렌더러(markdown-it)의 수동 속성 지정 기능 확실하게 주입
      -- 매핑 유실을 막기 위해 1차원 문자열 배열 구조로 명시합니다.
      -- vim.g.mkdp_preview_options = {
      --   mkit = {
      --     plugins = {
      --       "markdown-it-attrs"
      --     }
      --   }
      -- }



      -- 🌟 자판 중심의 고속 구동을 위해 단축키를 아주 직관적으로 바인딩해 줍니다.
      -- 마크다운 파일(노멀 모드)에서 <leader>mp (Markdown Preview)를 누르면 켜지고, 다시 누르면 꺼집니다!
      vim.keymap.set("n", "<leader>mp", "<CMD>MarkdownPreviewToggle<CR>", { desc = "Toggle [M]arkdown [P]review" })


    end,
  },



}




-- vim: set foldmethod=marker foldmarker={{{,}}}:
