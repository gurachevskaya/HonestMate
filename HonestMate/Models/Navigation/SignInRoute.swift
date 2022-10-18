//
//  SignInRoute.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 18.10.22.
//

import Foundation
import SwiftUI
import Resolver

enum SignInRoute: NavigationRoute, Hashable {
    
    case splash
    case signIn
    case chooseGroup
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .splash:
            SplashView(viewModel: SplashViewModel(
                remoteConfigService: Resolver.resolve(),
                appState: Resolver.resolve())
            )
        case .signIn:
            SignInView(
                viewModel: SignInViewModel(
                    authService: Resolver.resolve(),
                    remoteConfigService: Resolver.resolve()
                )
            )
        case .chooseGroup:
            ChooseGroupView(
                viewModel: ChooseGroupViewModel(
                    groupsService: Resolver.resolve(),
                    authService: Resolver.resolve(),
                    appState: Resolver.resolve())
            )
        }
    }
}
