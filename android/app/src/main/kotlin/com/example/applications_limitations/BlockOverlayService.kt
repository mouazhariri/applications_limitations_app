package com.example.applications_limitations

import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.text.InputType
import android.view.Gravity
import android.view.KeyEvent
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast

/**
 * Displays the native protection surface above a blocked application.
 *
 * The foreground monitor asks for this surface frequently.  The request is
 * idempotent while the same lock is displayed: recreating the view every few
 * seconds cleared the PIN field and prevented both action buttons from being
 * usable.
 */
class BlockOverlayService : Service() {
    private var windowManager: WindowManager? = null
    private var overlayView: View? = null
    private var displayedPackageName: String? = null
    private var displayedPhoneLock = false

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val blockedPackage = intent?.getStringExtra(EXTRA_PACKAGE)
            ?: applicationContext.packageName
        val appName = intent?.getStringExtra(EXTRA_APP_NAME)
            ?: getString(R.string.blocked_app)
        val phoneLock = intent?.getBooleanExtra(EXTRA_PHONE_LOCK, false) ?: false

        if (overlayView != null &&
            displayedPackageName == blockedPackage &&
            displayedPhoneLock == phoneLock
        ) {
            return START_STICKY
        }

        showOverlay(blockedPackage, appName, phoneLock)
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        removeOverlay()
        super.onDestroy()
    }

    private fun showOverlay(
        blockedPackage: String,
        appName: String,
        phoneLock: Boolean,
    ) {
        if (!LimitPolicy.hasOverlay(this)) return

        removeOverlay()
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setPadding(48, 64, 48, 64)
            setBackgroundColor(0xFF111827.toInt())
            isFocusable = true
            isFocusableInTouchMode = true
            setOnKeyListener { _, keyCode, _ -> keyCode == KeyEvent.KEYCODE_BACK }
        }

        val icon = ImageView(this).apply {
            val drawable = runCatching {
                packageManager.getApplicationIcon(blockedPackage)
            }.getOrNull() ?: getDrawable(android.R.drawable.ic_lock_lock)
            setImageDrawable(drawable)
            layoutParams = LinearLayout.LayoutParams(160, 160).apply {
                bottomMargin = 28
            }
        }
        val title = TextView(this).apply {
            text = appName
            textSize = 28f
            setTextColor(0xFFFFFFFF.toInt())
            gravity = Gravity.CENTER
        }
        val message = TextView(this).apply {
            text = if (phoneLock) {
                getString(R.string.phone_limit_reached)
            } else {
                getString(R.string.app_limit_reached)
            }
            textSize = 18f
            setTextColor(0xFFE5E7EB.toInt())
            gravity = Gravity.CENTER
            layoutParams = LinearLayout.LayoutParams(-1, -2).apply {
                topMargin = 12
                bottomMargin = 10
            }
        }
        val tomorrow = TextView(this).apply {
            text = getString(R.string.come_back_tomorrow)
            textSize = 15f
            setTextColor(0xFFCBD5E1.toInt())
            gravity = Gravity.CENTER
            layoutParams = LinearLayout.LayoutParams(-1, -2).apply {
                bottomMargin = 24
            }
        }
        val pin = EditText(this).apply {
            hint = getString(R.string.parent_pin_hint)
            setTextColor(0xFFFFFFFF.toInt())
            setHintTextColor(0xFFCBD5E1.toInt())
            inputType = InputType.TYPE_CLASS_NUMBER or
                InputType.TYPE_NUMBER_VARIATION_PASSWORD
            layoutParams = LinearLayout.LayoutParams(-1, -2).apply {
                bottomMargin = 16
            }
        }
        val unlock = Button(this).apply {
            text = getString(R.string.unlock_with_parent)
            layoutParams = LinearLayout.LayoutParams(-1, -2).apply {
                bottomMargin = 10
            }
            setOnClickListener {
                if (LimitPolicy.verifySecret(this@BlockOverlayService, pin.text.toString())) {
                    LimitPolicy.grantParentUnlock(
                        this@BlockOverlayService,
                        blockedPackage,
                        phoneLock,
                    )
                    removeOverlay()
                    stopSelf()
                } else {
                    Toast.makeText(
                        this@BlockOverlayService,
                        getString(R.string.wrong_parent_pin),
                        Toast.LENGTH_SHORT,
                    ).show()
                }
            }
        }
        val emergency = Button(this).apply {
            text = getString(R.string.emergency_call)
            layoutParams = LinearLayout.LayoutParams(-1, -2)
            setOnClickListener {
                // Do not hard-code a regional emergency number. Android opens
                // the dialer, and the temporary grace period prevents the
                // monitor from immediately covering it again.
                LimitPolicy.grantEmergencyGrace(this@BlockOverlayService)
                removeOverlay()
                stopSelf()
                val dialIntent = Intent(Intent.ACTION_DIAL)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(dialIntent)
            }
        }

        root.addView(icon)
        root.addView(title)
        root.addView(message)
        root.addView(tomorrow)
        root.addView(pin)
        root.addView(unlock)
        root.addView(emergency)

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            } else {
                WindowManager.LayoutParams.TYPE_PHONE
            },
            WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
                WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            PixelFormat.TRANSLUCENT,
        ).apply {
            gravity = Gravity.CENTER
        }

        runCatching {
            windowManager?.addView(root, params)
        }.onSuccess {
            overlayView = root
            displayedPackageName = blockedPackage
            displayedPhoneLock = phoneLock
        }
    }

    private fun removeOverlay() {
        val view = overlayView ?: return
        runCatching { windowManager?.removeViewImmediate(view) }
        overlayView = null
        displayedPackageName = null
        displayedPhoneLock = false
    }

    companion object {
        private const val EXTRA_PACKAGE = "packageName"
        private const val EXTRA_APP_NAME = "appName"
        private const val EXTRA_PHONE_LOCK = "phoneLock"

        fun show(
            context: Context,
            packageName: String,
            appName: String,
            phoneLock: Boolean = false,
        ) {
            val intent = Intent(context, BlockOverlayService::class.java)
                .putExtra(EXTRA_PACKAGE, packageName)
                .putExtra(EXTRA_APP_NAME, appName)
                .putExtra(EXTRA_PHONE_LOCK, phoneLock)
            context.startService(intent)
        }
    }
}
