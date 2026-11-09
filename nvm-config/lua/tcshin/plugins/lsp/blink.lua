-- --------------------------------------
-- from kickstart.nvim
--
--
return { -- Autocompletion

  {
    -- -----------------------------------------------
    -- 'folke/lazydev.nvim',
    -- : Faster LuaLS setup for Neovim
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    --
    -- 단순히 경고(Warning)를 없애는 것을 넘어, Neovim 설정을 할 때 LSP가 **"이게 Neovim 내부 API인지, 아니면 그냥 일반 Lua 코드인지"**를 구별하게 해주는 역활 
    --
    -- cf)
    -- 오직 "Neovim 관련 개발"을 할 때만 필요함. (다른 곳에서는 안쓰임)
    --
    -- 전에는 vim API를 외우거나 문서를 뒤졌지만, 이제는 lazydev 덕분에 에디터 안에서 모든 API 명세와 설명을 즉시 확인할 수 있게 되었습니다.
    --
    -- Neovim 설정을 만지실 때 **"경고 줄이 사라지고, vim. 뒤에 엄청난 양의 추천 목록이 뜬다"**면 이 플러그인이 제 역할을 아주 잘 수행하고 있는 것입니다.
    --
    -- 이제 Neovim 설정 파일(init.lua)에서 vim.을 입력해 보세요. 수많은 함수 목록이 쏟아져 나올겁니다
    -- -----------------------------------------------

    'folke/lazydev.nvim',
    ft = 'lua', -- Lua 파일에서만 이 플러그인을 활성화
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        -- 'vim.uv'라는 단어가 코드에 보이면, 저수준 라이브러리인 luv의 타입 정보도 불러옵니다.
        -- ${3rd}/luv/library: Neovim의 비동기 처리를 담당하는 luv 라이브러리의 정보를 연결합니다. 0.10 버전부터 vim.loop 대신 vim.uv를 쓰기로 했는데, 이를 위한 최신 설정입니다.
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },


  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },

      -- 'folke/lazydev.nvim',
      -- 조치: dependencies 리스트 상단에 { 'folke/lazydev.nvim', ft = 'lua', opts = { ... } }를 추가하는 것을 권장합니다.
      { 'folke/lazydev.nvim',
        ft = 'lua', -- Lua 파일에서만 이 플러그인을 활성화
        opts = {
          library = {
            -- Load luvit types when the `vim.uv` word is found
            -- 'vim.uv'라는 단어가 코드에 보이면, 저수준 라이브러리인 luv의 타입 정보도 불러옵니다.
            -- ${3rd}/luv/library: Neovim의 비동기 처리를 담당하는 luv 라이브러리의 정보를 연결합니다. 0.10 버전부터 vim.loop 대신 vim.uv를 쓰기로 했는데, 이를 위한 최신 설정입니다.
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      },

    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  }
}

-- --------------------------------------
-- from gemini
--
-- return {
--   'saghen/blink.cmp',
--   -- use a release tag to download pre-built binaries
--   version = '1.*',
--   -- 1. 버전 관리: 최신 릴리즈 버전을 사용합니다.
--   -- version = '*',
--
--   ---@module 'blink.cmp'
--   ---@type blink.cmp.Config
--   opts = {
--     -- 'default'를 사용하면 기본 키맵(Tab으로 선택 등)이 적용됩니다.
--     -- 하지만 고수들은 자신만의 직관적인 매핑을 선호하죠.
--     keymap = {
--       preset = 'default',
--       -- 여기서 원하는 대로 커스텀 가능합니다.
--       -- ['<C-space>'] = { 'show', 'show_documentation', 'hide' },
--     },
--
--     -- 2. 외형 (Appearance)
--     appearance = {
--       -- 너드 폰트를 사용하여 아이콘을 표시합니다.
--       use_nvim_cmp_as_default = true,
--       nerd_font_variant = 'mono'
--     },
--
--     -- 3. 정보 소스 (Sources) - 핵심 파트
--     sources = {
--       -- 기본적으로 lsp, path, snippets, buffer에서 정보를 가져옵니다.
--       default = { 'lsp', 'path', 'snippets', 'buffer' },
--
--       -- lazydev를 연동하는 중요한 부분입니다. 
--       -- Neovim 설정 파일(.lua)일 때만 특별 대우를 해줍니다.
--       providers = {
--         lazydev = {
--           name = "LazyDev",
--           module = "lazydev.integrations.blink",
--           -- lsp보다 우선순위를 높여서 Neovim API가 먼저 뜨게 합니다.
--           score_offset = 100,
--         },
--       },
--     },
--
--     -- 4. 함수 시그니처 (Signature)
--     -- 함수 괄호 안에 인자를 넣을 때 무엇을 넣어야 하는지 실시간으로 보여줍니다.
--     signature = { enabled = true }
--   },
-- }


-- --------------------------------------
-- from blink.cmp github
--
-- {
--   'saghen/blink.cmp',
--   -- optional: provides snippets for the snippet source
--   dependencies = { 'rafamadriz/friendly-snippets' },
--
--   -- use a release tag to download pre-built binaries
--   version = '1.*',
--   -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
--   -- build = 'cargo build --release',
--   -- If you use nix, you can build from source using latest nightly rust with:
--   -- build = 'nix run .#build-plugin',
--
--   ---@module 'blink.cmp'
--   ---@type blink.cmp.Config
--   opts = {
--     -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
--     -- 'super-tab' for mappings similar to vscode (tab to accept)
--     -- 'enter' for enter to accept
--     -- 'none' for no mappings
--     --
--     -- All presets have the following mappings:
--     -- C-space: Open menu or open docs if already open
--     -- C-n/C-p or Up/Down: Select next/previous item
--     -- C-e: Hide menu
--     -- C-k: Toggle signature help (if signature.enabled = true)
--     --
--     -- See :h blink-cmp-config-keymap for defining your own keymap
--     keymap = { preset = 'default' },
--
--     appearance = {
--       -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
--       -- Adjusts spacing to ensure icons are aligned
--       nerd_font_variant = 'mono'
--     },
--
--     -- (Default) Only show the documentation popup when manually triggered
--     completion = { documentation = { auto_show = false } },
--
--     -- Default list of enabled providers defined so that you can extend it
--     -- elsewhere in your config, without redefining it, due to `opts_extend`
--     sources = {
--       default = { 'lsp', 'path', 'snippets', 'buffer' },
--     },
--
--     -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
--     -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
--     -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
--     --
--     -- See the fuzzy documentation for more information
--     fuzzy = { implementation = "prefer_rust_with_warning" }
--   },
--   opts_extend = { "sources.default" }
-- }
-- --------------------------------------
