//
//  NavigationState.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 18.10.22.
//


import SwiftUI

protocol NavigationStateProtocol: AnyObservableObject, Clearable {
    var homePath: NavigationPath { get set }
    var historyPath: NavigationPath { get set }
}

class NavigationState: NavigationStateProtocol, ObservableObject {
    @Published var homePath = NavigationPath()
    @Published var historyPath = NavigationPath()
    
    func clear() {
        homePath = NavigationPath()
        historyPath = NavigationPath()
    }
}
