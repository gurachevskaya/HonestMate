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

protocol AppStateProtocol: AnyObservableObject, Clearable {
    var isLoggedIn: Bool { get set }
    var groupID: String { get set }
    var homePath: [HomeRoute] { get set }
}

class AppState: AppStateProtocol, ObservableObject {
    @AppStorage(Constants.StorageKeys.isLoggedIn) var isLoggedIn = true
    @AppStorage(Constants.StorageKeys.groupID) var groupID = ""
    @Published var homePath: [HomeRoute] = []

    func clear() {
        isLoggedIn = false
        groupID = ""
    }
}
