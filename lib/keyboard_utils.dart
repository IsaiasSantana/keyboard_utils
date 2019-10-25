import 'dart:async';

import 'package:flutter/services.dart';

class KeyboardUtils {
  static const MethodChannel _channel =
      const MethodChannel('keyboard_utils');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
