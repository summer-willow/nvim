--
--

-- --------------------------------------------
-- [주의] 나중에 nvim-ufo 플러그인을 설치하게 되면 
-- 아래의 autocmd는 ufo 설정과 충돌하므로 삭제해야 합니다.
-- ----------------------
-- {{{
-- ----------------------
-- [코드 접기(Folding) 설정]
-- Neovim 본체의 접기 기능을 Treesitter 엔진과 연결함
--
-- cf) 나중에 nvim-ufo 설치 시, 제거해야 함.
-- 이유: nvim-ufo는 내부적으로 Treesitter 파서를 직접 활용하여 더 고성능의 접기를 제공합니다. nvim-ufo가 스스로 최적의 접기 방식을 제어하도록 내버려 두는 것이 가장 깔끔하게 작동합니다.
--
-- Neovim의 접기 방식을 '계산식(expr)'으로 설정
-- }}}


-- vim.opt.foldmethod = "expr"
-- -- Treesitter가 계산해주는 함수를 Vim의 접기 공식으로 할당함
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- -- 파일을 열었을 때 모든 코드가 접혀있지 않고 다 펴진 상태(Level 99)로 시작하게 함
-- vim.opt.foldlevel = 99

-- [추가] 모든 버퍼에서 Treesitter 접기 강제 활성화
-- Neovim이 파일을 열 때(FileType 이벤트) 실행됩니다.
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "lua", "python" }, -- 필요한 언어 추가
    callback = function()
        -- Treesitter를 이용해 접기를 수행하도록 설정
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        -- 파일을 열었을 때 모든 접기를 펼쳐둔 상태로 시작 (취향껏 조절)
        vim.opt_local.foldlevel = 99
        -- vim.opt_local.foldlevel = 0
    end,
})
-- ----------------------
-- --------------------------------------------

-- --------------------------------------------

-- --------------------------------------------

-- --------------------------------------------

-- --------------------------------------------

-- --------------------------------------------

-- --------------------------------------------
--
--
-- vim: set foldmethod=marker foldmarker={{{,}}}:
