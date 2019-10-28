package br.com.keyboard_utils.manager

import io.flutter.plugin.common.EventChannel

/**
 * Created by Wilson Martins on 2019-10-28.
 */

class KeyboardEventChannel(private val keyboardUtil: KeyboardUtils) : EventChannel.StreamHandler {
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        keyboardUtil.onKeyboardOpen {
            val resultJSON = KeyboardOptions(isKeyboardOpen = true, height = it)
            events?.success(resultJSON.toJson())
        }

        keyboardUtil.onKeyboardClose {
            val resultJSON = KeyboardOptions(isKeyboardOpen = false, height = 0)
            events?.success(resultJSON.toJson())
        }
    }

    override fun onCancel(arguments: Any?) {}
}