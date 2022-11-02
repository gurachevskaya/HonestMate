//
//  NavigationState.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 31.10.22.
//

import Foundation
import Combine
import SwiftUI

class NavigationStateMock: NavigationStateProtocol, ObservableObject {
    var homePath: NavigationPath = NavigationPath()
    var historyPath: NavigationPath = NavigationPath()
    
    func clear() {
        homePath = NavigationPath()
        historyPath =  NavigationPath()
    }
}
