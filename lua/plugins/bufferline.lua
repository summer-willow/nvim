return {
  --[[
    Purpose: A tab-like interface for your buffers

    Usage:
      <S-h> : {"n"},  switch to previous buffer
      <S-l> : {"n"}, switch to next buffer
      <A-S-h> : {"n"}, move buffer to left
      <A-S-l> : {"n"}, move buffer to right
      <leader>x : {"n"},  close buffer

    Note:
      :h bufferline.nvim
  --]]

  'akinsho/bufferline.nvim',
  version = "*",  -- 최신 '안정화된(tagged)' 버전을 사용
  dependencies = 'nvim-tree/nvim-web-devicons', -- 아이콘 표시를 위해 필요
  opts = {
    options = {
      mode = "buffers", -- 탭이 아닌 버퍼 모드로 사용
      numbers = "ordinal", -- 버퍼 번호를 표시 (이동 시 편리함)

      -- ---------------------
      -- 2026-07-25 15:04:53
      -- [핵심 1] 버퍼를 닫을 때 창 구도를 깨뜨리지 않고 안전하게 제거
      close_command = "bdelete! %d",
      right_mouse_command = "bdelete! %d",
      -- 2026-07-25 15:04:58, end
      -- ---------------------

      -- 사이드바(netrw 등)가 열렸을 때 탭이 가려지지 않게 밀어줌
      offsets = {
        {
          filetype = "netrw",
          text = "File Explorer",
          text_align = "left",
          separator = true,
        },
      },

      -- cf)
      -- 자동 정렬 기능 (Sorting)
      -- "extension", "relative_directory", "directory", "tabs" 등 선택 가능
      -- ex)
      -- extension: 파일 확장자별로 모으기 (예: .lua 파일끼리, .txt 파일끼리)
      -- directory: 폴더별로 모으기 (같은 프로젝트 폴더 파일끼리)
      -- sort_by = "extension",
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)

    -- 단축키 설정: Alt + h/l 로 buffer 이동
    -- --> 단축키 설정: Shift + h/l 로 buffer 이동, (from LazyVim)
    vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })
    vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })

    -- 버퍼 순서 조작 -  왼쪽/오른쪽으로 옮기기 (Alt + Shift + h/l)
    vim.keymap.set("n", "<A-S-h>", "<cmd>BufferLineMovePrev<CR>", { desc = "Move buffer left" })
    vim.keymap.set("n", "<A-S-l>", "<cmd>BufferLineMoveNext<CR>", { desc = "Move buffer right" })

    -- ---------------------
    -- 2026-07-25 15:01:46, 
    -- [핵심 2] 안전한 버퍼 닫기 단축키 매핑 (bdelete 대체)
    -- 현재 열려있는 버퍼를 안전하게 닫고 이전 버퍼로 포커스 이동
    vim.keymap.set("n", "<leader>bx", function()
      local bd = require("bufferline")
      -- 만약 개별 버퍼 삭제 루틴을 사용하고 싶다면 아래 함수 사용:
      local current_buf = vim.api.nvim_get_current_buf()
      bd.cycle(-1) -- 이전 버퍼로 먼저 안전하게 이동
      vim.cmd("bdelete! " .. current_buf) -- 이전 버퍼 삭제
    end, { desc = "Close Current Buffer Safely" })
    -- 2026_07_25_15_02_01, end
    -- ---------------------

    -- 숫자를 이용해, 특정 버퍼로 점프하기
    for i = 1, 9 do
      vim.keymap.set("n", "<leader>" .. i, function() require("bufferline").go_to(i, true) end, { desc = "Go to buffer " .. i })
    end

  end,
}
