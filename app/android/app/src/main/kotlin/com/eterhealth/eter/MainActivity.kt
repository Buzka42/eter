package com.eterhealth.eter

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.eterhealth.eter/haptics"
        ).setMethodCallHandler { call, result ->
            val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
            if (!vibrator.hasVibrator()) {
                result.success(null)
                return@setMethodCallHandler
            }
            when (call.method) {
                "milestone" -> {
                    val inSession = call.argument<Boolean>("inSession") ?: false
                    val scale = if (inSession) 0.7 else 1.0
                    vibrateWaveform(
                        vibrator,
                        longArrayOf(0, 40, 80, 60, 120, 90),
                        intArrayOf(0, (90 * scale).toInt(), 0, (150 * scale).toInt(), 0, (230 * scale).toInt())
                    )
                    result.success(null)
                }
                "light" -> {
                    vibrateWaveform(vibrator, longArrayOf(0, 20), intArrayOf(0, 60))
                    result.success(null)
                }
                "restDone" -> {
                    vibrateWaveform(vibrator, longArrayOf(0, 40, 80, 40), intArrayOf(0, 120, 0, 120))
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun vibrateWaveform(vibrator: Vibrator, timings: LongArray, amplitudes: IntArray) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator.vibrate(VibrationEffect.createWaveform(timings, amplitudes, -1))
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(timings, -1)
        }
    }
}
