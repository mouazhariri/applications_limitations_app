package com.example.applications_limitations

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent

/**
 * Android calls this before a user disables Device Admin. It cannot replace the
 * system flow or require an application PIN, but it gives a clear warning on
 * unmanaged devices. Device Owner/Profile Owner policy performs the actual
 * uninstall block when available.
 */
class PhoneLimiterDeviceAdminReceiver : DeviceAdminReceiver() {
    override fun onDisableRequested(context: Context, intent: Intent): CharSequence =
        context.getString(R.string.device_admin_disable_warning)
}
