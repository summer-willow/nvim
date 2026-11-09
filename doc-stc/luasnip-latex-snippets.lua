--[[

자동 트리거(Auto-trigger)에

자동 트리거가 아닌 완성창(Tab/Enter) 입력 기반이라 어색함의 원인이 됨.

트리거 방식을 Vim LaTeX 스타일로 튜닝하는 것이 훨씬 현명합니다.

friendly-snippets
모음집
VS Code 형식의 범용 스니펫 모음. 대중적이지만 자동 트리거가 아닌 완성창(Tab/Enter) 입력 기반이라 어색함의 원인이 됨.

vim-snippets
모음집
과거 UltiSnips 시절부터 축적된 레거시 모음집. LaTeX 관련 수학 기호 트리거 등이 많이 포함되어 있음.


## 
### 대안 A: LuaSnip의 '자동 트리거(Autotrigger)' 기능 활성화 (가장 추천)

### 대안 C: LaTeX 전용 초고속 플러그인 도입 (luasnip-latex-snippets.nvim)
- 전용 LaTeX 스니펫 팩
- 만약 어색함을 느끼는 주된 이유가 LaTeX 문서 작업 때문이라면, Neovim 유저들이 수학 기호와 수식 입력을 위해 UltiSnips 스타일을 LuaSnip 기반으로 완벽히 재현해 둔 luasnip-latex-snippets.nvim 같은 전용 확장 플러그인을 luasnip 위에 얹어서 사용하는 것을 추천합니다.
- 이 플러그인은 Neovim 유저들 사이에서 전설적인 LaTeX 고수(Gilles Castel)가 과거 UltiSnips로 구현했던 '타이핑하는 즉시 수식이 완성되는 자동 트리거 세트'를 현대적인 LuaSnip 버전으로 완벽하게 이식해 둔 결과물입니다.
- 이를 쓰시면 ff 입력 시 분수, sq 입력 시 루트, 인라인 수식 자동 완성 등이 과거 전성기 시절 손맛 그대로 작동합니다.

전 세계 LaTeX 유저들이 사용하는 표준 약어들
luasnip-latex-snippets.nvim 플러그인이 바로 이 Gilles Castel의 표준 키워드 세트를 100% 그대로 구현해 놓은 플러그인입니다.

이 플러그인을 설치하면, 수식 창 안에서 ff를 치면 \frac{}{}가 되고, sq를 치면 \sqrt{}가 되는 글로벌 표준 트리거가 즉시 활성화됩니다.
게다가 일반 텍스트를 칠 때는 발동하지 않고, 오직 $ 기호 안(수식 모드)에서만 똑똑하게 작동하는 기능까지 기본 내장되어 있습니다.

만약 이 표준 트리거 플러그인을 현재 사용 중인 blink.cmp + luasnip 환경에 설치하고 연동하는 구체적인 코드(lazy.nvim 등)가 필요하시다면 말씀해 주세요.

luasnip-latex-snippets.nvim을 설치하면 탭(Tab)을 누를 필요가 없는 '자동 트리거(Autorigger)' 상태로 수식 키워드들이 작동합니다. 즉, ff를 치면 탭을 안 눌러도 즉시 \frac{}{}로 바뀝니다.

이 플러그인의 기본 설정은 Gilles Castel 스타일인 알파벳 조합(ff, sq, al)입니다

luasnip-latex-snippets.nvim은 설치하는 순간 모든 스니펫이 완성창 없이 바로 터지는 autosnippet 타입으로 등록됩니다.

과거의 습관을 내려놓고 luasnip-latex-snippets.nvim이 제공하는 백틱 없는 순정 트리거(ff, sq, al)를 그대로 받아들이는 것은, 장기적으로 네오빔 환경뿐만 아니라 질문자님의 전체적인 작업 생산성에 엄청난 이득을 가져다줍니다.

현실적인 이유 3가지

1. 타이핑 효율성과 속도가 압도적으로 빨라집니다
순정 표준 방식: ff(분수), sq(루트), al(알파벳) 등은 모두 기본 타이핑 범위(Home Row) 안에서 해결됩니다. 손가락을 멀리 뻗을 필요 없이 f를 두 번 탁탁 치는 게 속도 면에서 비교가 안 될 정도로 빠릅니다.


2. '수식 모드 자동 감지' 덕분에 백틱이 없어도 안전합니다
과거 vim-latex에서 백틱을 썼던 가장 큰 이유는 일반 글자(예: 텍스트로 'ff'나 'alpha'를 칠 때)와 짚여서 스니펫이 오작동하는 것을 막기 위한 '안전장치'였습니다.
하지만 현대의 luasnip-latex-snippets.nvim은 내부에 Tree-sitter(구문 분석기)를 연동합니다.
오직 $ ... $ 이나 $$ ... $$ 내부(수식 모드)로 진입했을 때만 Neovim이 이를 똑똑하게 감지하여 ff를 \frac{}{}로 바꿉니다.

즉, 백틱이라는 안전장치가 더 이상 기술적으로 필요 없어진 시대가 되었습니다.

3. 다른 에디터와의 협업 및 '에코시스템' 이식성이 좋아집니다
이 Gilles Castel 스타일의 백틱 없는 표준 트리거는 현재 Neovim뿐만 아니라 Obsidian(옵시디언)의 LaTeX 스니펫 플러그인, VS Code의 LaTeX Utilities 등 현대적인 모든 노트 테이킹 및 에디터 생태계의 '기본 표준'으로 자리 잡았습니다.


-- 그럼 이제 백틱 없는 순정 luasnip-latex-snippets.nvim을 현재 blink.cmp + luasnip 환경에 에러 없이 깔끔하게 연동하는 최종 설치 코드를 전해드려도 될까요? 아니면 자주 쓰게 될 순정 트리거(ff, sq 외의 것들)들을 좀 더 구경해 보시겠습니까?

-- ---------------------------------------
-- ---------------------------------------

훌륭한 선택입니다. 기술이 발전한 만큼 순정 트리거의 규칙들은 매우 직관적이고 과학적으로 배치되어 있어, 한두 번만 쳐보면 금방 손에 익으실 겁니다.
질문하신 1) 자주 쓰게 될 순정 트리거 목록과, 많은 분이 고민하시는 2) 수식이 아닌 일반 LaTeX/KaTeX 구문(문서 구조 등) 해결법을 명확하게 나누어 설명해 드립니다.
------------------------------
## 1. 전 세계 고수들이 쓰는 순정 LaTeX 자동 트리거 (수식 중심)
이 트리거들은 오직 수식 모드($...$ 내부)에서만 발동되며, 탭을 누르지 않아도 타이핑 즉시 변환됩니다.
## ① 그리스 문자 및 기호 (자음 축약형)
기본 이름의 앞 글자나 자음을 조합하여 손가락 동선을 최소화합니다.

