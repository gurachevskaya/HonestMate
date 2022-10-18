//
//  ProfileRoute.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 18.10.22.
//

import Foundation
import SwiftUI
import Resolver

enum ProfileRoute: NavigationRoute, Hashable {
    
    case profile
    case chooseGroup
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .profile:
            MyProfileView(
                viewModel: MyProfileViewModel(
                    authService: Resolver.resolve(),
                    appState: Resolver.resolve()
                )
            )
        case .chooseGroup:
            ChooseGroupView(
                viewModel: ChooseGroupViewModel(
                    groupsService: Resolver.resolve(),
                    authService: Resolver.resolve(),
                    appState: Resolver.resolve()
                )
            )
        }
    }
}
