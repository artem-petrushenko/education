package com.example.app_receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {
    private val STREAM_CHANNEL = "com.example.ipc/receiver_stream"
    private var broadcastReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, STREAM_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {

                    broadcastReceiver = object : BroadcastReceiver() {
                        override fun onReceive(context: Context?, intent: Intent?) {
                            if (intent?.action == "com.example.ipc.ACTION_COUNT_CHANGED") {
                                val count = intent.getIntExtra("current_count", 0)
                                events?.success(count)
                            }
                        }
                    }

                    val filter = IntentFilter("com.example.ipc.ACTION_COUNT_CHANGED")
                    
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        registerReceiver(broadcastReceiver, filter, Context.RECEIVER_EXPORTED)
                    } else {
                        registerReceiver(broadcastReceiver, filter)
                    }
                }

                override fun onCancel(arguments: Any?) {
                    if (broadcastReceiver != null) {
                        unregisterReceiver(broadcastReceiver)
                        broadcastReceiver = null
                    }
                }
            }
        )
    }
}