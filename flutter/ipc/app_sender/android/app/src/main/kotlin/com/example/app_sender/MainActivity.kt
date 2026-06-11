package com.example.app_sender

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.ipc/sender"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendCount") {
                val count = call.argument<Int>("value") ?: 0
                val intent = Intent("com.example.ipc.ACTION_COUNT_CHANGED").apply {
                    putExtra("current_count", count)
                    setPackage("com.example.app_receiver")
                }
                sendBroadcast(intent)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}