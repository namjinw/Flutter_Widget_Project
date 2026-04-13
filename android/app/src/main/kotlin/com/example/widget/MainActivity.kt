package com.example.widget

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context.NOTIFICATION_SERVICE
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import androidx.core.content.ContextCompat.getSystemService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// Flutter와 Native Android 간 통신을 담당하는 MainActivity
// Method Channel을 통해 Flutter에서 전송된 데이터를 받아 Android 알림을 표시합니다
class MainActivity : FlutterActivity() {

    // Flutter에서 받을 데이터를 저장할 변수들
    var count: Int = 0;  // Todo List 남은 개수
    var content: String = "";  // 알림에 표시될 내용

    // FlutterEngine이 초기화될 때 호출되는 메서드
    // 여기서 Flutter와 Native 간의 통신 채널을 설정합니다
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // MethodChannel을 "todo"라는 이름으로 생성
        // Flutter에서 "todo" 채널로 보낸 메서드 호출을 여기서 처리합니다
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,  // 메시지 전달자
            "todo"  // 채널 이름 (Flutter에서도 같은 이름으로 호출해야 함)
        ).setMethodCallHandler { call, result ->
            // Flutter에서 "notification" 메서드를 호출했을 때 실행되는 부분
            if (call.method == "notification") {
                // Flutter에서 전송된 데이터를 받아서 변수에 저장합니다
                // call.argument를 통해 key-value 형태로 데이터를 추출합니다
                count = call.argument<Int>("count")!!  // "count" 키의 정수 값 추출
                content = call.argument<String>("content")!!  // "content" 키의 문자열 값 추출

                // 데이터를 받았으므로 알림 표시를 위해 check() 메서드 호출
                check()

                // Flutter에 성공 응답을 보냅니다
                result.success(null)
            }
        }
    }

    // 알림 표시 전 권한 확인 및 요청하는 메서드
    private fun check() {
        // Android 13 (API 33) 이상인 경우 알림 권한 확인이 필요합니다
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            // 앱이 알림 표시 권한을 가지고 있는지 확인
             // 권한이 없는 경우
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
                // 사용자에게 권한을 요청합니다
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                    1001  // 요청 코드 (나중에 결과 처리할 때 사용)
                )
                return  // 권한 결과를 기다리므로 여기서 return
            }

        }

        // 권한이 있거나 Android 13 미만인 경우 바로 알림을 표시합니다
        showNotification()
    }

    // 사용자가 권한 요청에 응답했을 때 호출되는 메서드
    override fun onRequestPermissionsResult(
        requestCode: Int,  // 어떤 요청인지 구분하는 코드
        permissions: Array<out String?>,  // 요청한 권한 배열
        grantResults: IntArray  // 각 권한의 승인/거부 결과
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        // 우리가 요청한 코드(1001)인지 확인하고, 사용자가 권한을 승인했는지 확인
        if (requestCode == 1001 &&  // 우리의 요청 코드와 일치?
            grantResults.isNotEmpty() &&  // 결과가 있는가?
            grantResults[0] == PackageManager.PERMISSION_GRANTED  // 첫 번째 권한(알림)이 승인됨?
        ) {
            // 권한이 승인되었으므로 알림을 표시합니다
            showNotification()
        }

    }

    // 실제로 Android 알림을 표시하는 메서드
    private fun showNotification() {
        // NotificationManager를 가져옵니다 (알림을 관리하는 시스템 서비스)
        val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager

        // Android 8 (API 26) 이상인 경우 알림 채널을 생성해야 합니다
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // 알림 채널을 생성합니다 (각 채널별로 음성, 진동 등을 제어할 수 있음)
            val channel = NotificationChannel(
                "todo",  // 채널 ID
                "Todo 알림",  // 채널 이름 (사용자에게 표시됨)
                NotificationManager.IMPORTANCE_DEFAULT  // 중요도 레벨
            )
            manager.createNotificationChannel(channel)
        }

        // 알림의 내용을 구성하는 Builder 객체 생성
        val builder = NotificationCompat.Builder(this, "todo")  // 위에서 만든 채널과 같은 ID 사용
            .setSmallIcon(R.mipmap.ic_launcher)  // 알림 아이콘 설정
            .setContentTitle("${count}개의 To do List가 남았어요!")  // 알림 제목 (count 변수를 포함)
            .setContentText(content)  // 알림 본문 내용 (content 변수 사용)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)  // 알림 우선순위 설정
            .setAutoCancel(true)  // 사용자가 클릭하면 자동으로 알림 닫기

        // 최종적으로 알림을 시스템에 표시합니다
        manager.notify(1, builder.build())  // ID 1번으로 알림 표시 (같은 ID로 호출하면 기존 알림이 업데이트됨)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val resultFromCpp = stringFromJNI()
        Log.d("cpp", resultFromCpp)
    }

    external fun stringFromJNI(): String

    companion object {
        init {
            System.loadLibrary("native-lib")
        }
    }
}
