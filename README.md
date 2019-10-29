# keyboard_utils

A Flutter plugin for check the keyboard visibility and size.

![sample](https://i.imgur.com/OgictdS.gif)

## Install

Follow this [guide](https://pub.dev/packages/keyboard_utils/#-installing-tab-) 

## How to use

Add the imports:
```dart
import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:keyboard_utils/keyboard_listener.dart';
```
Create the KeyboardUtils:
```dart
KeyboardUtils  _keyboardUtils = KeyboardUtils();
```

Attach the listener to KeyboardUtils:

```dart
_keyboardUtils.add(listener: KeyboardListener(
        willHideKeyboard: () {
          _streamController.sink.add(_keyboardUtils.keyboardHeight);
        },
        willShowKeyboard: (double keyboardHeight) {
          _streamController.sink.add(keyboardHeight);
        }
    ));
```

Check the sample for more details.

## Authors

<table>
  <tr>
    <td align="center"><a href="https://github.com/IsaiasSantana"><img src="https://avatars3.githubusercontent.com/u/18197600?s=460&v=4" width="100px;" alt="Isaías Santana"/><br /><sub><b>Isaías Santana</b></td>
 
   <td align="center"><a href="https://github.com/wilfilho"><img src="https://avatars2.githubusercontent.com/u/4473670?s=400&v=4" width="100px;" alt="Will Filho"/><br /><sub><b>Will Filho</b></td>
  </tr>
</table>
