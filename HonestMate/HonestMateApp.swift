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
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                SplashView(
                    viewModel: SplashViewModel(
                        remoteConfigService: Resolver.resolve(),
                        appState: Resolver.resolve()
                    )
                )
            }
            .onAppear {
                UIApplication.shared.addTapGestureRecognizer()
            }
        }
    }
}
