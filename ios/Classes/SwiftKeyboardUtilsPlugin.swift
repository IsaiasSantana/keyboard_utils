import Flutter
import UIKit

struct KeyboardOptions: Encodable {
    let isKeyboardOpen: Bool
    let keyboardHeight: Double
    
    enum CodingKeys: String, CodingKey {
        
        case isKeyboardOpen
        case keyboardHeight
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isKeyboardOpen, forKey: .isKeyboardOpen)
        try container.encode(keyboardHeight, forKey: .keyboardHeight)
    }
}

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
