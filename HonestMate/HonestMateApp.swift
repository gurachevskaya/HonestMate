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
        
    @State private var appState = AppState()
    @State private var isLoggedIn = false
    
    init() {
        FirebaseApp.configure()
        
        appState.startObservingAuthChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoggedIn {
                    MyEventsView(viewModel: MyEventsViewModel(authService: Resolver.resolve(), isShowingMyEvents: .constant(true)))
                } else {
                    SignInView(viewModel: SignInViewModel(authService: Resolver.resolve()))
                }
            }
            .onReceive(appState.$isLoggedIn) { newValue in
                isLoggedIn = newValue
            }
        }
    }
}

class AppState: ObservableObject {
    @Published private(set) var isLoggedIn = false
    
    private let authService: AuthServiceProtocol
    
    func startObservingAuthChanges() {
        authService
            .observeAuthChanges()
            .assign(to: &$isLoggedIn)
    }
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
}
