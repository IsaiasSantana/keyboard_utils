import 'package:flutter/material.dart';
import 'package:keyboard_utils/keyboard_listener.dart';
import 'package:keyboard_utils/keyboard_options.dart';
import 'package:keyboard_utils/keyboard_utils.dart';

class KeyboardAware extends StatefulWidget {
  const KeyboardAware({@required this.builder});

  final Widget Function(
      BuildContext context, KeyboardOptions configuracaoTeclado) builder;

  @override
  State<KeyboardAware> createState() => _KeyboardAwareState();
}

class _KeyboardAwareState extends State<KeyboardAware> {
  final KeyboardUtils _keyboardUtils = KeyboardUtils();

  @override
  void initState() {
    super.initState();

    _inicializarListenerTeclado();
  }

  @override
  void dispose() {
    _keyboardUtils.dispose();
    super.dispose();
  }

  void _inicializarListenerTeclado() {
    _keyboardUtils.add(
      listener: KeyboardListener(
        willHideKeyboard: () {
          setState(() {});
        },
        willShowKeyboard: (double keyboardHeight) {
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      KeyboardOptions(
          keyboardHeight: _keyboardUtils.keyboardHeight,
          isKeyboardOpen: _keyboardUtils.isKeyboardOpen),
    );
  }
}
