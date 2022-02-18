package com.example.new_alarm_clock

import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.provider.Settings;
import androidx.annotation.RequiresApi

class MainActivity: FlutterActivity() {
    private val CHANNEL = "intent/permission"
    var ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE = 2323

    @RequiresApi(Build.VERSION_CODES.M)
    private fun setDisplayOverPermission() {
        val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName"))
        startActivityForResult(intent, ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE)
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun checkDisplayOverPermission(): Boolean{
        return Settings.canDrawOverlays(this);
    }

    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if(call.method == "checkDisplayOverPermission"){
                result.success(checkDisplayOverPermission())
            }
            else if(call.method == "setDisplayOverPermission"){
                result.success(setDisplayOverPermission())
            }
        }
    }
}
