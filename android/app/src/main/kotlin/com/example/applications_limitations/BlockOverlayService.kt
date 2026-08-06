package com.example.applications_limitations

import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.IBinder
import android.text.Editable
import android.text.InputType
import android.text.TextWatcher
import android.view.Gravity
import android.view.KeyEvent
import android.view.View
import android.view.WindowManager
import android.view.inputmethod.EditorInfo
import android.widget.EditText
import android.widget.GridLayout
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast

/**
 * Native full-screen surface displayed when a phone or app limit is reached.
 *
 * It intentionally contains no dismiss, emergency, or secondary action
 * buttons. The parent enters the credential directly; when it matches, the
 * overlay is removed and Android reveals the app that was underneath it.
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

        // The monitor checks often. Do not replace a visible pattern while the
        // parent is entering it.
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

        val scrollRoot = ScrollView(this).apply {
            layoutParams = WindowManager.LayoutParams(
                WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.MATCH_PARENT,
            )
            isFillViewport = true
        }

        val content = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_HORIZONTAL
            setPadding(dp(24), dp(20), dp(24), dp(24))
            setBackgroundColor(overlayBackgroundColor)
            isFocusable = true
            isFocusableInTouchMode = true
            setOnKeyListener { _, keyCode, _ ->
                if (keyCode == KeyEvent.KEYCODE_BACK) {
                    goBackAndReturn()
                    true
                } else false
            }
        }

        val card = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_HORIZONTAL
            setPadding(dp(28), dp(30), dp(28), dp(28))
            background = roundedDrawable(
                color = cardColor,
                cornerRadius = 32,
                strokeColor = Color.argb(45, 255, 255, 255),
            )
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT,
            )
        }

        val icon = ImageView(this).apply {
            val drawable = runCatching {
                packageManager.getApplicationIcon(blockedPackage)
            }.getOrNull() ?: getDrawable(android.R.drawable.ic_lock_lock)
            setImageDrawable(drawable)
            background = roundedDrawable(
                color = Color.WHITE,
                cornerRadius = 24,
            )
            setPadding(dp(12), dp(12), dp(12), dp(12))
            layoutParams = LinearLayout.LayoutParams(dp(86), dp(86)).apply {
                bottomMargin = dp(12)
            }
        }
        val title = TextView(this).apply {
            text = appName
            textSize = 25f
            setTextColor(Color.WHITE)
            gravity = Gravity.CENTER
            maxLines = 2
        }
        val message = TextView(this).apply {
            text = if (phoneLock) {
                getString(R.string.phone_limit_reached)
            } else {
                getString(R.string.app_limit_reached)
            }
            textSize = 16f
            setTextColor(secondaryTextColor)
            gravity = Gravity.CENTER
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT,
            ).apply {
                topMargin = dp(6)
            }
        }
        val credentialHint = TextView(this).apply {
            text = if (LimitPolicy.usesPatternCredential(this@BlockOverlayService)) {
                getString(R.string.parent_pattern_instruction)
            } else {
                getString(R.string.parent_pin_instruction)
            }
            textSize = 14f
            setTextColor(secondaryTextColor)
            gravity = Gravity.CENTER
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT,
            ).apply {
                topMargin = dp(16)
                bottomMargin = dp(8)
            }
        }

        card.addView(icon)
        card.addView(title)
        card.addView(message)
        card.addView(credentialHint)

        if (LimitPolicy.usesPatternCredential(this)) {
            card.addView(
                createPatternPad(
                    blockedPackage = blockedPackage,
                    phoneLock = phoneLock,
                ),
            )
        } else {
            card.addView(
                createPinEntry(
                    blockedPackage = blockedPackage,
                    phoneLock = phoneLock,
                ),
            )
        }

        if (phoneLock) {
            val reopenHint = TextView(this).apply {
                text = getString(R.string.phone_limit_reopen_hint)
                textSize = 13f
                setTextColor(secondaryTextColor)
                gravity = Gravity.CENTER
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                ).apply {
                    topMargin = dp(10)
                }
            }
            card.addView(reopenHint)
        }

        card.addView(createGoBackButton())

        content.addView(card)
        scrollRoot.addView(content)

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
            windowManager?.addView(scrollRoot, params)
        }.onSuccess {
            overlayView = scrollRoot
            displayedPackageName = blockedPackage
            displayedPhoneLock = phoneLock
        }
    }

    /** A nine-dot parent pattern that verifies as soon as the sequence matches. */
    private fun createPatternPad(
        blockedPackage: String,
        phoneLock: Boolean,
    ): View {
        val pattern = mutableListOf<Int>()
        val dots = mutableListOf<TextView>()
 val grid = GridLayout(this).apply {
    rowCount = 3
    columnCount = 3
    alignmentMode = GridLayout.ALIGN_BOUNDS
    useDefaultMargins = false
    layoutParams = LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.WRAP_CONTENT,
        LinearLayout.LayoutParams.WRAP_CONTENT,
    ).apply {
        gravity = Gravity.CENTER
    }
}

        fun renderPattern() {
            dots.forEachIndexed { index, dot ->
                val selected = pattern.contains(index + 1)
                dot.background = circularDotDrawable(selected)
            }
        }

        fun clearPattern(showError: Boolean = false) {
            pattern.clear()
            renderPattern()
            if (showError) {
                Toast.makeText(
                    this,
                    getString(R.string.wrong_parent_pattern),
                    Toast.LENGTH_SHORT,
                ).show()
            }
        }

        repeat(9) { index ->
            val dotId = index + 1
            val dot = TextView(this).apply {
                contentDescription = getString(R.string.parent_pattern_dot, dotId)
                isClickable = true
                isFocusable = true
                background = circularDotDrawable(selected = false)
                layoutParams = GridLayout.LayoutParams(
                    GridLayout.spec(index / 3),
                    GridLayout.spec(index % 3),
                ).apply {
                    width = dp(58)
                    height = dp(58)
                    setMargins(dp(10), dp(10), dp(10), dp(10))
                }
                setOnClickListener {
                    // Tapping any selected dot is a simple, button-free way to
                    // start the pattern again after a mistake.
                    if (pattern.contains(dotId)) {
                        clearPattern()
                        return@setOnClickListener
                    }

                    pattern += dotId
                    renderPattern()
                    if (pattern.size < minimumPatternLength) return@setOnClickListener

                    val secret = pattern.joinToString(separator = "-")
                    if (LimitPolicy.verifySecret(this@BlockOverlayService, secret)) {
                        unlockAndReturn(blockedPackage, phoneLock)
                    } else if (pattern.size == 9) {
                        clearPattern(showError = true)
                    }
                }
            }
            dots += dot
            grid.addView(dot)
        }

        return grid
    }

    /** Legacy PIN credentials stay supported, with no unlock button required. */
    private fun createPinEntry(
        blockedPackage: String,
        phoneLock: Boolean,
    ): View {
        var checking = false
        val pin = EditText(this).apply {
            hint = getString(R.string.parent_pin_hint)
            setTextColor(Color.WHITE)
            setHintTextColor(secondaryTextColor)
            textSize = 18f
            gravity = Gravity.CENTER
            inputType = InputType.TYPE_CLASS_NUMBER or
                InputType.TYPE_NUMBER_VARIATION_PASSWORD
            imeOptions = EditorInfo.IME_ACTION_DONE
            background = roundedDrawable(
                color = Color.argb(32, 255, 255, 255),
                cornerRadius = 18,
                strokeColor = Color.argb(70, 255, 255, 255),
            )
            setPadding(dp(18), dp(14), dp(18), dp(14))
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT,
            )
        }

        fun verifyPin(showError: Boolean) {
            if (checking || pin.text.length < minimumPatternLength) return
            checking = true
            if (LimitPolicy.verifySecret(this@BlockOverlayService, pin.text.toString())) {
                unlockAndReturn(blockedPackage, phoneLock)
                return
            }
            checking = false
            if (showError) {
                pin.text?.clear()
                Toast.makeText(
                    this,
                    getString(R.string.wrong_parent_pin),
                    Toast.LENGTH_SHORT,
                ).show()
            }
        }

        pin.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(
                text: CharSequence?,
                start: Int,
                count: Int,
                after: Int,
            ) = Unit

            override fun onTextChanged(
                text: CharSequence?,
                start: Int,
                before: Int,
                count: Int,
            ) = Unit

            override fun afterTextChanged(editable: Editable?) {
                val length = editable?.length ?: 0
                if (length >= minimumPatternLength) {
                    verifyPin(showError = length >= maximumPinLength)
                }
            }
        })
        pin.setOnEditorActionListener { _, actionId, _ ->
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                verifyPin(showError = true)
                true
            } else {
                false
            }
        }
        return pin
    }

    private fun unlockAndReturn(blockedPackage: String, phoneLock: Boolean) {
        LimitPolicy.grantParentUnlock(this, blockedPackage, phoneLock)
        removeOverlay()
        stopSelf()
    }

    /**
     * A simple "Go back" action that closes the blocked surface and returns the
     * child to the home screen / another app. It only dismisses the overlay; the
     * foreground monitor will re-show it if the blocked app is opened again or
     * the phone lock is still active.
     */
    private fun createGoBackButton(): View = TextView(this).apply {
        text = getString(R.string.blocking_go_back)
        textSize = 15f
        setTextColor(Color.WHITE)
        isFocusable = true
        isClickable = true
        gravity = Gravity.CENTER
        background = roundedDrawable(
            color = Color.argb(55, 255, 255, 255),
            cornerRadius = 16,
            strokeColor = Color.argb(140, 255, 255, 255),
        )
        setPadding(dp(18), dp(12), dp(18), dp(12))
        layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT,
        ).apply {
            topMargin = dp(10)
        }
        setOnClickListener { goBackAndReturn() }
    }

    private fun goBackAndReturn() {
        removeOverlay()
        stopSelf()
        goHome()
    }

    private fun goHome() {
        val intent = Intent(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_HOME)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        runCatching { startActivity(intent) }
    }

    private fun circularDotDrawable(selected: Boolean): GradientDrawable =
        GradientDrawable().apply {
            shape = GradientDrawable.OVAL
            setColor(if (selected) accentColor else Color.argb(38, 255, 255, 255))
            setStroke(dp(2), if (selected) Color.WHITE else Color.argb(115, 255, 255, 255))
        }

    private fun roundedDrawable(
        color: Int,
        cornerRadius: Int,
        strokeColor: Int? = null,
    ): GradientDrawable = GradientDrawable().apply {
        setColor(color)
        this.cornerRadius = dp(cornerRadius).toFloat()
        strokeColor?.let { setStroke(dp(1), it) }
    }

    private fun dp(value: Int): Int =
        (value * resources.displayMetrics.density).toInt()

    private fun removeOverlay() {
        val view = overlayView ?: return
        runCatching { windowManager?.removeViewImmediate(view) }
        overlayView = null
        displayedPackageName = null
        displayedPhoneLock = false
    }

    companion object {
        private const val minimumPatternLength = 4
        private const val maximumPinLength = 8
        private val overlayBackgroundColor = 0xFF0A1221.toInt()
        private val cardColor = 0xFF17243A.toInt()
        private val accentColor = 0xFF47B8FF.toInt()
        private val secondaryTextColor = 0xFFC7D5E8.toInt()

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
