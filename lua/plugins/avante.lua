-- --------------------------------------------
-- avante.nvim github 설정파일
-- https://github.com/yetone/avante.nvim

-- --------------------------------------------
-- github의 설정 코드를 바탕으로, gemini가 만들어 준 설정 코등
return {
  "yetone/avante.nvim",
  -- Windows 사용자들을 위한 자동 빌드 설정 (PowerShell 기반)
  build = vim.fn.has("win32") ~= 0
      and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
  event = "VeryLazy",
  lazy = false,
  version = false, -- 최신 기능을 유지하기 위해 false 권장

  opts = {
    -- 1. 메인 제공자를 gemini로 지정
    provider = "gemini",

    -- 2. gemini 제공자에 대한 상세 설정
    providers = {
      gemini = {
        -- Google AI Studio의 v1beta 엔드포인트를 직접 지정하여 404 에러 방지
        endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
        -- 사용하고자 하는 정확한 모델명
        -- model = "gemini-3.1-flash-lite",
        -- model = "gemini-3.1-flash",
        model = "gemini-2.5-flash",

        -- 환경 변수에서 가져올 API 키 이름
        api_key_name = "GEMINI_API_KEY",
        -- 답변 속도와 창의성 조절
        extra_request_body = {
          temperature = 0.1, -- 코딩 보조이므로 낮게 설정(정확도 위주)
          max_tokens = 4096,
        },
      },
    },

    -- 3. 프로젝트별 특수 지침 파일 (필요시 사용)
    instructions_file = "avante.md",


    -- avnate의 출력이 (md 파일) render-markdown.nvim의 설정에 의해 렌더링 되게 한다.
    -- 최신 avante 버전들은 render-markdown을 감지하면 자동으로 렌더링을 render-markdown.nvim에게 양보함.
    windows = {
      sidebar_header = {
        enabled = true, -- 헤더 활성화 시 render-markdown이 이를 잡아서 예쁘게 꾸며줍니다.
      },
    },
  },

  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "stevearc/dressing.nvim",
    "nvim-tree/nvim-web-devicons",
    -- {
    --   -- 마크다운 형식의 응답을 예쁘게 보여주는 플러그인
    --   "MeanderingProgrammer/render-markdown.nvim",
    --   opts = {
    --     file_types = { "markdown", "Avante" },
    --   },
    --   ft = { "markdown", "Avante" },
    -- },
    "MeanderingProgrammer/render-markdown.nvim",
    {
      -- 이미지 붙여넣기 기능 (Windows 사용 시 필수 설정 포함)
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = { insert_mode = true },
          use_absolute_path = true, -- Windows 필수 설정
        },
      },
    },
  },
}



