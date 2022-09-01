//
//  HonestMateApp.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 26.08.22.
//

import SwiftUI

@main
struct HonestMateApp: App {
    var body: some Scene {
        WindowGroup {
            SignInView(viewModel: SignInViewModel())
        }
    }
}
