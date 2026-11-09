return {
  {
    "l3mon4d3/luasnip",
    event = { 'bufreadpost', 'bufnewfile' },
    version = '2.*',
    build = (function()
      if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
      return 'make install_jsregexp'
    end)(),
    dependencies = {
      {
        'rafamadriz/friendly-snippets',
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
          local snippet_path = vim.fn.stdpath('config') .. '/snippets'
          require('luasnip.loaders.from_vscode').lazy_load({
            paths = { snippet_path }
          })
          require("luasnip.loaders.from_lua").lazy_load({
            paths = { snippet_path }
          })
        end,
      },
      {
        "iurimateus/luasnip-latex-snippets.nvim",
        ft = { "tex", "markdown" },
        config = function()
          require("luasnip-latex-snippets").setup({
            use_treesitter = true
          })
          require("luasnip").config.setup({})
        end,
      },
    },
    opts = {
      enable_autosnippets = true, -- 전역 자동 스니펫 허용 (이게 꺼지면 일반 탭 스니펫으로 변함)
      update_events = "textchanged,textchangedi", -- 글자를 타이핑할 때마다 즉시 파싱
    },
    config = function(_, opts)
      local luasnip = require("luasnip")
      luasnip.setup(opts)
    end,
  },
}



