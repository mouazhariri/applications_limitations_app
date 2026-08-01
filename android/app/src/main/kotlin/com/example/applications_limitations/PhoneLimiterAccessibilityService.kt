package com.example.applications_limitations

import android.accessibilityservice.AccessibilityService
import android.content.Context
import android.provider.Settings
import android.view.accessibility.AccessibilityEvent

class PhoneLimiterAccessibilityService : AccessibilityService() {
    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        val packageName = event?.packageName?.toString() ?: return
        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED || event.eventType == AccessibilityEvent.TYPE_WINDOWS_CHANGED) {
            if (LimitPolicy.shouldBlockPhone(this)) {
                BlockOverlayService.show(this, packageName, getString(R.string.phone_locked_title), true)
                return
            }
            if (LimitPolicy.shouldBlockApp(this, packageName)) {
                val appName = runCatching { packageManager.getApplicationLabel(packageManager.getApplicationInfo(packageName, 0)).toString() }.getOrDefault(packageName)
                BlockOverlayService.show(this, packageName, appName, false)
            }
        }
    }

    override fun onInterrupt() = Unit

    override fun onServiceConnected() {
        super.onServiceConnected()
        ProtectionForegroundService.start(this)
    }

    companion object {
        fun isEnabled(context: Context): Boolean {
            val enabled = Settings.Secure.getString(context.contentResolver, Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES) ?: return false
            val serviceName = "${context.packageName}/${PhoneLimiterAccessibilityService::class.java.name}".lowercase()
            return enabled.lowercase().split(':').any { it == serviceName }
        }
    }
}
