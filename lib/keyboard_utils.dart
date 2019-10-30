import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'keyboard_listener.dart';
import 'keyboard_options.dart';

class KeyboardUtils {
  KeyboardUtils() {
    _keyboardSubscription ??=
        _eventChannel.receiveBroadcastStream().listen(_onKeyboardListener);
  }

  static const EventChannel _eventChannel = EventChannel('keyboard_utils');

  static KeyboardListener _keyboardListener;

  static StreamSubscription _keyboardSubscription;

  KeyboardOptions _keyboardOptions;

  /// the current height of the keyboard. if keyboard is closed, the height is 0.0.
  double get keyboardHeight => _keyboardOptions?.keyboardHeight ?? 0.0;

  /// the current state of the keyboard. It is false if keyboard was not open for the first time.
  bool get isKeyboardOpen => _keyboardOptions?.isKeyboardOpen ?? false;

  /// Subscribe to a keyboard event.
  /// [listener] object to listen the event.
  void add({KeyboardListener listener}) {
    _keyboardListener = listener;
  }

  void _onKeyboardListener(Object data) {
    if (data != null && data is String) {
      try {
        final Map<String, dynamic> keyboardOptionsMap = jsonDecode(data);
        _keyboardOptions = KeyboardOptions.fromJson(keyboardOptionsMap);

        if (_keyboardOptions.isKeyboardOpen &&
            _keyboardListener?.willShowKeyboard != null) {
          _keyboardListener.willShowKeyboard(_keyboardOptions.keyboardHeight);
          return;
        }

        if (!_keyboardOptions.isKeyboardOpen &&
            _keyboardListener?.willHideKeyboard != null) {
          _keyboardListener.willHideKeyboard();
        }
      } on Exception catch (_) {}
    }
  }

  ///  function to clear class on dispose.
  void dispose() {
    _keyboardSubscription?.cancel()?.catchError((e) {});
    _keyboardSubscription = null;
  }
}
