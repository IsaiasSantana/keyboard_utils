/// The responsability this class is to handle the subscribing events.
class KeyboardListener {
  /// Constructs a new [KeyboardListener]
  KeyboardListener({this.willShowKeyboard, this.willHideKeyboard});

  /// It is called when the keyboard appears.
  final Function(double)? willShowKeyboard;

  /// It is called when the keyboard disappears.
  final Function? willHideKeyboard;
}
