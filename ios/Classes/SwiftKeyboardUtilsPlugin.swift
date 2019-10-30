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
    private var previewsKeyboardHeight = 0.0

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
            let keyboardOptions = KeyboardOptions(isKeyboardOpen: true,
                                                  keyboardHeight: previewsKeyboardHeight)

            if let jsonString = convertToJson(keyboardOptions: keyboardOptions) {
                eventSink?(jsonString)
            }
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
                                               selector: #selector(keyboardDidShow),
                                               name: NSNotification.Name.UIKeyboardDidShow,
                                               object: nil)
    }

    private func convertToJson(keyboardOptions: KeyboardOptions) -> String? {
       if let encodedData = try? JSONEncoder().encode(keyboardOptions),
            let jsonString = String(data: encodedData, encoding: .utf8) {
            return jsonString
        }
        return nil
    }

    @objc private func checkIsKeyboardOpen(notification: Notification) {
        func keyboardHeight() -> Double? {
            if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                return Double(keyboardRectangle.height)
            }
            return nil
        }

        if !isKeyboardOpen {
            isKeyboardOpen = true
            if let keyboardHeight = keyboardHeight() {
                let keyboardOptions = KeyboardOptions(isKeyboardOpen: true,
                                                      keyboardHeight: Double(keyboardHeight))

                previewsKeyboardHeight = keyboardHeight;
                if let jsonString = convertToJson(keyboardOptions: keyboardOptions) {
                    eventSink?(jsonString)
                }
            }
            return
        }

        if isKeyboardOpen, let keyboardHeight = keyboardHeight(){
            if previewsKeyboardHeight != keyboardHeight {
                let keyboardOptions = KeyboardOptions(isKeyboardOpen: true,
                                                      keyboardHeight: keyboardHeight)

                previewsKeyboardHeight = keyboardHeight;
                if let jsonString = convertToJson(keyboardOptions: keyboardOptions) {
                    eventSink?(jsonString)
                }
            }
        }
    }

    @objc private func keyboardDidShow(notification: Notification) {
        checkIsKeyboardOpen(notification: notification)
    }

    @objc private func keyboardWillShow(notification: Notification) {
       checkIsKeyboardOpen(notification: notification)
    }

    @objc private func keyboardWillHide() {
        if isKeyboardOpen {
            isKeyboardOpen = false
            let keyboardOptions = KeyboardOptions(isKeyboardOpen: false, keyboardHeight: 0.0)
            if let jsonString = convertToJson(keyboardOptions: keyboardOptions) {
               eventSink?(jsonString)
            }
        }
    }

    deinit {
        eventSink = nil
        NotificationCenter.default.removeObserver(self)
    }
}
