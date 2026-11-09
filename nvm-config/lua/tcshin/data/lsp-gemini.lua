-- return {
--   -- 1. Mason: 외부 바이너리(서버 프로그램) 설치 관리자
--   {
--     "mason-org/mason.nvim",
--     build = ":MasonUpdate", -- 설치 시 패키지 색인을 업데이트
--     opts = {
--       ui = {
--         border = "rounded",
--         icons = {
--           package_installed = "✓",
--           package_pending = "➜",
--           package_uninstalled = "✗",
--         },
--       },
--     },
--   },
--
--   -- 2. Mason-lspconfig: Mason과 lspconfig 사이의 가교 역할
--   {
--     "mason-org/mason-lspconfig.nvim",
--     dependencies = { "mason-org/mason.nvim" },
--     opts = {
--       -- 자동으로 설치하고 싶은 서버 목록
--       ensure_installed = {
--         "lua_ls", -- Neovim 설정용 Lua 서버
--         "clangd", -- C/C++용 서버
--       },
--     },
--   },
--
--   -- 3. nvim-lspconfig: 설치된 서버를 Neovim과 실제 연결
--   {
--     "neovim/nvim-lspconfig",
--     dependencies = {
--       "mason-org/mason-lspconfig.nvim",
--       -- 자동완성 기능을 위해 nvim-cmp와 연결할 때 필요한 확장 (나중에 추가 예정)
--       -- "hrsh7th/cmp-nvim-lsp", 
--     },
--     config = function()
--
--       -- local lspconfig = require("lspconfig")
--       -- ==> error: 
--       -- require('lspconfig')라는 방식 자체가 이제 구식
--       -- Neovim 자체에 LSP 설정 기능이 많이 내장되면서, 기존 방식이 **Deprecated(곧 삭제될 기능)**로 처리되었습니다.
--       -- Neovim 0.11부터는 vim.lsp.config라는 내장 기능을 쓰라고 권장하고 있습니다.
--       --  require('lspconfig')를 직접 호출하지 않고, mason-lspconfig의 핸들러 기능을 이용하는 것이 가장 깔끔하고 에러가 없습니다.
--       --
--       -- [수정 포인트] lspconfig를 변수에 담지 않고 mason-lspconfig의 기능을 활용합니다.
--       --
--       -- local mlsp = require("mason-lspconfig")
--       --
--       -- [방어적 코드] mason-lspconfig가 정상적으로 있는지 확인
--       local ok, mlsp = pcall(require, "mason-lspconfig")
--
--       if not ok then
--         vim.notify("mason-lspconfig를 불러오는 데 실패했습니다!", vim.log.levels.ERROR)
--         return
--       end
--
--
--
--
--
--
--
--
--
--       -- 핸들러 설정
--       -- Mason-lspconfig에서 설치한 서버들에 대해 설정을 수행
--       -- 각 서버별로 'setup'을 해줘야 Neovim이 서버를 인식합니다.
--
--       mlsp.setup_handlers({
--         -- 기본 핸들러: 특별한 설정이 없는 모든 서버에 적용
--         function(server_name)
--           require("lspconfig")[server_name].setup({})
--         end,
--
--         -- 특정 서버별 맞춤 설정 (lua_ls 등)
--         ["lua_ls"] = function()
--           require("lspconfig").lua_ls.setup({
--             settings = {
--               Lua = {
--                 diagnostics = {
--                   globals = { "vim" }, -- 'vim' 전역 변수 경고 해결
--                   -- Neovim의 'vim' 전역 변수를 인식하게 하여 경고(Warning)를 방지함
--                 },
--               },
--             },
--           }) 
--         end,
--       })
--
--       -- LSP 관련 단축키 설정 (LSP가 활성화되었을 때만 작동)
--       vim.api.nvim_create_autocmd("LspAttach", {
--         group = vim.api.nvim_create_augroup("UserLspConfig", {}),
--         callback = function(ev)
--           local opts = { buffer = ev.buf }
--
--           -- 고수의 향기가 나는 LSP 단축키들
--           vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "정의로 이동 (Go Definition)", buffer = ev.buf })
--           vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "설명 팝업 (Hover)", buffer = ev.buf })
--           vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "이름 변경 (Rename)", buffer = ev.buf })
--           vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "코드 액션 (Code Action)", buffer = ev.buf })
--
--           -- 우리가 아까 설정한 Telescope와 연동 (참조 찾기)
--           vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "사용처 찾기 (References)", buffer = ev.buf })
--         end,
--       })
--     end,
--   },
-- }


-- -----------------------------------------------------
-- 2nd
return {
  -- 1. Mason: 설치 관리자
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ui = { border = "rounded" },
    },
  },

  -- 2. Mason-lspconfig & nvim-lspconfig 통합 설정
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig", -- lspconfig를 여기서 의존성으로 묶습니다.
    },
    config = function()
      local mlsp = require("mason-lspconfig")
      local lspconfig = require("lspconfig")

      -- 기본 설치 목록
      mlsp.setup({
        ensure_installed = { "lua_ls", "clangd" },
      })

      -- [핵심] setup_handlers 직접 호출
      -- 만약 여기서도 nil 에러가 난다면 플러그인 폴더를 강제로 지워야 합니다.
      mlsp.setup_handlers({
        -- 기본 핸들러
        function(server_name)
          lspconfig[server_name].setup({})
        end,

        -- Lua 전용 설정
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
              },
            },
          })
        end,
      })

      -- LSP 단축키 설정 (LspAttach)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "정의로 이동", buffer = ev.buf })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "설명 팝업", buffer = ev.buf })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "이름 변경", buffer = ev.buf })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "코드 액션", buffer = ev.buf })
          vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "사용처 찾기", buffer = ev.buf })
        end,
      })
    end,
  },
}



-- -----------------------------------------------------
-- -----------------------------------------------------
-- -----------------------------------------------------




-- -----------------------------------------------------
-- -----------------------------------------------------
-- -----------------------------------------------------
-- -----------------------------------------------------
