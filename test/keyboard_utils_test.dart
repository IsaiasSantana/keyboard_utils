import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keyboard_utils/keyboard_utils.dart';

void main() {
  const MethodChannel channel = MethodChannel('keyboard_utils');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    // expect(await KeyboardUtils.platformVersion, '42');
  });
}
