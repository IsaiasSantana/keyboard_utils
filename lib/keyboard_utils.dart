import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'keyboard_listener.dart';
import 'keyboard_options.dart';

class KeyboardUtils {
  KeyboardUtils() {
    _keyboardSubscription ??=
        _eventChannel.receiveBroadcastStream().listen(_onKeyboardListener);
  }

  static const EventChannel _eventChannel = EventChannel('keyboard_utils');

  static StreamSubscription _keyboardSubscription;

  static Map<int, KeyboardListener> _listenersKeyboardEvents =
      Map<int, KeyboardListener>();

  static KeyboardOptions _keyboardOptions;

  /// the current height of the keyboard. if keyboard is closed, the height is 0.0.
  double get keyboardHeight => _keyboardOptions?.keyboardHeight ?? 0.0;

  /// the current state of the keyboard. It is false if keyboard was not open for the first time.
  bool get isKeyboardOpen => _keyboardOptions?.isKeyboardOpen ?? false;

  /// Subscribe to a keyboard event.
  /// [listener] object to listen the event.
  /// Returns a subscribing id that can be used to unsubscribe.
  int add({@required KeyboardListener listener}) {
    if (listener == null) {
      throw Exception('The listener cannot be null.');
    }

    final int length = _listenersKeyboardEvents.length;
    _listenersKeyboardEvents[length] = listener;
    return length;
  }

  /// Unsubscribe from the keyboard visibility events
  /// [subscribingId] An id previously returned on add
  bool unsubscribeListener({@required int subscribingId}) {
    if (subscribingId == null) {
      return false;
    }

    if (_listenersKeyboardEvents.isEmpty) {
      return false;
    }

    if (_listenersKeyboardEvents.containsKey(subscribingId)) {
      _listenersKeyboardEvents.remove(subscribingId);
      return true;
    }

    return false;
  }

  void removeAllKeyboardListeners() {
    if (_listenersKeyboardEvents.isEmpty) {
      return;
    }

    _listenersKeyboardEvents.clear();
  }

  void _onKeyboardListener(Object data) {
    if (data != null && data is String) {
      try {
        final Map<String, dynamic> keyboardOptionsMap = jsonDecode(data);
        _keyboardOptions = KeyboardOptions.fromJson(keyboardOptionsMap);

        _listenersKeyboardEvents.forEach((_, final KeyboardListener listener) {
          if (_keyboardOptions.isKeyboardOpen &&
              listener.willShowKeyboard != null) {
            listener.willShowKeyboard(_keyboardOptions.keyboardHeight);
            return;
          }

          if (!_keyboardOptions.isKeyboardOpen &&
              listener.willHideKeyboard != null) {
            listener.willHideKeyboard();
          }
        });
      } on dynamic catch (_) {}
    }
  }

  bool canCallDispose() {
    return _listenersKeyboardEvents.isEmpty;
  }

  ///  function to clear class on dispose.
  void dispose() {
    if (canCallDispose()) {
      _keyboardSubscription?.cancel()?.catchError((e) {});
      _keyboardSubscription = null;
    }
  }
}
