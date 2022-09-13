//
//  EnvironmentConstants.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 12.09.22.
//

import Foundation

enum EnvironmentConstants {
    static var isDebug: Bool {
#if DEBUG
        return true
#else
        return false
#endif
    }
}

