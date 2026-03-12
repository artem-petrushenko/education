package com.example.flutter_with_native

import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.*
import java.util.*
import kotlin.concurrent.fixedRateTimer

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL = "com.example.methodChannel"
    private val EVENT_CHANNEL = "com.example.eventChannel"
    private val BASIC_CHANNEL = "com.example.basicMessageChannel"

    private var timer: Timer? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openGeneralSettings" -> {
                    val intent = Intent(Settings.ACTION_SETTINGS)
                    startActivity(intent)
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }

        // EventChannel
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                private var count = 0

                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    timer = fixedRateTimer("counterTimer", initialDelay = 0, period = 1000) {
                        runOnUiThread {
                            events?.success(count++)
                        }
                    }
                }

                override fun onCancel(arguments: Any?) {
                    timer?.cancel()
                    timer = null
                }
            }
        )

        // BasicMessageChannel
        val basicMessageChannel = BasicMessageChannel<String>(
            flutterEngine.dartExecutor.binaryMessenger,
            BASIC_CHANNEL,
            StringCodec.INSTANCE
        )

        basicMessageChannel.setMessageHandler { message, reply ->
            if (message is String) {
                reply.reply("Received: $message")
            } else {
                reply.reply("Invalid message")
            }
        }
    }
}
