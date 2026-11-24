package com.example.flutter_application_1

import android.os.Bundle
import android.view.View
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL_NAME = "com.example.flutter_application_1/kiosk"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "enableKioskMode" -> {
                        try {
                            startLockTask()
                            window.decorView.systemUiVisibility = (
                                View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                                    or View.SYSTEM_UI_FLAG_FULLSCREEN
                                    or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                                    or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                                    or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                                    or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                                )
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("LOCK_TASK_ERROR", e.message, null)
                        }
                    }
                    "disableKioskMode" -> {
                        try {
                            stopLockTask()
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("LOCK_TASK_ERROR", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)

        if (hasFocus) {
            try {
                startLockTask()
            } catch (_: Exception) {
                // lock task unsupported; app still runs normally
            }

            window.decorView.systemUiVisibility = (
                View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                    or View.SYSTEM_UI_FLAG_FULLSCREEN
                    or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                    or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                    or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                )
        }
    }
} 
