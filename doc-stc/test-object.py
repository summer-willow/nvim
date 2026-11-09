# =====================================================================
# 🛠️ mini.ai + Treesitter 텍스트 오브젝트 연습 스크립트 (Python)
# 
# 💡 기호 요약:
#    - f = 함수 | c = 클래스 | o = 조건문 및 for/while 루프
# =====================================================================

# 🎯 [테스트 1] 클래스 전체 타깃 저격 (dalc / cilc)
# 커서가 아래 'self.name' 위에 있을 때 [ vilc ]를 누르면 Calculator 클래스 내부 전체가,
# [ valc ]를 누르면 'class Calculator:' 키워드부터 클래스 끝까지 통째로 잡힙니다.
class Calculator:
    def __init__(self, name):
        self.name = name  # <- [여기]에 커서를 두고 vilc 또는 valc 입력!

    # 🎯 [테스트 2] 함수 내부/외부 저격 (vilf / dalf)
    # 커서를 'result =' 위에 두고 [ dalf ]를 입력해 보세요.
    # def square(x): 구문부터 return까지 함수 전체(Around Last Function)가 깔끔하게 삭제됩니다.
    def square(self, x):
        result = x * x  # <- [여기]에 커서를 두고 dalf 실행!
        return result

    # 🎯 [테스트 3] 루프 및 조건문 저격 (vilo / dalo)
    # 커서를 'total +=' 위에 두고 [ vilo ]를 입력해 보세요.
    # 바로 직전의 'for num in numbers:' 루프의 내부 블록 전체가 선택됩니다.
    def sum_even_numbers(self, numbers):
        total = 0
        for num in numbers:
            if num % 2 == 0:
                total += num  # <- [여기]에 커서를 두고 vilo 실행!
        return total


# 🎯 [테스트 4] 원격 다음(Next) 타깃 조작 연습 (ciif / viic)
# 커서를 아래 팁 주석 라인에 가만히 두고 [ ciif ]를 입력해 보세요.
# 커서가 훌쩍 날아가서 저 아래에 있는 'process_data' 함수의 알맹이만 골라서 싹 지워줍니다.
# ---------------------------------------------------------------------
# | <- 현재 커서 위치 (여기에 가만히 두고 ciif 입력)
# ---------------------------------------------------------------------

def process_data():
    raw_data = [1, 2, 3]
    print("데이터를 처리 중입니다...")
    return raw_data
