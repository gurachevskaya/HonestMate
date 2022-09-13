//
//  AppState.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 8.09.22.
//

import SwiftUI
import Combine

protocol AnyObservableObject: AnyObject {
    var objectWillChange: ObservableObjectPublisher { get }
}

protocol AppStateProtocol: AnyObservableObject {
    var isLoggedIn: Bool { get }
}

class AppState: AppStateProtocol, ObservableObject {
    @AppStorage(Constants.StorageKeys.isLoggedIn) var isLoggedIn = true
}
