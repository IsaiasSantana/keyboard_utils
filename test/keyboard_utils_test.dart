import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keyboard_utils/keyboard_listener.dart';
import 'package:keyboard_utils/keyboard_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late EventsChannelSpy eventsChannelSpy = EventsChannelSpy('keyboard_utils');

  late final keyboardUtils = KeyboardUtils();

  tearDown(() {
    keyboardUtils.removeAllKeyboardListeners();
  });

  test('addNewListener_shouldReturnCorrectSubscribe_id', () {
    final listener = KeyboardListener(
      willHideKeyboard: () {},
      willShowKeyboard: (heightKeyboard) {},
    );
    final int idOne = keyboardUtils.add(listener: listener);
    final int idTwo = keyboardUtils.add(listener: listener);
    final int idThree = keyboardUtils.add(listener: listener);

    expect(idOne, 0);
    expect(idTwo, 1);
    expect(idThree, 2);
  });

  test('insertAndRemoveListener', () {
    final listener = KeyboardListener(
      willHideKeyboard: () {},
      willShowKeyboard: (heightKeyboard) {},
    );

    final idOne = keyboardUtils.add(listener: listener);
    final isRemoved = keyboardUtils.unsubscribeListener(subscribingId: idOne);

    expect(isRemoved, true);

    final idTwo = keyboardUtils.add(listener: listener);
    final isIdTwoRemoved =
        keyboardUtils.unsubscribeListener(subscribingId: idTwo);

    expect(idTwo > idOne, true);
    expect(isIdTwoRemoved, true);
  });

  test('unsubscribeListener_shouldReturnTrue', () {
    final listener = KeyboardListener(
      willHideKeyboard: () {},
      willShowKeyboard: (heightKeyboard) {},
    );

    final int id = keyboardUtils.add(listener: listener);
    final isRemoved = keyboardUtils.unsubscribeListener(subscribingId: id);

    expect(isRemoved, true);
  });

  test('unsubscribeListener_withWrongId_shouldReturnFalse', () {
    final listener = KeyboardListener(
      willHideKeyboard: () {},
      willShowKeyboard: (heightKeyboard) {},
    );

    final int id = keyboardUtils.add(listener: listener);
    final isRemoved = keyboardUtils.unsubscribeListener(subscribingId: id + 1);

    expect(isRemoved, false);
  });

  test('unsubscribeListener_withoutListeners_shouldReturnFalse', () {
    final isRemoved = keyboardUtils.unsubscribeListener(subscribingId: -1);

    expect(isRemoved, false);
  });

  test('canCallDispose_withListener_shouldReturnFalse', () {
    final listener = KeyboardListener(
      willHideKeyboard: () {},
      willShowKeyboard: (heightKeyboard) {},
    );

    keyboardUtils.add(listener: listener);

    expect(keyboardUtils.canCallDispose(), false);
  });

  test('canCallDispose_withoutListener_shouldReturnTrue', () {
    expect(keyboardUtils.canCallDispose(), true);
  });

  test('addAndRemoveListeners_shouldHaveNoListener', () {
    final listener = KeyboardListener(
      willHideKeyboard: () {},
      willShowKeyboard: (heightKeyboard) {},
    );
    keyboardUtils.add(listener: listener);
    keyboardUtils.add(listener: listener);
    keyboardUtils.add(listener: listener);

    keyboardUtils.removeAllKeyboardListeners();

    expect(keyboardUtils.canCallDispose(), true);
  });

  test('willShowKeyboard', () async {
    final fakeKeyboardListener = KeyboardListenerSpy();
    final jsonTest = '{ "isKeyboardOpen": true, "keyboardHeight": 200}';

    keyboardUtils.add(listener: fakeKeyboardListener);

    await eventsChannelSpy.sendEvent(jsonTest);

    expect(fakeKeyboardListener.willShowKeyboardCalled, true);
    expect(fakeKeyboardListener.willHideKeyboardCalled, false);
    expect(fakeKeyboardListener.keyboardHeightPassed, 200);
    expect(keyboardUtils.keyboardHeight, 200.0);
    expect(keyboardUtils.isKeyboardOpen, true);
  });

  test('willHideKeyboard', () async {
    final fakeKeyboardListener = KeyboardListenerSpy();
    final jsonTest = '{ "isKeyboardOpen": false, "keyboardHeight": 0.0}';

    keyboardUtils.add(listener: fakeKeyboardListener);

    await eventsChannelSpy.sendEvent(jsonTest);

    expect(fakeKeyboardListener.willShowKeyboardCalled, false);
    expect(fakeKeyboardListener.willHideKeyboardCalled, true);
    expect(fakeKeyboardListener.keyboardHeightPassed, null);
    expect(keyboardUtils.keyboardHeight, 0.0);
    expect(keyboardUtils.isKeyboardOpen, false);
  });
}

class KeyboardListenerSpy extends KeyboardListener {
  bool willHideKeyboardCalled = false;
  bool willShowKeyboardCalled = false;
  double? keyboardHeightPassed;

  KeyboardListenerSpy()
      : super(willShowKeyboard: (height) {}, willHideKeyboard: () {});

  @override
  Function get willHideKeyboard => () {
        willHideKeyboardCalled = true;
      };

  @override
  Function(double p1) get willShowKeyboard => (keyboardHeight) {
        willShowKeyboardCalled = true;
        keyboardHeightPassed = keyboardHeight;
      };
}

class EventsChannelSpy {
  EventsChannelSpy(String name) {
    eventsMethodChannel = MethodChannel(name);
    eventsMethodChannel.setMockMethodCallHandler(onMethodCall);
  }

  late MethodChannel eventsMethodChannel;

  Future<dynamic> onMethodCall(MethodCall call) {
    return Future<void>.sync(() {});
  }

  Future<void> sendEvent(dynamic event) {
    return _sendMessage(
        const StandardMethodCodec().encodeSuccessEnvelope(event));
  }

  Future<void> _sendMessage(ByteData data) {
    return ServicesBinding.instance!.defaultBinaryMessenger
        .handlePlatformMessage(
            eventsMethodChannel.name, data, (ByteData? data) {});
  }
}
