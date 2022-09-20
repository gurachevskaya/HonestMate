//
//  Binding+Ext.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 20.09.22.
//

import Foundation
import SwiftUI

extension Binding: Equatable where Value: Equatable {
    public static func == (lhs: Binding<Value>, rhs: Binding<Value>) -> Bool {
        return lhs.wrappedValue == rhs.wrappedValue
    }
}

extension Binding: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.wrappedValue.hash(into: &hasher)
    }
}
