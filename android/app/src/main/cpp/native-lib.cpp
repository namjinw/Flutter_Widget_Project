#include <jni.h> // JNI라이브러리 가져오기
#include <string> // C++ 문자열 도구
#include <android/log.h> // 안드로이드 로그 찍는 라이브러리

// extern "C": C 스타일로 컴파일
// JNIEXPORT: 이 함수를 라이브러리(.so 파일) 외부에서 볼 수 있도록 공개
// jstring: 리턴타입(Kotlin의 String)
// JNICALL: JNI 호출 규약(함수가 실행될 때 메모리 스택을 어떻게 쌓고 치울지 정하는 약속)
extern "C" JNIEXPORT jstring JNICALL

// JNIEnv *env: C++ 세계에서 Kotlin 세계의 물건을 만질 때 쓰는 전능한 도구
// jobject thiz (나 자신): Kotlin에서 이 함수를 호출한 MainActivity 객체 그 자체
Java_com_example_widget2_MainActivity_testFunc(JNIEnv *env, jobject thiz) {
    // 사용법: __android_log_print(우선순위, "태그", "내용", ...)
    __android_log_print(ANDROID_LOG_DEBUG, "Jinko", "로그가 잘 찍힙니다! 숫자: %d", 100);

    // env라는 리모컨을 사용해서 C++ 문자열을 Kotlin용(jstring)으로 변환해 리턴
    return env->NewStringUTF("Hello from C++");
}