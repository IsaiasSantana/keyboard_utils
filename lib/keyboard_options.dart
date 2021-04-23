class KeyboardOptions {
  KeyboardOptions({required this.isKeyboardOpen, required this.keyboardHeight});

  final bool isKeyboardOpen;
  final double keyboardHeight;

  KeyboardOptions.fromJson(Map<String, dynamic> json)
      : isKeyboardOpen = json['isKeyboardOpen'],
        keyboardHeight = json['keyboardHeight'].toDouble();

  Map<String, dynamic> toJson() {
    return {
      'isKeyboardOpen': isKeyboardOpen,
      'keyboardHeight': keyboardHeight,
    };
  }
}
