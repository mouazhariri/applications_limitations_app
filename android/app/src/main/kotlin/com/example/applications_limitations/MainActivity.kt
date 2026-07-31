package com.example.applications_limitations

import android.app.AppOpsManager
import android.app.NotificationManager
import android.app.usage.UsageStats
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import android.util.Base64
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.util.Calendar

class MainActivity : FlutterActivity() {
    private val channelName = "phone_limiter/native"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "getPermissionStatuses" -> result.success(permissionStatuses())
                "openPermissionSettings" -> {
                    openPermissionSettings(call.argument<String>("permission") ?: "")
                    result.success(null)
                }
                "getInstalledApps" -> result.success(installedApps())
                "getUsageStats" -> result.success(usageStats(call.argument<Int>("dayOffset") ?: 0))
                "startProtectionService" -> {
                    ProtectionForegroundService.start(this)
                    result.success(null)
                }
                "stopProtectionService" -> {
                    stopService(Intent(this, ProtectionForegroundService::class.java))
                    stopService(Intent(this, BlockOverlayService::class.java))
                    result.success(null)
                }
                "showBlockOverlay" -> {
                    BlockOverlayService.show(this, call.argument<String>("packageName") ?: packageName, call.argument<String>("appName") ?: getString(R.string.app_name))
                    result.success(null)
                }
                "openEmergencyDialer" -> {
                    startActivity(Intent(Intent.ACTION_DIAL, Uri.parse("tel:911")))
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun permissionStatuses(): Map<String, Boolean> = mapOf(
        "usageAccess" to hasUsageAccess(),
        "accessibility" to PhoneLimiterAccessibilityService.isEnabled(this),
        "overlay" to (Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.canDrawOverlays(this)),
        "notification" to notificationsEnabled(),
        "battery" to ignoringBatteryOptimizations()
    )

    private fun openPermissionSettings(key: String) {
        val intent = when (key) {
            "usageAccess" -> Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
            "accessibility" -> Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
            "overlay" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:$packageName")) else Intent(Settings.ACTION_SETTINGS)
            "notification" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).putExtra(Settings.EXTRA_APP_PACKAGE, packageName) else Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:$packageName"))
            "battery" -> Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS, Uri.parse("package:$packageName"))
            else -> Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:$packageName"))
        }
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }

    private fun installedApps(): List<Map<String, Any?>> {
        val pm = packageManager
        return pm.getInstalledApplications(0)
            .filter { pm.getLaunchIntentForPackage(it.packageName) != null }
            .sortedBy { pm.getApplicationLabel(it).toString().lowercase() }
            .map { app ->
                mapOf(
                    "packageName" to app.packageName,
                    "name" to pm.getApplicationLabel(app).toString(),
                    "icon" to drawableToBase64(pm.getApplicationIcon(app))
                )
            }
    }

    private fun usageStats(dayOffset: Int): List<Map<String, Any?>> {
        val usageManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        calendar.set(Calendar.MILLISECOND, 0)
        calendar.add(Calendar.DAY_OF_YEAR, -dayOffset)
        val start = calendar.timeInMillis
        calendar.add(Calendar.DAY_OF_YEAR, 1)
        val end = calendar.timeInMillis
        val stats = usageManager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, start, end) ?: emptyList()
        val pm = packageManager
        return stats
            .filter { usageMillis(it) > 0 && pm.getLaunchIntentForPackage(it.packageName) != null }
            .mapNotNull { usage ->
                try {
                    val info: ApplicationInfo = pm.getApplicationInfo(usage.packageName, 0)
                    mapOf(
                        "packageName" to usage.packageName,
                        "name" to pm.getApplicationLabel(info).toString(),
                        "usageMs" to usageMillis(usage),
                        "icon" to drawableToBase64(pm.getApplicationIcon(info))
                    )
                } catch (_: Exception) {
                    null
                }
            }
            .sortedByDescending { (it["usageMs"] as Long) }
    }

    private fun usageMillis(stats: UsageStats): Long = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) stats.totalTimeVisible else stats.totalTimeInForeground

    private fun hasUsageAccess(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), packageName)
        } else {
            @Suppress("DEPRECATION") appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), packageName)
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun notificationsEnabled(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) return true
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        return manager.areNotificationsEnabled()
    }

    private fun ignoringBatteryOptimizations(): Boolean {
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M || powerManager.isIgnoringBatteryOptimizations(packageName)
    }

    private fun drawableToBase64(drawable: Drawable): String {
        val bitmap = if (drawable is BitmapDrawable && drawable.bitmap != null) {
            drawable.bitmap
        } else {
            val width = drawable.intrinsicWidth.takeIf { it > 0 } ?: 96
            val height = drawable.intrinsicHeight.takeIf { it > 0 } ?: 96
            Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888).also { bitmap ->
                val canvas = Canvas(bitmap)
                drawable.setBounds(0, 0, canvas.width, canvas.height)
                drawable.draw(canvas)
            }
        }
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 90, stream)
        return Base64.encodeToString(stream.toByteArray(), Base64.NO_WRAP)
    }
}
