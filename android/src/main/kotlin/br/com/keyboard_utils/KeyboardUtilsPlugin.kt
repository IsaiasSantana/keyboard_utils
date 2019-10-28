package br.com.keyboard_utils

import br.com.keyboard_utils.manager.KeyboardEventChannel
import br.com.keyboard_utils.manager.KeyboardUtils
import br.com.keyboard_utils.manager.KeyboardUtilsImpl
import br.com.keyboard_utils.utils.KeyboardConstants.Companion.CHANNEL_IDENTIFIER
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.EventChannel

class KeyboardUtilsPlugin {
  companion object {
    fun registerWith(flutterActivity: FlutterActivity) {
      val keyboardUtilsPlugin: KeyboardUtils = KeyboardUtilsImpl(flutterActivity)
      keyboardUtilsPlugin.start()

      EventChannel(
              flutterActivity.flutterView,
              CHANNEL_IDENTIFIER
      ).setStreamHandler(KeyboardEventChannel(keyboardUtilsPlugin))
    }
  }
}
