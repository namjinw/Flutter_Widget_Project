Cmake_minimum_required(VERSION 3.22.1)
# cmake 버번

project(widget2)
# C++ 프로젝트 이름

# C++ 라이브러리 생성 명령어
add_library(
    "native-lib" # 라이브러리 이름
    SHARED # 공유 라이브러리로 생성
    native-lib.cpp # 소스코드
)

find_library(log-lib log)
# 라이브러리 가져오는 명령어
# 변수명 라이브러리 이름

target_link_libraries(
    "native-lib" # 라이브러리 이름
    ${log-lib} # 변수 주소 가져오기
)
# 라이브러리 살제로 불러오는 명령어