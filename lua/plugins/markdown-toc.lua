return {
  "hedyhli/markdown-toc.nvim",
  ft = "markdown",  -- Lazy load on markdown filetype
  cmd = { "Mtoc" }, -- Or, lazy load on "Mtoc" command

  opts = {

    headings = {
      -- Include headings before the ToC (or current line for `:Mtoc insert`).
      -- Setting to true will include headings that are defined before the ToC
      -- position to be included in the ToC.
      before_toc = false,
    },

    -- Table or boolean. Set to true to use these defaults, set to false to disable completely.
    -- Fences are needed for the update/remove commands, otherwise you can
    -- manually select ToC and run update.
  fences = {
      enabled = true,
      -- 목차의 시작과 끝을 <!-- toc --> 주석으로 감싸 자동 업데이트를 도움
      -- These fence texts are wrapped within "<!-- % -->", where the '%' is
      -- substituted with the text.
      start_text = "mtoc-start",
      end_text = "mtoc-end"
      -- An empty line is inserted on top and below the ToC list before the being
      -- wrapped with the fence texts, same as vim-markdown-toc.
    },

    -- Enable auto-update of the ToC (if fences found) on buffer save
    auto_update = true,

    toc_list = {
      -- string or list of strings (for cycling)
      -- If cycle_markers = false and markers is a list, only the first is used.
      -- You can set to '1.' to use a automatically numbered list for ToC (if
      -- your markdown render supports it).
      markers = '*',
      cycle_markers = false,
      -- Example config for cycling markers:
      ----- markers = {'*', '+', '-'},
      ----- cycle_markers = true,
    },

  },


  config = function(_, opts)

    require('mtoc').setup(opts)

    -- 목차 생성 및 업데이트 수행 단축키
    -- 마크다운 파일 전용 단축키 설정Example
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        -- <leader>mt 를 누르면 목차가 생성되거나 최신 헤딩으로 업데이트됩니다.
        vim.keymap.set("n", "<leader>mt", ":Mtoc<CR>", { buffer = true, desc = "Markdown TOC 생성/업데이트" })
      end,
    })

  end,
}




