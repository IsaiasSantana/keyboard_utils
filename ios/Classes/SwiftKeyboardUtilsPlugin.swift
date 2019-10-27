import Flutter
import UIKit

//
//  SwiftKeyboardUtilsPlugin.swift
//  keyboard_utils
//
//  Created by Isaías Santana on 25/10/19.
//

public class SwiftKeyboardUtilsPlugin: NSObject, FlutterPlugin ,FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var isKeyboardOpen = false
    
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
        
        if isKeyboardOpen {
            events(true)
        }

        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
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
    
    private func convertKeyboardOptionsToString(_ keyboardOptions: KeyboardOptions) -> String? {
       if let encodedData = try? JSONEncoder().encode(keyboardOptions),
            let jsonString = String(data: encodedData, encoding: .utf8) {
            return jsonString
        }
        
        return nil
    }

    @objc private func checkIsKeyboardOpen(notification: Notification) {
        if !isKeyboardOpen {
            isKeyboardOpen = true
            if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                let keyboardOptions = KeyboardOptions(isKeyboardOpen: true, keyboardHeight: Double(keyboardHeight))
                if let jsonString = convertKeyboardOptionsToString(keyboardOptions) {
                   eventSink?(jsonString)
                }
            }
        }
    }

    @objc private func keyBoardDidShow(notification: Notification) {
        checkIsKeyboardOpen(notification: notification)
    }

    @objc private func keyboardWillShow(notification: Notification) {
       checkIsKeyboardOpen(notification: notification)
    }

    @objc private func keyboardWillHide() {
        if isKeyboardOpen {
            isKeyboardOpen = false
            let keyboardOptions = KeyboardOptions(isKeyboardOpen: false, keyboardHeight: 0.0)
            if let jsonString = convertKeyboardOptionsToString(keyboardOptions) {
               eventSink?(jsonString)
            }
        }
    }
}
