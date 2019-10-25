import 'dart:async';

import 'package:flutter/services.dart';

class KeyboardListener {
  KeyboardListener({this.willShowKeyboard, this.willHideKeyboard});

  final Function willShowKeyboard;
  final Function willHideKeyboard;
}

class KeyboardUtils {

  static const EventChannel _eventChannel = EventChannel('keyboard_utils');

  static KeyboardListener _keyboardListener;

  static StreamSubscription _keyboardSubscription;

  KeyboardUtils() {
    _keyboardSubscription ??= _eventChannel
        .receiveBroadcastStream()
        .listen(_onKeyboardListener);
  }

  void add({KeyboardListener listener}) {
    _keyboardListener = listener;
  }

  void _onKeyboardListener(Object data) {
    print('Olá $data');
   // _keyboardListener.willHideKeyboard
  }
}
