return {

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    -- -------------------------
    -- by stc
    --
      -- trext-objects 쿼리 제공을 위한 설정
    -- {{{
    -- treesitter가 제공하는 text-objects 를 사용하기 위해서
    -- nvim-treesitter-textobjects을 dependancies로 추가
    -- treesitter-textobjects가 제공하는 것을 mini.ai가 사용한다.
    -- mini.ai에서 사용한 @function.outer, @conditional.inner 같은 세부 영역 규칙은 nvim-treesitter-textobjects라는 확장 플러그인이 들고 있는 전용 쿼리 파일에 저장되어 있습니다.
    -- }}}
    --
-- 🌟 nvim-treesitter-textobjects를 의존성 플러그인으로 등록합니다.
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    -- by stc end
    -- -------------------------

    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
    config = function()
      -- ensure basic parser are installed
      -- 상태 및 문제 진단: 
      -- :checkhealth nvim-treesitter 명령어를 통해 파서가 제대로 설치되었고 에러 없이 동작하는지 종합적인 진단 리포트를 볼 수 있다.
      local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'latex', 'markdown_inline', 'query', 'vim', 'vimdoc' }
      require('nvim-treesitter').install(parsers)

      -- -------------------------
      -- by stc
      --
      -- trext-objects 제공을 위한 설정
      --
      -- nvim-treesitter v1.0 업데이트로 인해 폐기(deprecated)된 구버전 내장 주석 모듈의 호출을 강제로 건너뛰어 무한 경고 및 플러그인 간의 주도권 충돌을 방지하는 안전장치
      vim.g.skip_ts_context_commentstring_module = true -- 잠재적 충돌 방지용 안전장치

      -- by stc end
      -- -------------------------


      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)

      -- ============================================================================
      -- ============================================================================
        -- latex 파일에서 Vimtex 구문 엔진 사용하기 
        --
        -- * Tree-sitter와 VimTeX Syntax 엔진의 충돌
        -- - Neovim 설정에서 LaTeX 파일에 Tree-sitter 구문 강조(Syntax Highlighting)가 활성화되어 있으면, Vim 전통의 Syntax Engine이 비활성화(disabled)됩니다.
        -- - VimTeX의 vimtex#syntax#in_comment() 및 in_mathzone() 함수는 Vim의 내장 문법 엔진(synstack, synIDattr)을 기반으로 작동합니다. Tree-sitter가 활성화되면 VimTeX이 구문 위치를 읽지 못해 항시 0을 리턴하게 됩니다.
        -- 증상 확인법:
        -- .tex 버퍼에서 주석(% ...) 위에 커서를 두고 :echo vimtex#syntax#in_comment()를 실행했을 때 0이 출력된다면 현재 vimtex는 비활성화 되어 있다는 의미입니다.
        --
        --
        -- 🌟 VimTeX 구문 엔진과의 충돌 방지를 위한 LaTeX 예외 처리
        --
        -- cf) LaTeX 파일 사용에 있어, 만약 반드시 VimTeX의 Syntax 기능을 사용해야 한다면, Tree-sitter에서 latex 파서의 구문 강조(highlighting)를 꺼야 합니다.
        --
        -- 현재 이 파일(treesitter.lua)의 구성은, Neovim 최신 API(vim.treesitter.start)와 FileType 오토커맨드(autocmd)를 사용해 파일 타입별로 Treesitter를 활성화하는 고급 구조로 작성되어 있습니다.
        --
        -- 이 구조에서는 treesitter_try_attach 함수 내부에서 latex 또는 tex 파일타입일 때 vim.treesitter.start()가 실행되지 않도록 예외 처리(early return)를 해주어야 VimTeX의 내장 문법 엔진이 정상 작동합니다.
        --
        -- treesitter_try_attach 함수 시작 부분에 아래와 같이 예외 처리 구문을 넣어주시면 됩니다.
        -- ---
        -- treesitter_try_attach 함수는 파일이 열릴 때 Treesitter를 해당 버퍼에 붙여주는 역할을 합니다.
        -- 이곳 상단에서 language가 latex나 tex일 때 실행을 즉시 중단(return)시킴으로써, LaTeX 파일에서만 Treesitter 강조/폴딩/들여쓰기를 끄고 VimTeX 고유의 전통 Syntax Engine이 정상 동작하도록 만듭니다.
        --
        -- cf) 그냥 treesitter의 구문분석 엔진으로 treesitter를 사용하려면, 아래 코드를 주석처리하면 됨.
        -- 이미, treesitter의 구분분석을 이용해서 latex의 snippets들이 동작하도록 설정했음.
        -- 따라서, 아래 코드는 없어도 됨.
        -- 단지, ejmastnak의 설명문서가 vimtex 기반으로 쓰여 있어서... 필요한 것임.
        -- ejmastnak : https://ejmastnak.com/tutorials/vim-latex/intro/
        -- cf) 아래코드가 있어도 treesitter도 잘 작동하므로, treesitter와 같이 써도 됨. 즉, 구문분석을 treesitter로 이용할 건지, vimtex로 이용할 건지, 골라서 써도 됨
        --
        -- NOTE: VimTeX의 수많은 강력한 기능들 중 Vim 전통 구문 엔진(synIDattr)에 의존하는 것은 오직 vimtex#syntax#in_mathzone() 함수 하나뿐입니다.
        -- 즉, Tree-sitter를 이용해도, vimtex 기능주에 잃는 것은 오직 vimtex#syntax#in_mathzone() 단 하나뿐이며, 나머지 VimTeX의 모든 최고급 기능은 그대로 유지됩니다.
        -- cf) ejmastnak의 튜토리얼은 작성된 지 시간이 좀 지나 전통적인 Vim 및 구버전 VimTeX 방식 기준에 맞춰져 있으나, 현재 질문자님처럼 Tree-sitter 기반으로 LaTeX 환경을 구축한 Modern Neovim 세팅에서는 Tree-sitter를 켜고 개발하는 것이 표준입니다.
        -- 따라서, 안심하시고 아래 예외 코드를 제거한 뒤 사용하셔도 됩니다!
        --
        -- ============================================================================
        -- if language == 'latex' or language == 'tex' then
        --   return -- LaTeX 파일은 Treesitter를 연결하지 않고 VimTeX 내장 Syntax를 사용
        -- end
        -- 잘 되고 있음.
        -- ============================================================================
      -- ============================================================================


        -- check if parser exists and load it
        if not vim.treesitter.language.add(language) then return end
        -- enables syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        -- enables treesitter based folds
        -- for more info on folds see `:help folds`
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo.foldmethod = 'expr'

        -- check if treesitter indentation is available for this language, and if so enable it
        -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
        local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

        -- enables treesitter based indentation
        if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
      end

      local available_parsers = require('nvim-treesitter').get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

          if vim.tbl_contains(installed_parsers, language) then
            -- enable the parser if it is installed
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            -- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
            require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
          else
            -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
            treesitter_try_attach(buf, language)
          end
        end,
      })
    end,
  },

}


-- vim: set foldmethod=marker foldmarker={{{,}}}:
