return {
  -- 들여쓰기 가이드라인을 시각적으로 표시해 주는 플러그인
  "lukas-reineke/indent-blankline.nvim",
  -- help ibl
  -- :help ibl.config   :  For all available options

  -- 플러그인의 메인 모듈 이름 (v3 버전 기준)
  main = "ibl",   -- ibl : indent-blankline

  -- 기본 설정값(options) 블록
  opts = {
    -- 1. 일반적인 들여쓰기 선 설정
    indent = {
      char = "┊", -- 안내선으로 사용할 문자, 현재 짧은점선("┊")으로 설정
      -- ("│"실선,"┆"긴 점선, "┊"짧은 점선)
    },

    -- 2. 현재 커서가 위치한 코드 블록(범위) 가이드 선(scope) 설정
    scope = {
      enabled = true,        -- 현재 위치한 블록 강조 기능 활성화
      show_start = false,    -- 블록이 시작되는 지점에 밑줄 등을 표시할지 여부
      show_end = false,      -- 블록이 끝나는 지점에 밑줄 등을 표시할지 여부

      -- 강조 기능을 적용할 문법 대상들을 정의
      include = {
        node_type = {
          -- 각 프로그래밍 언어별로 어떤 요소를 '블록'으로 인식할지 지정
          lua = {
            "table_constructor",   -- { } 로 묶인 테이블 (opts 등)
            "function_definition", -- 함수 정의 블록
            "if_statement",        -- if 조건문 블록
            "for_statement",       -- for 반복문 블록
            "chunk",               -- 코드 전체 덩어리
          },
          -- 필요한 경우 python = { "dict", "list_compression" } 식으로 추가 가능
        },
      },
    },
  },

  -- 3. 플러그인 로드 후 실행될 추가 설정(기능 및 색상)
  config = function(_, opts)

    -- 위에서 정의한 opts 내용을 바탕으로 플러그인 실행
    require("ibl").setup(opts)
  end,
}

