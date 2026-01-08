package com.example.bbcat

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.bbcat/icon_switch"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "changeIcon") {
                val aliasName = call.argument<String>("aliasName")
                try {
                    changeIcon(aliasName)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("ERROR", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun changeIcon(aliasName: String?) {
        val packageManager = packageManager
        val packageName = packageName

        // 所有的入口列表（需与 Manifest 中的 name 完全对应）
        val components = listOf(
            ".MainActivity",        // 默认入口
            ".MainActivitySet",     // 设置伪装
            ".MainActivityCalendar" // 日历伪装
        )

        components.forEach { name ->
            val componentName = ComponentName(packageName, "$packageName$name")
            val state = if (name == aliasName || (aliasName == null && name == ".MainActivity")) {
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            } else {
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED
            }

            // 执行切换
            packageManager.setComponentEnabledSetting(
                componentName,
                state,
                PackageManager.DONT_KILL_APP // 尽量平滑，但系统通常仍会杀进程
            )
        }
    }
}