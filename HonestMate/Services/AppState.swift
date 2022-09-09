//
//  AppState.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 8.09.22.
//

import SwiftUI

class AppState: ObservableObject {
    @AppStorage(Constants.Keys.isLoggedIn) var isLoggedIn = true
}
