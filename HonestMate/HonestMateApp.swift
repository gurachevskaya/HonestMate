//
//  HonestMateApp.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 26.08.22.
//

import SwiftUI
import Firebase

@main
struct HonestMateApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SignInView(viewModel: SignInViewModel())
        }
    }
}
