package br.com.keyboard_utils.manager

import android.app.Activity
import android.graphics.drawable.ColorDrawable
import android.os.CountDownTimer
import android.os.Handler
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.PopupWindow
import br.com.keyboard_utils.R

/**
 * Created by Wilson Martins on 2019-10-25.
 */

interface KeyboardUtils {
    fun start()

    fun registerKeyboardListener()

    fun registerKeyboardSettings()

    fun handleKeyboard()

    fun onKeyboardOpen(action: (height: Int) -> Unit)

    fun onKeyboardClose(action: () -> Unit)
}

class KeyboardUtilsImpl(activity: Activity) : PopupWindow(activity), KeyboardUtils {

    // keyboard popup view
    private val keyboardView: View

    // screen parent view
    private var parentView: View

    // keyboard action listeners -> this objects will call when KeyboardUtils handle keyboard
    // open event or close event;
    private var keyboardOpenedEvent: (altura: Int) -> Unit? = {}
    private var keyboardClosedEvent: () -> Unit? = {}

    // keyboard status flag
    private var keyboardOpened: Boolean = false

    // last keyboard height
    private var lastKeyboardHeight = 0

    // device manager -> this object do magics!
    private val deviceDimensionsManager: DeviceDimesions

    // keyboard sessions heights -> TODO
    private var keyboardSessionHeights = arrayListOf<Int>()

    // keyboard session timer -> TODO
    private var keyboardSessionTimer: CountDownTimer? = null

    init {
        val inflator = activity.getSystemService(Activity.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        this.keyboardView = inflator.inflate(R.layout.teclado_popup, null, false)

        // define this content view as keyboard view
        contentView = keyboardView

        // creates THE MAGIC!
        deviceDimensionsManager = DeviceDimesionsImpl(activity, keyboardView)

        // set keyboard popup settings
        registerKeyboardSettings()
        parentView = activity.findViewById(android.R.id.content)

        // MAGIC MAGIC
        handleKeyboard()
    }

    override fun handleKeyboard() {
        keyboardSessionTimer = object : CountDownTimer(150, 1) {
            override fun onFinish() {
                keyboardSessionHeights.max()?.let {
                    if (it > 0 && lastKeyboardHeight != it) {
                        keyboardOpenedEvent(it)
                        lastKeyboardHeight = -1
                    } else if (it == 0) {
                        keyboardClosedEvent()
                    }
                    keyboardOpened = false
                    keyboardSessionTimer?.cancel()
                    keyboardSessionHeights.clear()
                    lastKeyboardHeight = it
                }
            }

            override fun onTick(millisUntilFinished: Long) {
                val alturaTecladoCalculada = deviceDimensionsManager.keyboardHeight()
                keyboardSessionHeights.add(alturaTecladoCalculada)
            }
        }

        keyboardView.viewTreeObserver?.addOnGlobalLayoutListener {
            if (!keyboardOpened || keyboardSessionHeights.size == 0 && keyboardOpened) {
                keyboardOpened = true
                keyboardSessionTimer?.start()

            }
        }
    }

    override fun start() {
        Handler().postDelayed({
            if (!isShowing && parentView.windowToken != null) {
                setBackgroundDrawable(ColorDrawable(0))
                showAtLocation(parentView, Gravity.NO_GRAVITY, 0, 0)
            }
        }, 100)
    }

    override fun registerKeyboardSettings() {
        softInputMode = WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE or WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE
        inputMethodMode = INPUT_METHOD_NEEDED

        width = 0
        height = WindowManager.LayoutParams.MATCH_PARENT
    }

    override fun registerKeyboardListener() {
        keyboardView.viewTreeObserver?.addOnGlobalLayoutListener {
            if (!keyboardOpened || keyboardSessionHeights.size == 0 && keyboardOpened) {
                keyboardOpened = true
                keyboardSessionTimer?.start()
            }
        }
    }

    override fun onKeyboardOpen(action: (height: Int) -> Unit) {
        keyboardOpenedEvent = action
    }

    override fun onKeyboardClose(action: () -> Unit) {
        keyboardClosedEvent = action
    }
}