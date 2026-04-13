package com.example.widget

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var pendingCount: Int? = null
    private var pendingContent: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "todo").setMethodCallHandler { call, result ->
            if (call.method == "notification") {
                val count = call.argument<Int>("count")
                val content = call.argument<String>("content")

                if (count == null || content == null) {
                    result.error("INVALID_ARGS", "count/content 값이 필요합니다.", null)
                    return@setMethodCallHandler
                }

                check(count, content)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun check(count: Int, content: String) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(
                    this,
                    Manifest.permission.POST_NOTIFICATIONS
                ) !=
                PackageManager.PERMISSION_GRANTED
            ) {
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                    1001
                )
                pendingCount = count
                pendingContent = content
                return
            }

        }

        showNotification(count, content)
    }

    private fun showNotification(count: Int, content: String) {
        val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "todo",
                "Todo 알림",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            manager.createNotificationChannel(channel)
        }

        // 알림 builder 객체 생성 context와 패널 id주기
        val builder = NotificationCompat.Builder(this, "todo")
            .setSmallIcon(R.mipmap.ic_launcher) // 아이콘
            .setContentTitle("${count}개의 To do List가 남았어요!") // 타이틀
            .setContentText(content) // 내용
            .setPriority(NotificationCompat.PRIORITY_DEFAULT) // 알림 중요도
            .setAutoCancel(true)


        manager.notify(1, builder.build())
    }


    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String?>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == 1001 &&
            grantResults.isNotEmpty() &&
            grantResults[0] == PackageManager.PERMISSION_GRANTED
        ) {
            val count = pendingCount
            val content = pendingContent

            if (count != null && content != null) {
                showNotification(count, content)
            }

            pendingCount = null
            pendingContent = null
        }

    }
}
