#import "KeyboardUtilsPlugin.h"
#import <keyboard_utils/keyboard_utils-Swift.h>

@implementation KeyboardUtilsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftKeyboardUtilsPlugin registerWithRegistrar:registrar];
}
@end
