//
//  HonestMateApp.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 26.08.22.
//

import SwiftUI
import Firebase
import Resolver

@main
struct HonestMateApp: App {
    
    @ObservedObject private var appState = AppState()

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if appState.isLoggedIn {
                    MyEventsView(viewModel: MyEventsViewModel(authService: Resolver.resolve()))
                } else {
                    SignInView(viewModel: SignInViewModel(authService: Resolver.resolve()))
                }
            }
        }
    }
}
