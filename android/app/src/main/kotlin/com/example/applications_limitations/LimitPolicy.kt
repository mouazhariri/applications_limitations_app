package com.example.applications_limitations

import android.app.AppOpsManager
import android.app.usage.UsageEvents
import android.app.usage.UsageStats
import android.app.usage.UsageStatsManager
import android.content.ComponentName
import android.content.Context
import android.content.SharedPreferences
import android.os.Build
import android.provider.Settings
import org.json.JSONObject
import java.security.MessageDigest
import java.util.Calendar

object LimitPolicy {
    private const val PREFS = "FlutterSharedPreferences"
    private const val PHONE_LIMIT = "flutter.phone_limit_ms"
    private const val APP_LIMITS = "flutter.app_limits_json"
    private const val PIN_HASH = "flutter.security_pin_hash"
    private const val PIN_SALT = "flutter.security_pin_salt"
    private const val PROTECTION = "flutter.protection_enabled"

    fun prefs(context: Context): SharedPreferences = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    fun isProtectionEnabled(context: Context): Boolean = prefs(context).getBoolean(PROTECTION, true)

    fun phoneLimitMs(context: Context): Long {
        val fallback = 2L * 60L * 60L * 1000L
        val raw = prefs(context).all[PHONE_LIMIT]
        val value = when (raw) {
            is Long -> raw
            is Int -> raw.toLong()
            is String -> raw.toLongOrNull() ?: fallback
            else -> fallback
        }
        return if (value <= 0L) fallback else value
    }

    fun appLimits(context: Context): Map<String, Long> {
        val raw = prefs(context).getString(APP_LIMITS, null) ?: return emptyMap()
        return try {
            val json = JSONObject(raw)
            json.keys().asSequence().associateWith { json.optLong(it, 0L) }.filterValues { it > 0L }
        } catch (_: Exception) {
            emptyMap()
        }
    }

    fun verifySecret(context: Context, secret: String): Boolean {
        val prefs = prefs(context)
        val salt = prefs.getString(PIN_SALT, null) ?: return false
        val expected = prefs.getString(PIN_HASH, null) ?: return false
        val normalizedSecret = secret.replace("-", "").trim()
        val digest = MessageDigest.getInstance("SHA-256").digest("$salt:$normalizedSecret".toByteArray(Charsets.UTF_8))
        val hash = digest.joinToString("") { "%02x".format(it) }
        return hash == expected
    }

    fun todayUsageByApp(context: Context): Map<String, Long> {
        if (!hasUsageAccess(context)) return emptyMap()
        val usageManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val start = startOfToday()
        val end = System.currentTimeMillis()
        val stats = usageManager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, start, end) ?: return emptyMap()
        return stats.groupBy { it.packageName }.mapValues { entry -> entry.value.sumOf { usageMillis(it) } }.filterValues { it > 0L }
    }

    fun totalTodayUsageMs(context: Context): Long = todayUsageByApp(context).values.sum()

    fun shouldBlockPhone(context: Context): Boolean = isProtectionEnabled(context) && totalTodayUsageMs(context) >= phoneLimitMs(context)

    fun shouldBlockApp(context: Context, packageName: String?): Boolean {
        if (packageName.isNullOrBlank() || packageName == context.packageName || !isProtectionEnabled(context)) return false
        val limit = appLimits(context)[packageName] ?: return false
        val usage = todayUsageByApp(context)[packageName] ?: 0L
        return usage >= limit
    }

    fun topPackage(context: Context): String? {
        if (!hasUsageAccess(context)) return null
        val usageManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val end = System.currentTimeMillis()
        val start = end - 60_000L
        val events = usageManager.queryEvents(start, end)
        val event = UsageEvents.Event()
        var packageName: String? = null
        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                packageName = event.packageName
            }
        }
        return packageName
    }

    fun hasUsageAccess(context: Context): Boolean {
        val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) appOps.unsafeCheckOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), context.packageName) else {
            @Suppress("DEPRECATION") appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), context.packageName)
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    fun hasOverlay(context: Context): Boolean = Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.canDrawOverlays(context)

    fun accessibilityEnabled(context: Context): Boolean {
        val expected = ComponentName(context, PhoneLimiterAccessibilityService::class.java).flattenToString().lowercase()
        val enabled = Settings.Secure.getString(context.contentResolver, Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES) ?: return false
        return enabled.lowercase().split(':').any { it == expected }
    }

    private fun startOfToday(): Long {
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        calendar.set(Calendar.MILLISECOND, 0)
        return calendar.timeInMillis
    }

    private fun usageMillis(stats: UsageStats): Long = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) stats.totalTimeVisible else stats.totalTimeInForeground
}
