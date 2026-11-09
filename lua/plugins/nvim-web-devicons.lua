-- neo-tree.nvim 나 oil.nvim에서 LaTeX 파일 아이콘의 색을 더 밝게 설정하기 위해서
-- nvim-web-devicons을 독립적으로 설정.
-- nvim-web-devicons의 기본 설정으로 만족한다면, 이 설정은 필요헚으며,
-- 그냥 다른 플러그인의 dependancies 에 넣는 것으로 충분함.
return {
  "nvim-tree/nvim-web-devicons",
  config = function()
    local devicons = require("nvim-web-devicons")

    -- 1. nvim-web-devicons의 기본 설정을 먼저 초기화합니다.
    devicons.setup({ default = true })

    -- 2. 기본으로 등록되어 있는 "tex" 파일의 아이콘 모양을 그대로 가져옵니다.
    local default_tex = devicons.get_icon_by_filetype("tex", {})

    -- 3. 아이콘 모양은 그대로 두고, 색상만 원하는 밝은 색으로 오버라이드합니다.
    devicons.set_icon({
      tex = {
        icon = default_tex or "󰚞", -- 혹시 모를 예외를 위해 기본 모양 유지 (없으면 대체)

        -- color = "#FFCC00",          -- #FFCC00 (밝은 노랑)
        -- cterm_color = "11",

        color = "#00FFFF",  -- #00FFFF (Cyan)
        cterm_color = "14",

        -- {{{
        -- "GUI 환경에서 밝은 노랑(#FFCC00)을 쓸 거라면, 일반 터미널 환경에서도 그와 제일 비슷한 밝은 노란색 표준 번호인 11을 쓰고, 밝은 시안(#00FFFF)을 쓸 거라면 터미널 표준 번호 14를 써라"라는 의미로 구분해서 적어드린 것입니다.
        --
        --   만약 현대적인 터미널(Windows Terminal, WezTerm, Alacritty 등)을 사용 중이시고 termguicolors 옵션이 켜져 있다면 Neovim은 cterm_color 대신 color(# 값)를 우선해서 사용하므로, 이 숫자가 조금 달라도 크게 신경 쓰지 않으셔도 괜찮습니다!
        -- }}}

          name = "Tex",
      }
    })
  end
}
