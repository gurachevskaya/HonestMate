//
//  NavigationState.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 18.10.22.
//


import SwiftUI

protocol NavigationStateProtocol: AnyObservableObject {
    var homePath: [HomeRoute] { get set }
}

class NavigationState: NavigationStateProtocol, ObservableObject {
    @Published var homePath: [HomeRoute] = []
}
