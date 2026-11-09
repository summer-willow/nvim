-- -----------------------------------------------------------------------------
-- VimTeX Math Mappings Configuration (`$ -> m`)
-- -----------------------------------------------------------------------------

-- cf) vim.cmd 사용
-- vim.cmd[[
-- " Use `dsm` to delete surrounding math (replacing the default shortcut `ds$`)
-- nmap dsm <Plug>(vimtex-env-delete-math)
-- ]]

-- 주의 사항: vim.keymap.set은 기본적으로 noremap = true로 동작합니다. 하지만 <Plug>(...) 형태의 비주얼/플러그인 매핑 키를 호출할 때는 반드시 remap = true 옵션을 지정해야 Vim이 <Plug>를 올바른 기능으로 해석하여 실행할 수 있습니다.

-- 1. Delete surrounding math (`ds$` -> `dsm`)
vim.keymap.set('n', 'dsm', '<Plug>(vimtex-env-delete-math)', {
  remap = true,   -- <Plug> 매핑을 해석하기 위해 remap 옵션이 반드시 필요합니다.
  buffer = true,  -- tex 파일 버퍼에만 적용되도록 설정
  desc = 'VimTeX: Delete surrounding math',
})

-- 2. Change surrounding math (`cs$` -> `csm`)
vim.keymap.set('n', 'csm', '<Plug>(vimtex-env-change-math)', {
  remap = true,
  buffer = true,
  desc = 'VimTeX: Change surrounding math',
})

-- 3. Toggle between inline and display math (`ts$` -> `tsm`)
vim.keymap.set('n', 'tsm', '<Plug>(vimtex-env-toggle-math)', {
  remap = true,
  buffer = true,
  desc = 'VimTeX: Toggle inline/display math',
})

-- (선택) 기존 $ 기반 단축키를 완전히 끄고 싶을 경우 해제
-- vim.keymap.set('n', 'ds$', '<Nop>', { buffer = true })
-- vim.keymap.set('n', 'cs$', '<Nop>', { buffer = true })
-- vim.keymap.set('n', 'ts$', '<Nop>', { buffer = true })

-- -----------------------------------------------------------------------------
-- VimTeX Text Objects Mapping
-- -----------------------------------------------------------------------------

-- omap(Operator-pending 모드), xmap(Visual 모드)
-- vim.cmd[[ ... ]] 사용
-- vim.cmd[[
-- " Use `ai` and `ii` for the item text object
-- omap ai <Plug>(vimtex-am)
-- xmap ai <Plug>(vimtex-am)
-- omap ii <Plug>(vimtex-im)
-- xmap ii <Plug>(vimtex-im)
--
-- " Use `am` and `im` for the inline math text object
-- omap am <Plug>(vimtex-a$)
-- xmap am <Plug>(vimtex-a$)
-- omap im <Plug>(vimtex-i$)
-- xmap im <Plug>(vimtex-i$)
-- ]]

-- - operator-pending mode: 연산자 대기 모드 (d, c, y 등을 누른 후 대상 text-object를 기다리는 상태)
-- - visual mode: 비주얼 모드 (영역 선택 상태)
--
-- { 'o', 'x' } 모드 배열 사용
--   'o': Operator-pending 모드 (d, c, y 등의 연산자를 누르고 대기하는 상태)
--   'x': Visual 모드 (v, V, <C-v> 등의 영역 선택 상태)

-- 1. Use `ai` and `ii` for the item text object (환경 내 \item 요소 선택)
vim.keymap.set({ 'o', 'x' }, 'ai', '<Plug>(vimtex-am)', {
  remap = true,
  buffer = true,
  desc = 'VimTeX: Select an item (a)',
})

vim.keymap.set({ 'o', 'x' }, 'ii', '<Plug>(vimtex-im)', {
  remap = true,
  buffer = true,
  desc = 'VimTeX: Select inner item (i)',
})

-- 2. Use `am` and `im` for the inline math text object (수식 영역 선택: $...$)
-- i$/a$(im/am)은 오직 Inline / Display Math '기호'(\(...\), \[...\], $...$) 전용 text-object입니다.
vim.keymap.set({ 'o', 'x' }, 'am', '<Plug>(vimtex-a$)', {
  remap = true,
  buffer = true,
  desc = 'VimTeX: Select around inline math (a)',
})

vim.keymap.set({ 'o', 'x' }, 'im', '<Plug>(vimtex-i$)', {
  remap = true,
  buffer = true,
  desc = 'VimTeX: Select inner inline math (i)',
})



-- ----------------------------------------


