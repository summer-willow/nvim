# keybinding
    ## bufferline.nvim
    <S-h> : {"n"},  switch to previous buffer, (bufferline.nvim)
    <S-l> : {"n"}, switch to next buffer, (bufferline.nvim)
    <A-h> : {"n"}, move buffer to left, (bufferline.nvim)
    <A-l> : {"n"}, move buffer to right, (bufferline.nvim)
    <leader>x : {"n"},  close buffer, (bufferline.nvim)

    ## neo-tree.nvim (file  explorer)

    vim.keymap.set( "n", "<leader>e", ":Neotree toggle<CR>", { desc = "Neo-tree [E]xplorer" }
    )
    -- 설정 폴더(config)를 neo-tree로 열기
    vim.keymap.set("n", "<leader>fc", function()
      local config_path = vim.fn.stdpath("config")
      vim.cmd("Neotree reveal dir=" .. config_path)
    end, { desc = "Neo-tree: [F]ind [C]onfig files" })

    ==> cf) kickstart.nvim에서 telescope를 이용해서 이미 제공하고 있음
    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })

# test
abc
bbb
ccc
ddd
  aaa
bbb
  akdj
jdf
  ojdstd

    ccc


* abc
dkdj
    - kdkd
    skdj
    adk
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
|   |   |   |
    |

- aaa
- bbb
    - ccc       dkfj
    - ddd
- akdj