* al → \alpha
* be → \beta
* ga → \gamma
* de → \delta
* ep → \epsilon
* th → \theta
* la → \lambda
* om → \omega
* sig → \sigma
* ph → \phi

## ② 첨자 및 연산자 (수식 전개용)
위첨자, 아래첨자를 마우스나 방향키 없이 타이핑 흐름대로 적습니다.

* sr → ^2 (Square: 제곱)
* cb → ^3 (Cube: 세제곱)
* rd → ^{$1}$0 (지수 승수 입력 칸 생성)
* __ (언더바 2번) → _{$1}$0 (아래 첨자 칸 생성)
* sts → _\text{$1$}$0 (아래 첨자에 텍스트 적을 때, 예: $X_{\text{max}}$)
* sq → \sqrt{$1}$0 (Square root)
* ee → e^{$1}$0 (지수함수)

## ③ 수학적 관계 및 화살표

* == → &= (연립방정식 등에서 줄 맞출 때)
* != → \neq (Not equal)
* <= / >= → \le / \ge (이하 / 이상)
* -> / => → \to / \implies (우화살표 / 함의 기호)
* <- / <= → \leftarrow / \impliedby
* iff → \iff (필요충분조건 화살표 $\iff$)

## ④ 미적분, 극한, 행렬 (Calculus & Matrix)

* lim → \lim_{$1 \to $2} $0
* sum → \sum_{$1}^{$2} $0
* int → \int_{$1}^{$2} $0 (정적분)
* pmat → \begin{pmatrix} $1 \end{pmatrix} (소괄호 행렬)
* bmat → \begin{bmatrix} $1 \end{bmatrix} (대괄호 행렬)

------------------------------
## 2. "수식이 아닌 일반 LaTeX/KaTeX 구문은 어떻게 해결해?"
날카로운 질문입니다! luasnip-latex-snippets.nvim은 이름 그대로 '수식(수학 기호)'에 특화된 플러그인입니다. 따라서 수식 밖에서 쓰는 \section{}, \item, \begin{enumerate} 같은 일반 문서 구조 구문들은 서비스(자동 트리거)해 주지 않습니다.
이를 해결하는 표준적이고 가장 깔끔한 방법은 역할을 분담시키는 것입니다.
## 해결책 A: 현재 쓰고 계신 friendly-snippets와 협업하기 (기본 내장)
이미 질문자님의 blink.cmp에는 friendly-snippets가 들어있습니다. 이 모음집 안에는 수식이 아닌 일반 LaTeX 문서 구조용 스니펫이 방대하게 들어있습니다.

