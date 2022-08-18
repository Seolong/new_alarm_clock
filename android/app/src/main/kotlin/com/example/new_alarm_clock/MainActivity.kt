package com.example.new_alarm_clock

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "intent/permission"

    @RequiresApi(Build.VERSION_CODES.M)
    private fun setDisplayOverPermission() {
        val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName"))
        startActivity(intent)
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun checkDisplayOverPermission(): Boolean{
        return Settings.canDrawOverlays(this);
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun checkBatteryOptimizations(): Boolean{
        val powerManager: PowerManager =
            getSystemService(Context.POWER_SERVICE) as PowerManager
        return powerManager.isIgnoringBatteryOptimizations(packageName)
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun setBatteryOptimizations(): Boolean{
        return try{
            // 이렇게 하면 안 되더라? 왜 그래 진짜
//            startActivity(
//                Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
//            )
            val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
            startActivity(intent)
            true
        }catch (e: ActivityNotFoundException){
            false
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when(call.method){
                "checkDisplayOverPermission" -> result.success(checkDisplayOverPermission())
                "setDisplayOverPermission" -> result.success(setDisplayOverPermission())
                "checkBatteryOptimizations" -> result.success(checkBatteryOptimizations())
                "setBatteryOptimizations" -> result.success(setBatteryOptimizations())
                else -> {}
            }
        }
    }
}
