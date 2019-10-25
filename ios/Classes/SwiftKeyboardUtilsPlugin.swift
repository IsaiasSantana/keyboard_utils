import Flutter
import UIKit

public class SwiftKeyboardUtilsPlugin: NSObject, FlutterPlugin ,FlutterStreamHandler {
    
    private var eventSink: FlutterEventSink?
    private var isKeyboardOpen = false
    private var isListening = false
    
    public override init() {
        super.init()
        
        registerEvents()
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let eventChannel = FlutterEventChannel(name: "keyboard_utils", binaryMessenger: registrar.messenger())
        let instance = SwiftKeyboardUtilsPlugin()
        eventChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        result("iOS " + UIDevice.current.systemVersion)
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events;
        isListening = true
        
        if isKeyboardOpen {
            events(true)
        }

        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        isListening = false
        return nil
    }

    private func registerEvents() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardDidShow),
                                               name: NSNotification.Name.UIKeyboardDidShow,
                                               object: nil)
    }
    
    private func unregisterEvenst() {
        guard eventSink != nil else {
            return
        }
        
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func checkIsKeyboardOpen() {
        if !isKeyboardOpen {
            isKeyboardOpen = true
            eventSink?(true)
        }
    }

    @objc private func keyBoardDidShow() {
        checkIsKeyboardOpen()
    }

    @objc private func keyboardWillShow() {
       checkIsKeyboardOpen()
    }
    
    @objc private func keyboardWillHide() {
        if isKeyboardOpen {
            isKeyboardOpen = false
            eventSink?(false)
        }
    }
}
