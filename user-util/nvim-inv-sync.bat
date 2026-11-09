@echo off
goto START_CODE

==================================================
=== batch 파일의 주석
- 평소 일반적인 주석은 한 줄씩 ::를 쓰세요.
    - 동작 원리: 원래 배치 파일에서 단일 콜론(:label)은 특정 위치로 점프하기 위한 '책갈피(레이블)' 역할을 합니다. 그런데 콜론을 두 개(::) 연속으로 쓰면 컴퓨터가 아예 읽지도 못하는 잘못된 레이블이 되어 처리를 완전히 생략(무시)해 버립니다.
- 조건문(if) 내부에서는 안전하게 REM (REMARK의 약자)을 쓰세요.
- 아주 긴 여러 줄 주석을 달 때는 goto 꼼수를 활용하시면 훨씬 편합니다.
    REM goto START_CODE
    여기에 있는 모든 것은 건너뛰므로, 주석 역활을 한다.
    REM :START_CODE
==================================================


:START_CODE
:: 실제 프로그램 명령은 여기서부터 시작됩니다.

:: 1. nvim이 이미 켜져(On) 있는 Neovim 서버로 파일 경로(%1)와 줄 번호(%2)를 다이렉트로 전송
nvim --headless --server localhost:12345 --remote-send "<C-\><C-n>:e %1<CR>:%2<CR>" 2>nul

:: 2. 만약 Neovim이 아예 꺼져(Off) 있다면 새로 켜기
if %errorlevel% neq 0 (
    start "" nvim --listen localhost:12345 -c "e %1" -c "%2"

    REM 만약 nvim 시작 시 서버가 시작되게 설정했다면,
        REM ex)
        REM nvim의 init.lua에 Neovim이 켜질 때 자동으로 VimTeX 연동용 로컬 서버를 개설
        REM vim.fn.serverstart('localhost:12345')
    REM nvim이 시작되면서 서버가 자동 활성화 되므로
    REM 아래의 설정으로 충분. 
    REM 아래 설정으로 안 바꾸면 nvim이 Off된 상태에서 
    REM inverse sync 시 에러가 나옴.
    REM start "" nvim -c "e %1" -c "%2"
)
:: SumtraPDF의 설정 > 옵션 > 역방향 탐색 설정에, 이 파일의 경로를 적용
:: C:\user\stc\Appdata\Local\nvim\user-util]nvim-inv-sync.bat "%f" %l

