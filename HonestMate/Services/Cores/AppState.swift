//
//  AppState.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 8.09.22.
//

import SwiftUI

protocol AppStateProtocol: AnyObservableObject, Clearable {
    var isLoggedIn: Bool { get set }
    var groupID: String { get set }
}

class AppState: AppStateProtocol, ObservableObject {
    @AppStorage(Constants.StorageKeys.isLoggedIn) var isLoggedIn = true
    @AppStorage(Constants.StorageKeys.groupID) var groupID = ""

    func clear() {
        isLoggedIn = false
        groupID = ""
    }
}
