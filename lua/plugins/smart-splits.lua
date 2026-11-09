return {
  'mrjones2014/smart-splits.nvim',
  lazy = false, -- 단축키가 항상 작동하도록 상시 로드
  config = function()
    local ss = require('smart-splits')

    -- smart-splits의 이동 명령을 단축키로 지정합니다.
    -- 이 단축키들은 윈도우 터미널에서는 nvim 창 이동으로, WezTerm에서는 통합 창 이동으로 자동 전환됩니다.
    vim.keymap.set('n', '<C-h>', ss.move_cursor_left, { desc = 'Go to Left Window/Pane' })
    vim.keymap.set('n', '<C-j>', ss.move_cursor_down, { desc = 'Go to Down Window/Pane' })
    vim.keymap.set('n', '<C-k>', ss.move_cursor_up, { desc = 'Go to Up Window/Pane' })
    vim.keymap.set('n', '<C-l>', ss.move_cursor_right, { desc = 'Go to Right Window/Pane' })
  end,
}
