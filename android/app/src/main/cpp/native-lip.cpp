#include <jni.h>
#include <string>

extern "C" JNIEXPORT jstring JNICALL
// Java_패키지명_클래스명_함수명 형식이며 '.' 은 '_' 로 바뀝니다.
Java_com_example_widget_MainActivity_stringFromJNI(
        JNIEnv* env,
        jobject /* this */) {
    std::string hello = "Hello from C++ (Native Code)!";
    return env->NewStringUTF(hello.c_str());
}