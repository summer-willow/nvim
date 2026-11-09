-- --------------------------------------
-- 마크다운에서 || 기호 사이의 텍스트를 숨기는 설정
-- conceal 기능 활용
-- 활용: 단어 공부 할 때, 다음과 같이 적으면, ||...||는 ? 으로 표시됨
-- 커서를 그 줄에 옮겨놓아야 만, 그 뜻이 (||...||) 보임.
-- 단어 : ||한글 뜻|| 
-- --------------------------------------
-- 1. Conceal 레벨 강제 설정 (2: 숨기고 대체 문자 표시, 0: 모두 보임)
vim.opt_local.conceallevel = 2
-- 2. 커서가 있는 줄은 숨김 해제 (공부 모드)
vim.opt_local.concealcursor = ""

-- 3. 기존 매치 제거 (중복 방지)
for _, match in ipairs(vim.fn.getmatches()) do
    if match.group == "Conceal" then vim.fn.matchdelete(match.id) end
end

-- 4. 정규식을 이용한 강제 숨김 처리
-- ||로 시작해서 ||로 끝나는 부분을 찾아 '?'로 숨깁니다.
vim.fn.matchadd("Conceal", "||.\\{-}||", 10, -1, { conceal = "?" })

-- 5. 기호(||) 자체를 아예 안 보이게 하고 싶다면 아래 주석을 해제하세요.
-- vim.fn.matchadd("Conceal", "||", 11, -1, { conceal = "" })

-- -- 4. 색상 설정 (선택 사항: 물음표 색상을 강조하고 싶을 때)
vim.cmd([[highlight Conceal guifg=#ff9e64 gui=bold]])



-- -- ------------------------------------------------------
-- # Anki 앱으로 변환
--
-- Question:
--
-- 단어장을 .md 형식으로 작성하면, Anki 앱으로 변환 용이하다고 했는데... 변환하는 방법을 자세히 알려줘. 예시도 보여주며, 자세히 설명해줘.
--
-- Answer:
--
-- Neovim에서 마크다운으로 단어장을 만들면 **Anki(암기)**라는 강력한 도구와 결합했을 때 시너지가 엄청납니다. 마크다운의 텍스트 구조가 Anki가 인식하는 데이터 형식(CSV 또는 탭 구분 파일)과 매우 유사하기 때문이죠.
--
-- 가장 깔끔하고 자동화하기 쉬운 두 가지 방법을 소개해 드립니다.
--
-- 1. 방법 A: 가장 단순한 방법 (CSV 변환)
--
-- Anki는 **"컴마(,)나 탭으로 구분된 파일"**을 읽어올 수 있습니다. 마크다운 파일의 특정 규칙을 이 형식에 맞추면 됩니다.
--
-- 단어장 작성 규칙
-- 마크다운 파일에서 단어와 뜻을 특정 기호(예: : 또는 |)로 구분하여 작성합니다.
--
-- ```Markdown
-- Apple: 사과
-- Banana: 바나나
-- Resilient: 회복력 있는
-- ```
--
-- * 변환 절차
-- - 추출: Neovim에서 필요한 단어들만 복사합니다.
--
-- - 저장: vocab.txt 파일로 저장합니다.
--
-- - Anki에서 가져오기:
--
--     - Anki 실행 -> 파일(File) -> 가져오기(Import) 선택.
--
--     - vocab.txt 선택.
--
--     - - Field separator를 Other로 선택하고 :를 입력합니다.
--
--     - '가져오기' 클릭.
--
-- 2. 방법 B: 플러그인 활용 (AnkiConnect + Obsidian/Neovim)
--
-- 만약 수동으로 파일을 옮기는 게 귀찮다면, AnkiConnect라는 API 플러그인을 사용하여 nvim에서 작성한 내용을 바로 Anki로 쏘아올릴 수 있습니다.
--
-- 추천 도구: Anki.nvim 또는 AnkiConnect
-- Neovim 유저들 사이에서는 Anki.nvim 같은 플러그인을 쓰기도 하지만, 세팅이 복잡할 수 있습니다. 가장 안정적인 흐름은 다음과 같습니다.
--
-- 마크다운 형식 예시 (Card 기준)
--     Anki의 '앞면'과 '뒷면'을 구분하는 규칙을 정합니다.
--
-- ```Markdown
-- # Vocab List
--
-- ## Apple
-- 사과, 빨간 과일
--
-- ## Resilient
-- ||회복력 있는||
-- > 역경에서 빨리 회복하는 성질
-- ```
--
-- * 변환 꿀팁: Python 스크립트 활용
--
-- 간단한 파이썬 스크립트를 하나 만들어두면 nvim에서 버튼 하나로 Anki용 파일을 만들 수 있습니다.
--
-- ```Python
-- # simple_converter.py
-- import csv
--
-- with open('my_vocab.md', 'r', encoding='utf-8') as f:
--     lines = f.readlines()
--
-- with open('anki_ready.csv', 'w', newline='', encoding='utf-8') as f:
--     writer = csv.writer(f, delimiter='\t')
--     for line in lines:
--         if ':' in line:
--             word, meaning = line.split(':', 1)
--             writer.writerow([word.strip(), meaning.strip()])
-- ```
--
-- 3. 최고의 효율: 'Anki용 마크다운' 작성 팁
--
-- Anki에 넣었을 때 가장 예쁘고 효율적으로 학습하려면 다음 포맷을 추천합니다.
--
-- - 태그 활용: #2026-02-02 같은 날짜 태그를 달아두면 Anki에서 필터링하기 좋습니다.
--
-- - Cloze 삭제 (빈칸 채우기): Anki의 강력한 기능입니다.
--
-- .    마크다운에 이렇게 적으세요: The city is {{c1::resilient}} to floods.
--
--     Anki로 가져가면 resilient 부분만 빈칸으로 뚫려서 문제로 나옵니다.
--
-- Conceal 기호 활용: 우리가 만든 ||뜻|| 기호를 Anki가 인식하게 하려면, 가져오기 전에 ||를 탭(\t)으로 치환만 하면 됩니다. (nvim 명령어: :%s/||/\t/g)
--
-- 4. 요약 프로세스 (추천 루틴)
--
-- 1. Neovim에서 단어를 적는다. (예: 단어 || 뜻)
--
-- 2. 공부가 끝나면 nvim에서 기호를 탭으로 바꾼다. (:%s/ || /\t/g)
--
-- 3. .txt로 저장한다.
--
-- 4. Anki에서 Import를 눌러 한 번에 넣는다.
--
-- 어떤 방식이 더 편해 보이시나요? 만약 파이썬 등을 활용해 "nvim에서 바로 Anki로 전송"하는 더 자동화된 워크플로우가 궁금하시다면 그에 맞는 설정을 가이드해 드릴 수 있습니다.
--
-- -- ------------------------------------------------------

