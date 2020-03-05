# keyboard_utils

A Flutter plugin to check keyboard visibility and height.

[![Licence](https://img.shields.io/dub/l/vibe-d.svg?maxAge=2592000)](https://opensource.org/licenses/MIT)

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
final int _idKeyboardListener = _keyboardUtils.add(
        listener: KeyboardListener(willHideKeyboard: () {
      // Your code here
    }, willShowKeyboard: (double keyboardHeight) {
      // You code here
    }));
```

Remember call dispose:
```dart
_keyboardUtils.unsubscribeListener(subscribingId: _idKeyboardListener);
    if (_keyboardUtils.canCallDispose()) {
      _keyboardUtils.dispose();
    }
```

Instead, you can also use KeyboardAware Widget:

```dart
 import 'package:keyboard_utils/widgets.dart';
 
 ....
 
 Widget buildSampleUsingKeyboardAwareWidget() {
    return Center(
      child: Column(
        children: <Widget>[
          TextField(),
          TextField(
            keyboardType: TextInputType.number,
          ),
          TextField(),
          SizedBox(
            height: 30,
          ),
          KeyboardAware(
            builder: (context, keyboardConfig) {
              return Text('is keyboard open: ${keyboardConfig.isKeyboardOpen}\n'
                  'Height: ${keyboardConfig.keyboardHeight}');
            },
          ),
        ],
      ),
    );
  }
  
  ....
```

To share KeyboardConfig in your widget tree, use the **KeyboardConfigInheritedWidget** widget.

Check the sample for more details.

## Authors

<table>
  <tr>
    <td align="center"><a href="https://github.com/IsaiasSantana"><img src="https://avatars3.githubusercontent.com/u/18197600?s=460&v=4" width="100px;" alt="Isaías Santana"/><br /><sub><b>Isaías Santana</b></td>
 
   <td align="center"><a href="https://github.com/wilfilho"><img src="https://avatars2.githubusercontent.com/u/4473670?s=400&v=4" width="100px;" alt="Will Filho"/><br /><sub><b>Will Filho</b></td>
  </tr>
</table>
