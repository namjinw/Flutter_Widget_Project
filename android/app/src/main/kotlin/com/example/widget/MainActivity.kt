package com.example.widget

import android.Manifest
import android.app.Activity
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.pm.PackageManager
import android.icu.text.Normalizer.NO
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        check()
    }

    private fun check() {
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
                return
            }

        }

        showNotification()
    }

    private fun showNotification() {
        var manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "todo",
                "Todo 알림",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            manager.createNotificationChannel(channel)
        }

        // 알림 builder 객체 생성 context와 패널 id주기
        var builder = NotificationCompat.Builder(this, "todo")
            .setSmallIcon(R.mipmap.ic_launcher) // 아이콘
            .setContentTitle("2개의 To do List가 남았어요!") // 타이틀
            .setContentText(
                """
1, Flutter 공부하기
2, 축구 기본기 훈련하기
            """.trimIndent()
            ) // 내용
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
            showNotification()
        }

    }
}