* 작동 방식: 수식 밖(일반 본문)에서 beg를 치면 완성창(blink.cmp)에 \begin...\end 구조가 뜹니다. sec를 치면 \section{}이 뜹니다. 이때는 완성창에서 Tab이나 Enter를 눌러서 입력하면 됩니다.
* 왜 이렇게 나누나요?: 본문을 타이핑할 때는 sec나 item 같은 단어가 실제 영단어(section, item 등)와 겹치기 때문에, 수식처럼 자동 트리거를 켜두면 본문 작성이 불가능해집니다. 따라서 일반 구문은 완성창을 보고 선택하는 것이 훨씬 안전합니다.

## 해결책 B: 자주 쓰는 본문 구문만 LuaSnip에 커스텀 자동 트리거로 등록하기
만약 \item 만큼은 완성창 안 보고 그냥 ii만 치면 바로 나오게 하고 싶다거나, \begin{enumerate}를 단축키로 만들고 싶다면, 앞서 배우신 LuaSnip 자체 설정을 활용해 수식 밖에서도 터지는 나만의 텍스트 스니펫을 몇 개만 등록해 두면 됩니다.

* 예시 (TeX 파일 본문용 커스텀 설정):

ls.add_snippets("tex", {
    -- 수식 밖 본문에서 it만 치면 바로 \item 이 되도록 설정
    s({ trig = "it", snippetType = "autosnippet" }, {
        t("\\item ")
    }),
    -- 거대한 환경을 만들 때
    s({ trig = "beg", snippetType = "autosnippet" }, {
        t("\\begin{"), i(1), t("}"),
        t({"", "\t"}), i(0),
        t({"", "\\end{"}), require("luasnip").clone_node(1), t("}")
    }),
})

------------------------------
## 요약 및 제안

   1. 수식 입력: luasnip-latex-snippets.nvim 플러그인의 백틱 없는 초고속 순정 자동 트리거에 손을 익힙니다. (ff, sq, al 등)
   2. 본문 구문: 이미 설정되어 있는 friendly-snippets + blink.cmp 완성창을 활용해 sec → \section 형태로 안전하게 입력합니다.
   3. 자주 쓰는 본문 단축키: \item 같이 너무 자주 써서 자동 트리거가 꼭 필요한 본문 구문만 LuaSnip에 몇 개 직접 등록합니다.

이렇게 조화롭게 셋업하면 과거 vim-latex 시절보다 훨씬 현대적이고 오작동 없는 완벽한 환경이 완성됩니다.
이제 이 구조를 내 Neovim 설정 파일에 에러 없이 한 방에 심을 수 있는 최종 플러그인 연동 및 설치 코드(lazy.nvim 기반)를 확인해 보시겠습니까?_


-- ---------------------------------------
-- ---------------------------------------

--]]

return {
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    -- 반드시 luasnip 뒤에 로드되도록 설정
    dependencies = { "L3MON4D3/LuaSnip" },
    -- tex 파일이 열릴 때만 로드 (성능 최적화)
    ft = { "tex", "markdown" },
    config = function()
      require("luasnip-latex-snippets").setup({
        -- 1. 오직 수식 모드($, $$ 안)에서만 작동하도록 보장
        use_treesitter = true,

        -- 2. 핵심: 기본 트리거 앞에 백틱(`)을 강제로 붙이도록 커스텀 매핑
        -- 플러그인이 제공하는 표준 키워드들의 발동 조건을 내 입맛대로 바꿉니다.
        custom_triggers = {
          -- [그리스 문자 백틱 연동]
          alpha = "`a",
          beta = "`b",
          gamma = "`g",
          delta = "`d",
          epsilon = "`e",
          theta = "`th",
          lambda = "`la",
          pi = "`p",
          sigma = "`s",
          omega = "`o",

          -- [수학 구조 백틱 연동]
          frac = "`/",   -- 이제 `/를 치면 분수 \frac{}{} 이 터집니다.
          sqrt = "`sq",  -- `sq를 치면 루트가 터집니다.
        },
      })
      
      -- 대중적인 vim-snippets/friendly-snippets 호환성 활성화
      require("luasnip_latex_snippets").setup_with_defaults()
    end,
  }
}





-- vim: set foldmethod=marker foldmarker={{{,}}}:
