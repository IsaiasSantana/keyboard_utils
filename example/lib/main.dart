import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:keyboard_utils/keyboard_utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  KeyboardUtils  _keyboardUtils = KeyboardUtils();

  @override
  void initState() {
    super.initState();

    final KeyboardListener listener = KeyboardListener(
      willHideKeyboard: () {

      },
      willShowKeyboard: () {

      }
    );

    _keyboardUtils.add(listener: listener);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: TextField(),
        ),
      ),
    );
  }
}
