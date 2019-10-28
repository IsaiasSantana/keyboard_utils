//
//  KeyboardOptions.swift
//  keyboard_utils
//
//  Created by Isaías Santana on 27/10/19.
//

import Foundation
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
