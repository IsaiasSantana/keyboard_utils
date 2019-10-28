package br.com.keyboard_utils

import android.app.Activity
import br.com.keyboard_utils.manager.KeyboardOptions
import br.com.keyboard_utils.manager.KeyboardUtils
import br.com.keyboard_utils.manager.KeyboardUtilsImpl
import br.com.keyboard_utils.utils.KeyboardConstants.Companion.CHANNEL_IDENTIFIER
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.PluginRegistry

class KeyboardUtilsPlugin(activity: Activity) : EventChannel.StreamHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: PluginRegistry.Registrar) {
      val channel = EventChannel(registrar.view(), CHANNEL_IDENTIFIER)
      channel.setStreamHandler(KeyboardUtilsPlugin(registrar.activity()))
    }
  }

  private val keyboardUtil: KeyboardUtils = KeyboardUtilsImpl(activity)

  init {
    keyboardUtil.start()
  }

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
