-- ------------------------------------------------
# Neovim 설치/업데이트

## 현재 설치 형태 확인법
설치된 nvim이 이전에 어떤 도구로 설치했는지 기억나지 않을 때, 확인 법

### 방법 A: Scoop 설치 여부 확인
PowerShell
scoop list neovim
결과: 만약 Neovim 정보가 나타난다면 Scoop으로 설치된 것입니다.

경로: 보통 C:\Users\사용자명\scoop\apps\neovim에 위치합니다.

### 방법 B: 실행 파일 위치(Path) 확인
PowerShell
where.exe nvim
결과: 출력되는 경로를 보고 판단할 수 있습니다.

.../scoop/shims/nvim.exe: Scoop 설치

C:\Program Files\Neovim\...: 설치 프로그램(MSI) 사용


### 방법 C: Winget 설치 여부 확인
PowerShell
winget list neovim
결과: 목록에 뜬다면 윈도우 기본 패키지 관리자인 Winget으로 설치된 것입니다.

## 다른 방식으로 업그레이드해도 되나요?
네, 가능합니다. 다만, 기존 설치본과 충돌하지 않도록 기존 버전을 먼저 제거하는 것이 가장 깔끔합니다.

Scoop이었을 경우: scoop uninstall neovim 후 새 방식 선택.

## 업그레이드

cf) 관리가 편한 Scoop 방식을 추천

(1) Scoop을 계속 사용할 경우 (가장 권장)
기존에 Scoop으로 설치된 것이 확인되었다면, 아래 명령 한 줄로 끝납니다.

PowerShell
scoop update neovim

(2) Winget으로 갈아탈 경우
기존 버전을 삭제한 뒤 아래를 입력하세요.

PowerShell
winget install Neovim.Neovim


-- ------------------------------------------------
# kickstart.nvim 설치

- 설치할 폴더로 이동 후, git clone 명령으로 kickstart 설치.
    - 보통, Windows에서 Neovim의 설정 경로는 일반적으로 다음과 같습니다:
        C:\Users\사용자이름\AppData\Local\nvim
    - 터미널(PowerShell)에서 아래 명령어로 폴더가 있는지 확인하고, 없으면 생성하세요:
        PowerShell
        mkdir $env:LOCALAPPDATA\nvim
    -  kickstart.nvim 설치
        가장 권장되는 방법은 kickstart.nvim 레포지토리를 설정 폴더로 복제하는 것입니다.
        PowerShell
        # 기존 설정이 있다면 백업하세요.
        # nvim 폴더로 이동하여 클론
        cd $env:LOCALAPPDATA\nvim
        git clone https://github.com/nvim-lua/kickstart.nvim.git .
    - 실행 및 플러그인 자동 설치
        설치가 완료되었다면 터미널에 nvim을 입력하여 실행하세요.
 
 - cf) 'init.lua'와 'lua 폴더' 만 남기고 모두 삭제
    깃허브(GitHub)를 통해 협업하거나 코드를 올릴 계획이 없고, 사용자님만의
    깔끔한 설정 환경을 만들고 싶다면 init.lua 파일과 lua 폴더(있는 경우)만
    남기고 나머지는 모두 삭제하셔도 무방합니다. 
    윈도우 탐색기에서 지우셔도 되고, powershell에서 다음 명령어로 한꺼번에 지우셔도 됩니다.
    이렇게 정리하고 나면 오직 사용자님의 수정 사항이 담긴 설정 파일들만 남게 되어 관리가 더 편하실 거예요.

- 이제 init.lua 파일을 열어서 본인의 입맛에 맞게 설정을 수정하며 사용하시면 됩니다!

kickstart.nvim github에서 링크된 youtube 추천 영상
The Only Video You Need to Get Started with Neovim
파일제목: The Only Video You Need to Get Started with Neovim.mp4
https://www.youtube.com/watch?v=m8C0Cq9Uv9o

# lazy.nvim 설치

- Note:
:echo stdpath('config')
In what follows ~/.config/nvim is your Neovim configuration directory. On Windows, this is usually ~\AppData\Local\nvim. To know the correct path for your system, run :echo stdpath('config').

# netrw (Neovim의 내장 탐색기)

    :Lexplore (또는 :Lex): 왼쪽 사이드바 형태로 탐색기를 열거나 닫습니다 (Toggle 기능).
    :Explore (또는 :Ex): 현재 작업 중인 창 전체를 탐색기로 바꿉니다.

    Enter: 파일 열기 또는 폴더 들어가기
    -: 상위 폴더로 이동
    D: 파일 삭제
    R: 파일 이름 변경
    %: 새 파일 생성
    d: 새 디렉토리(폴더) 생성
    i: 탐색기 보기 모드 변경 (리스트형, 상세형, 격자형 등)

# treesitter nodes 알아내기

    treesitter nodes: 코드를 분석할 때 인식하는 문법 단위(함수, 테이블, 루프 등)입니다.

    만약 특정 언어에서 여전히 강조가 안 되는 블록이 있다면, 해당 블록 위에 커서를 두고 다음 명령어를 입력해 보세요:

    :InspectTree (Neovim 내장 기능)


