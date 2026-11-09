-- VimTeX: a modern Vim and Neovim filetype and syntax plugin for LaTeX files.
-- NOTE: To see the relation between vimscript and lua, :help lua-vimscript
--
-- NOTE: SumatraPDF 설정 (역방향 검색: PDF ➡️ Neovim 이동)
-- ## SumatraPDF: 설정(Settings) ➡️ 옵션(Options) --> '역방향 검색 명령줄 설정 (Set inverse search command-line)'
-- cmd /c nvim --headless --server localhost:12345 --remote-send "<C-\><C-n>:e %f<CR>:%l<CR>" 2>nul || cmd /c start "" nvim --listen localhost:12345 -c "e %f" -c "%l"
-- ## nvim 시작할 때:
-- nvim --listen localhost:12345

return {
  {
    "lervag/vimtex",
    lazy = false, -- 어느때나 역방향 검색(Inverse Search) 기능이 가능하게하기 위해서, 반드시 lazy = false로 설정. buffer에 tex 파일어 없더라고, 역방향 sync로 인해 tex파일이 로드될 때를 고려함.

    -- {{{
    -- Lazy.nvim의 init 함수 특징:
    -- init 블록은 플러그인이 실제로 require되거나 로드되기 직전에 구동됩니다. VimTeX의 전역 변수(vim.g.vimtex_*)들은 이 시점에 미리 선언되어야 VimTeX이 시작되면서 해당 설정을 읽어 들일 수 있습니다.
    --
    -- 왜 전역 옵션 설정은 플러그인이 로드되기 전에(init = function()) 지정해야 하는가?"
    -- 1. 전역 설정(vim.g.*)을 init = function()에 넣어야 하는 이유
    -- 대부분의 Vim/Neovim 플러그인(특히 VimTeX)은 다음과 같은 순서로 실행됩니다.
    --
    -- [Neovim 부팅] 
    --    └── 1. 사용자 설정 파일(vimtex.lua의 init 함수) 실행
    --             └─> vim.g.vimtex_env_toggle_math_map = { ... } (사용자 설정 저장)
    --    └── 2. VimTeX 플러그인 코드 로드 (Initialization Stage)
    --             └─> 플러그인 내부 코드: 
    --                 if exists('g:vimtex_env_toggle_math_map')
    --                   -- 사용자가 정의한 값이 있으면 그 값을 사용!
    --                 else
    --                   -- 설정값이 없으면 플러그인의 기본(Default) 값을 사용!
    --                 endif
    -- }}}

    init = function()
      -- 1. PDF 뷰어로 SumatraPDF 설정 (Windows 환경)
      vim.g.vimtex_view_general_viewer = "SumatraPDF"

      -- 2. 순방향 검색(Forward Search) 옵션 설정
      -- Neovim 커서 위치를 SumatraPDF에서 시각적으로 표시해 줍니다.
      vim.g.vimtex_view_general_options = [[-reuse-instance -forward-search "@tex" @line "@pdf"]]

      -- 3. 컴파일러 설정 (TeX Live의 latexmk 활용)
      -- 기본적으로 수식이나 인용구 번호를 제대로 맞추기 위해 pdflatex/xelatex 등을 연속으로 돌려줍니다.
      -- latexmk: 컴파일러가 아닌 일종의 자동화 빌드 스크립트(도구)로, 문서가 완벽히 완성될 때까지 pdflatex 등을 알아서 여러 번 반복 실행해 주는 비서 역할을 합니다.
      vim.g.vimtex_compiler_method = "latexmk"

      --  "확장자가 .tex인 파일을 열었을 때, Neovim이 이걸 Plain TeX로 인식할지, LaTeX로 인식할지"를 결정하는 구문 분석(Syntax) 설정.
      -- vim.g.tex_flavor = "latex" (기본값이며, VimTeX 공식 문서 권장)
      -- --> 이를 통해 Neovim은 .tex 파일을 문법 강조(Highlighting)가 지원되는 LaTeX 문서로 정확히 인지하게 됩니다. xelatex라고 적어도 LaTeX로 syntax highlighting 한다.
      -- cf) vim.g.tex_flavor는 컴파일러 엔진을 바꾸는 설정이 아님.
      -- 매직 코멘트(% !TEX program = xelatex)와는 아무 관계없음.
      -- vim.g.tex_flavor = "xelatex"
      vim.g.tex_flavor = "latex"

      -- Vimtex 기본 컴파일러를 xelatex으로 강제 지정하는 설정 예시
      -- pdflatex는 한글(kotex 패키지 등)을 컴파일할 때 에러가 나거나 한글이 깨집니다
      -- 한글 사용 시 pdflatex보다 에러가 적은 xelatex나 lualatex를 주로 씁니다.
      -- (선택) 만약 한글 문서를 자주 쓰셔서 xelatex 기반 컴파일이 필요하다면 아래 주석을 해제하세요.
      -- magic comment (% !TEX program = xelatex)를 써주는 효과
      vim.g.vimtex_compiler_latexmk = {
        options = {
          '-xelatex', -- 항상 xelatex 엔진을 사용하도록 설정
          '-verbose',
          '-file-line-error',
          '-synctex=1',
          '-interaction=nonstopmode',
        },
      }

      -- 4. 퀵픽스(에러창) 자동 열림 설정
      -- (0: 끔, 1: 에러 발생 시만 자동으로 열림, 2: 경고 포함하여 자동 열림)
      -- vim.g.vimtex_quickfix_mode = 1 설정이 
      -- " Don't open QuickFix for warning messages if no errors are present 이라는 설정인 
      -- `g:vimtex_quickfix_open_on_warning = 0`과 동일한 역할을 합니다.
      vim.g.vimtex_quickfix_mode = 1

      -- ============================================================================
      -- 🌟 [수정/추가된 부분] QuickFix 경고 필터 통합 목록
      -- ============================================================================
      vim.g.vimtex_quickfix_ignore_filters = {
        -- [기존] 폰트 관련 경고 무시
        [[Font shape `LUC/uhcmj/bx/n' undefined]],
        [[Font shape `OMS/cmtt/m/n' undefined]],
        [[Some font shapes were not available]],

        -- 줄바꿈/여백 관련 노이즈 경고 무시
        [[Underfull \\hbox]],
        [[Overfull \\hbox]],

        -- 자주 발생하는 패키지별 경고 무시
        [[LaTeX Warning: .\+ float specifier changed to]],
        [[LaTeX hooks Warning]],
        [[Package siunitx Warning: Detected the "physics" package:]],
        [[Package hyperref Warning: Token not allowed in a PDF string]],

      }

      -- ============================================================================
      -- 🌟 [VimTeX Delimiter & Math Toggle 설정]
      -- ============================================================================

      -- 1. Delimiter toggle modifier 목록 (\left-\right 및 \big 추가)
      -- Example: adding `\big` to VimTeX's delimiter toggle list
      vim.g.vimtex_delim_toggle_mod_list = {
        { '\\left', '\\right' },
        { '\\big', '\\big' },
      }

      -- 2. ts$ (<plug>(vimtex-env-toggle-math)) 토글 규칙 설정
      -- \(  <--->  \[  서로 토글되며, $ / $$ 는 각각 \( 및 \[ 로 변환됨
      -- 즉, \( ↔ \[ 사이를 서로 순환하게 만들고, 구버전 단일/이중 달러 기호($, $$)가 보이면 자동으로 표준 LaTeX 구문(\(, \[)으로 승화시키는 설정
      vim.g.vimtex_env_toggle_math_map = {
        ['$']  = '\\(',  -- $...$   -> \(...\)
        ['$$'] = '\\[',  -- $$...$$ -> \[...\]
        ['\\('] = '\\[', -- \(...\) -> \[...\]
        ['\\['] = '\\(', -- \[...\] -> \(...\)
      }

    end,
  }
}

