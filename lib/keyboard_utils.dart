import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'keyboard_listener.dart';
import 'keyboard_options.dart';

class KeyboardUtils {
  KeyboardUtils() {
    if (!kIsWeb) {
      _keyboardSubscription ??=
          _eventChannel.receiveBroadcastStream().listen(_onKeyboardListener);
    }
  }

  static const EventChannel _eventChannel = EventChannel('keyboard_utils');

  static StreamSubscription? _keyboardSubscription;

  static Map<int, KeyboardListener> _listenersKeyboardEvents =
      Map<int, KeyboardListener>();

  static KeyboardOptions? _keyboardOptions;

  /// the current height of the keyboard. if keyboard is closed, the height is 0.0.
  double get keyboardHeight => _keyboardOptions?.keyboardHeight ?? 0.0;

  /// the current state of the keyboard. It is false if keyboard was not open for the first time.
  bool get isKeyboardOpen => _keyboardOptions?.isKeyboardOpen ?? false;

  void _onKeyboardListener(Object? data) {
    final keyboardOptions = _decodeDataToKeyboardOptions(data: data);
    if (keyboardOptions != null) {
      _notifyListenersWith(keyboardOptions: keyboardOptions);
    }
  }

  KeyboardOptions? _decodeDataToKeyboardOptions({required Object? data}) {
    if (data != null && data is String) {
      try {
        final Map<String, dynamic> keyboardOptionsMap = jsonDecode(data);
        return KeyboardOptions.fromJson(keyboardOptionsMap);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  void _notifyListenersWith({required KeyboardOptions keyboardOptions}) {
    for (final KeyboardListener listener in _listenersKeyboardEvents.values) {
      if (keyboardOptions.isKeyboardOpen) {
        _notifyWillShowKeyboardTo(
          listener: listener,
          keyboardHeight: keyboardOptions.keyboardHeight,
        );
      } else {
        _notifyWillHideKeyboardTo(listener: listener);
      }
    }
  }

  void _notifyWillShowKeyboardTo({
    required KeyboardListener listener,
    required double keyboardHeight,
  }) {
    if (listener.willShowKeyboard != null) {
      listener.willShowKeyboard!(keyboardHeight);
    }
  }

  void _notifyWillHideKeyboardTo({required KeyboardListener listener}) {
    if (listener.willHideKeyboard != null) {
      listener.willHideKeyboard!();
    }
  }

  /// Subscribe to a keyboard event.
  /// [listener] object to listen the event.
  /// Returns a subscribing id that can be used to unsubscribe.
  int add({required KeyboardListener listener}) {
    final int length = _listenersKeyboardEvents.length;
    _listenersKeyboardEvents[length] = listener;
    return length;
  }

  /// Unsubscribe from the keyboard visibility events
  /// [subscribingId] An id previously returned on add
  bool unsubscribeListener({required int? subscribingId}) {
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

  ///  function to clear class on dispose.
  void dispose() {
    if (canCallDispose()) {
      _keyboardSubscription?.cancel().catchError((e) {});
      _keyboardSubscription = null;
    }
  }

  bool canCallDispose() {
    return _listenersKeyboardEvents.isEmpty;
  }
}
