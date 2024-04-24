package com.crossevol.counter

import androidx.annotation.NonNull
import com.crossevol.HttpServer.HttpServer
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec

class MainActivity : FlutterActivity() {
    private val CHANNEL = "crossevol.com/HttpServer"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val taskQueue =
            flutterEngine.dartExecutor.binaryMessenger.makeBackgroundTaskQueue()
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL,
            StandardMethodCodec.INSTANCE,
            taskQueue
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    val config = call.argument<String>("config")
                    try {
                        val returnMsg = HttpServer.start(config)
                        result.success(returnMsg)
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }
                "stop" -> {
                    HttpServer.stop()
                    result.success("")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

}

// public static native long start(String config) throws Exception;
// public static native void stop();
