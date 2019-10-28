import 'package:flutter/material.dart';

import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:keyboard_utils/keyboard_listener.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  KeyboardUtils  _keyboardUtils = KeyboardUtils();

  @override
  void initState() {
    super.initState();

    final KeyboardListener listener = KeyboardListener(
      willHideKeyboard: () {
        print('called -> willHideKeyboard()');
      },
      willShowKeyboard: (double keyboardHeight) {
        print('willShowKeyboard() height: $keyboardHeight');
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
          child: Column(
            children: <Widget>[
              TextField(),
              TextField(keyboardType: TextInputType.number,),
              TextField(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _keyboardUtils.dispose();

    super.dispose();
  }
}
