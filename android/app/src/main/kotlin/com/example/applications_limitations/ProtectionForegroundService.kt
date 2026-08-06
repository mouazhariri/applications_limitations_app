package com.example.applications_limitations

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper

class ProtectionForegroundService : Service() {
    private val handler = Handler(Looper.getMainLooper())
    private val monitor = object : Runnable {
        override fun run() {
            runProtectionCheck()
            handler.postDelayed(this, 4_000L)
        }
    }

    override fun onCreate() {
        super.onCreate()
        createChannel()
        startForeground(NOTIFICATION_ID, notification(getString(R.string.notification_running)))
        handler.post(monitor)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        handler.removeCallbacks(monitor)
        handler.post(monitor)
        return START_STICKY
    }

    override fun onDestroy() {
        handler.removeCallbacks(monitor)
        super.onDestroy()
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        // Keep protection alive even when the user swipes the app away from the
        // recent apps list. The foreground service is what enforces the limits
        // while the app itself is closed.
        if (LimitPolicy.isProtectionEnabled(this)) {
            startSelf()
        }
        super.onTaskRemoved(rootIntent)
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun runProtectionCheck() {
        if (!LimitPolicy.isProtectionEnabled(this)) return
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (!LimitPolicy.hasUsageAccess(this) || !LimitPolicy.hasOverlay(this) || !LimitPolicy.accessibilityEnabled(this)) {
            notificationManager.notify(PERMISSION_NOTIFICATION_ID, notification(getString(R.string.notification_permission_missing)))
            return
        }
        val topPackage = LimitPolicy.topPackage(this)
        if (LimitPolicy.shouldBlockPhone(this)) {
            BlockOverlayService.show(this, topPackage ?: packageName, getString(R.string.phone_locked_title), true)
        } else if (LimitPolicy.shouldBlockApp(this, topPackage)) {
            val appName = runCatching { packageManager.getApplicationLabel(packageManager.getApplicationInfo(topPackage!!, 0)).toString() }.getOrDefault(topPackage ?: getString(R.string.blocked_app))
            BlockOverlayService.show(this, topPackage ?: packageName, appName, false)
        }
    }

    private fun createChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(CHANNEL_ID, getString(R.string.notification_channel_name), NotificationManager.IMPORTANCE_LOW)
            channel.description = getString(R.string.notification_channel_desc)
            (getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager).createNotificationChannel(channel)
        }
    }

    private fun notification(text: String): Notification {
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName) ?: Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(this, 0, launchIntent, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) Notification.Builder(this, CHANNEL_ID) else Notification.Builder(this)
        return builder
            .setSmallIcon(android.R.drawable.ic_lock_idle_lock)
            .setContentTitle(getString(R.string.app_name))
            .setContentText(text)
            .setOngoing(true)
            .setContentIntent(pendingIntent)
            .build()
    }

    companion object {
        private const val CHANNEL_ID = "phone_limiter_protection"
        private const val NOTIFICATION_ID = 81
        private const val PERMISSION_NOTIFICATION_ID = 82

        fun start(context: Context) {
            val intent = Intent(context, ProtectionForegroundService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) context.startForegroundService(intent) else context.startService(intent)
        }
    }

    private fun startSelf() {
        val intent = Intent(this, ProtectionForegroundService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) startForegroundService(intent) else startService(intent)
    }
}
