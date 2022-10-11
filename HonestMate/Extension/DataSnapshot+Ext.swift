//
//  DataSnapshot+Ext.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 10.10.22.
//

import Foundation
import Firebase

extension DataSnapshot {
    var data: Data? {
        guard let value = value, !(value is NSNull) else { return nil }
        return try? JSONSerialization.data(withJSONObject: value)
    }
    var json: String? { data?.string }
}

extension Data {
    var string: String? { String(data: self, encoding: .utf8) }
    var json: Any? { try? JSONSerialization.jsonObject(with: self, options: []) }
}
