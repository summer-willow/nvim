-- -----------------------------
-- by stc
-- nvim-colorizer.nvim: color highlighter for Neovim
-- 코드 속 색상 코드를 실제 색상으로 보여주는 하이라이터
return {
  'norcalli/nvim-colorizer.lua',
  -- lazy = true,
  config = function()
    require('colorizer').setup({
      '*', -- 모든 파일 타입에 적용
      -- 모든 파일(*) 또는 특정 파일(lua, python, latex)만 지정 가능
      -- Or
      -- "lua", "python", "tex",
    }, {
      RGB = true, -- #RGB 형식 지원, rgb(255, 0, 0) (예: #F00)
      RRGGBB = true, -- #RRGGBB 형식 지원 (예: #FF0000)
      names = true, -- "Red", "Blue" 같은 색상 이름 지원 (LaTeX 사용 시 유용!)
      -- 나머지 CSS 관련(hsl, rgb_fn 등)은 false로 두거나 생략해도 무방합니다.
      -- RRGGBBAA = true, -- #RRGGBBAA 형식 지원
      -- rgb_fn = true, -- CSS rgb() 및 rgba() 함수 지원
      -- hsl_fn = true, -- CSS hsl() 및 hsla() 함수 지원
      -- css = true, -- 모든 CSS 속성 내의 색상 지원
      -- css_fn = true, -- 모든 CSS 함수 내의 색상 지원
      --
      mode = 'background', -- "background"(배경색), "foreground"(글자색) 중 선택
      -- mode = 'foreground', -- "background"(배경색), "foreground"(글자색) 중 선택
    })

    -- -- test
    -- vim.notify("nvim-colorizer 로드 완료!", "info", { title = "플러그인 상태" })
    -- -- end test
  end,
}
--
-- -------------------------------------
-- {{{ test
-- -- Hex 코드 (가장 많이 쓰임, #RRGGBB 형식)
-- #FF0000 (빨강)
-- #00FF00 (초록)
-- #0000FF (파랑)
-- #FFFF00 (노랑)
-- #FF00FF (보라)
-- #00FFFF (하늘색)
-- #FFA500 (주황색)
-- #800080 (자주색)
-- #C0C0C0 (은색)
-- #000000 (검정)
-- #FFFFFF (하얀색)
--
-- -- 색상 이름 (Names - 설정에서 names = true인 경우 작동)
-- Red, Blue, Green, Yellow, Orange, Purple, Pink, Grey, Brown, Cyan, Magenta
--
-- -- 조금 더 세련된 색상들
-- #1E1E2E (어두운 배경색)
-- #F5C2E7 (분홍빛)
-- #89B4FA (부드러운 파랑)
-- #A6E3A1 (부드러운 초록)
-- #FAB387 (살구색)
-- }}}
-- -----------------------------
