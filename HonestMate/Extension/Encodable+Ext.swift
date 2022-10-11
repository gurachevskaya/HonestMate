//
//  Encodable+Ext.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 10.10.22.
//

import Foundation

extension Encodable {
    var toDictionnary: [String : Any]? {
        guard let data =  try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}
