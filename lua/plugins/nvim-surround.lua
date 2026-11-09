return {
  -- :h nvim-surround
    -- Optional: See `:h nvim-surround.configuration` and `:h nvim-surround.setup` for details
  "kylechui/nvim-surround",
  version = "*", -- 모든 메이저 버전을 통틀어 정식 출시된 가장 최신 안정 버전을 사용
  -- version = "^4.0.0", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",

    -- Optional: See `:h nvim-surround.configuration` and `:h nvim-surround.setup` for details
  config = function()
    require("nvim-surround").setup({

      -- cf) 참고: nvim-surround의 기본 키맵
      -- 🌟 nvim-surround는 설치하자마자 아래 키맵이 '공식 디폴트'로 작동합니다!
      -- 🌟 수많은 파워 유저들이 극찬하는 표준 디폴트 키맵 그대로 사용하기
      -- keymaps = {
      --   add = "ys",       -- 추가, ysiw" (따옴표 추가), ysiw)
      --   delete = "ds",    -- 삭제, ds"   (따옴표 삭제), dst (tag 삭제)
      --   change = "cs",    -- 변경, cs"'  (따옴표를 홑따옴표로 변경), csthl<CR> (tag를 <h1>...</h1>으로 변경)
      -- },

      -- {{{ "원하는 특수 기호나 편의 기능을 엔진에 추가"

      -- 🌟 "원하는 특수 기호나 편의 기능을 엔진에 추가"
      --
      -- -- 이동 및 구획 정의 시 개행(줄바꿈)을 영리하게 감지하도록 최적화
      -- move_cursor = "begin", -- 서라운드 조작 후 커서를 항상 단어의 시작점으로 이동 (다음 작업 편리)

      -- -- 나만의 커스텀 단축기호가 필요할 때 여기에 추가 확장...
      -- surrounds = {

      -- 마크다운 / 주석용 '커스텀 서라운드' 정의하기
      -- 생산성을 극대화하는 유저들은 자신만의 기호를 등록합니다. 예를 들어 
        -- 마크다운 문서 생성을 위해 f를 누르면 함수 템플릿이 입혀지거나, 
        -- c를 누르면 주석으로 감싸지게 만드는 설정입니다.
        --
      -- 🌟 'f'를 누르면 단어를 자바스크립트 화살표 함수 형태로 감싸줍니다.
        -- ["f"] = {
        --   add = { "const ", " = () => {}" },
        -- },

        -- {{{ ex)
        -- 예시 ① : 가장 기본 단어 감싸기 (ysiwf)
        -- 원래 텍스트: get*User (커서가 단어 글자 위 어디든 위치)
        -- 단축키 입력: ysiwf
        -- ys (서라운드 추가) ➔ iw (현재 단어 선택) ➔ f (우리가 만든 화살표 함수 규칙 적용)
        -- 결과 텍스트: const getUser = () => {}

        -- 예시 ② : 방금 만든 함수를 다른 단어 위에서 연속 테스트 (ysiwf)
        -- 원래 텍스트: fetch*Data
        -- 단축키 입력: ysiwf
        -- 결과 텍스트: const fetchData = () => {}

        -- 예시 ③ : 비주얼 모드로 영역 선택 후 감싸기 (Sf)
        -- 단어 중간에 하이픈(-)이나 공백이 있어서 iw로 한 번에 안 잡힐 때는 비주얼 모드로 긁어서 커스텀 규칙을 입힐 수 있습니다.
        -- 원래 텍스트: handle_submit_data*
        -- 조작 순서:
        -- v를 눌러 비주얼 모드를 켭니다.
        -- handle_submit_data 전체를 블록 지정(드래그)합니다.
        -- 그 상태에서 대문자 S를 누릅니다. (비주얼 모드 서라운드 추가 키)
        -- 어떤 기호로 감쌀지 물어볼 때 f를 누릅니다.
        -- 결과 텍스트: const handle_submit_data = () => {}
        -- }}}


        -- 🌟 'c'를 누르면 HTML/XML 주석으로 감싸줍니다.
        -- 사용 예시: ysiwc 입력 시 --> <!-- hello -->
        -- ["c"] = {
        --   add = { "<!-- ", " -->" },
        -- },
      -- },

      -- }}}

    })
  end,
}

-- vim: set foldmethod=marker foldmarker={{{,}}}:
