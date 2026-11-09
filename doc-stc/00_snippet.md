-- ---------------------------------------
-- Yes, we're just executing a bunch of Vimscript, but this is the officially
-- endorsed method; see https://github.com/L3MON4D3/LuaSnip#keymaps
vim.cmd[[
" Use Tab to expand and jump through snippets
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'

" Use Shift-Tab to jump backwards through snippets
imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
]]

여기서 <Tab>와 <S-Tab>키믄 무슨 동작을 하는 거야?
한줄 한줄씩 해석해가며 설명해줘. 

-- ---------------------------------------

### 주요 단어 정리

* **snippet**: 미리 정의해 둔 코드 조각이나 템플릿을 의미합니다. (예: `for` 입력 후 탭을 누르면 `for` 루프 구조가 자동으로 완성되는 기능)
* **luasnip**: 네오빔(Neovim)에서 코드 스니펫을 관리하고 확장해 주는 대표적인 Lua 기반 플러그인입니다.

---

이 코드는 Neovim에서 **LuaSnip**이라는 스니펫 플러그인을 사용할 때, **`Tab` 키와 `Shift + Tab` 키로 스니펫을 완성하고 입력 창(플레이스홀더) 사이를 이동**할 수 있도록 설정하는 Vimscript 코드입니다.

쉽게 말해, 코드 조각을 불러온 뒤 **`Tab`을 누르면 다음 입력 칸으로 넘어가고, `Shift + Tab`을 누르면 이전 입력 칸으로 되돌아오는 기능**을 정의한 것입니다.

요청하신 대로 한 줄씩 상세히 해석해 드릴게요.

---

### 한 줄씩 상세 해석

```vim
" Use Tab to expand and jump through snippets

```

* **해석:** (주석) 탭 키를 사용해 스니펫을 확장(완성)하고 스니펫 사이를 이동합니다.

```vim
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 

```

* **`imap`**: 입력 모드(Insert Mode)에서 작동하는 키 매핑입니다.
* **`<silent>`**: 이 명령이 실행될 때 하단 명령줄에 아무런 메시지도 띄우지 마라는 뜻입니다. (깔끔한 화면 유지)
* **`<expr>`**: 뒤에 나오는 문자열을 단순 키 입력이 아니라, **삼항 연산자(조건문) 형태의 표현식으로 평가**해서 실행하라는 뜻입니다.
* **`<Tab>`**: 작동시킬 단축키가 `Tab` 키임을 지정합니다.
* **`luasnip#expand_or_jumpable() ? ... : ...`**:
* 만약(`?`) 현재 커서 위치에서 '스니펫을 확장할 수 있거나' 또는 '다음 입력 칸으로 이동할 수 있는 상태'라면,
* 앞에 있는 `'<Plug>luasnip-expand-or-jump'`(스니펫 확장/이동 기능)를 수행하고,
* 그렇지 않다면(`:`) 그냥 원래 `Tab` 키의 역할인 **일반 띄어쓰기(들여쓰기) 공백**을 입력합니다.



```vim
smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'

```

* **`smap`**: 선택 모드(Select Mode)에서 작동하는 키 매핑입니다. (스니펫이 작동하면 입력할 위치가 블록 지정되는데, 이때가 선택 모드입니다.)
* **`luasnip#jumpable(1) ? ... : ...`**:
* 만약 현재 상태에서 **앞으로 이동할 수 있는 다음 스니펫 입력 칸(`1`)이 존재한다면**,
* `'<Plug>luasnip-jump-next'`를 실행해 **다음 칸으로 커서를 이동**시키고,
* 이동할 칸이 없다면 그냥 원래 `Tab` 키로 작동합니다.



```vim
" Use Shift-Tab to jump backwards through snippets

```

* **해석:** (주석) Shift + Tab 키를 사용해 스니펫 안에서 뒤로(이전 칸으로) 이동합니다.

```vim
imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'

```

* **`imap`**: 입력 모드에서 작동합니다.
* **`<S-Tab>`**: 단축키가 `Shift + Tab` 키임을 지정합니다.
* **`luasnip#jumpable(-1) ? ... : ...`**:
* 만약 현재 상태에서 **뒤로 이동할 수 있는 이전 스니펫 입력 칸(`-1`)이 존재한다면**,
* `'<Plug>luasnip-jump-prev'`를 실행해 **이전 칸으로 커서를 되돌리고**,
* 이동할 이전 칸이 없다면 원래 `Shift + Tab` 키(역들여쓰기 등)로 작동합니다.



```vim
smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'

```

* **`smap`**: 선택 모드에서 작동합니다.
* 조건식과 결과는 바로 위 `imap` 내용과 동일하게 **이전 칸으로 커서를 되돌리는 기능**을 수행합니다.

---

### 요약

* **코드 작성 중 `Tab**`: 스니펫 코드가 짠 하고 나타나거나, 나타난 스니펫의 다음 입력 칸으로 커서가 이동합니다. (스니펫이 없을 땐 그냥 공백 입력)
* **코드 작성 중 `Shift + Tab**`: 스니펫 안에서 방금 입력했던 이전 칸으로 커서가 다시 되돌아갑니다.
