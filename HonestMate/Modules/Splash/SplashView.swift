//
//  SplashView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 9.09.22.
//

import SwiftUI
import Resolver

struct SplashView: View {
    
    @ObservedObject var viewModel: SplashViewModel
    @State var showMainFlow: Bool = false
    @State var showLoginFlow: Bool = false
    
    var body: some View {
        ZStack {
            Text("honestmate")
                .onAppear {
                    viewModel.loadConfig()
                }
                .fullScreenCover(
                    isPresented: $viewModel.showLoginFlow,
                    content: {
                        SignInView(
                            viewModel: SignInViewModel(
                                authService: Resolver.resolve(),
                                remoteConfigService: Resolver.resolve()
                            )
                        )
                    }
                )
                .fullScreenCover(
                    isPresented: $viewModel.showMainFlow,
                    content: {
                        HonestMateTabView()
                    }
                )
                .fullScreenCover(
                    isPresented: $viewModel.showGroupsScreen,
                    content: {
                       ChooseGroupView(
                            viewModel: ChooseGroupViewModel(
                                groupsService: Resolver.resolve(),
                                authService: Resolver.resolve(),
                                appState: Resolver.resolve()
                            )
                        )
                    }
                )
        }
        .onChange(of: viewModel.showLoginFlow) { newValue in
            showLoginFlow = newValue
        }
        .onChange(of: viewModel.showMainFlow) { newValue in
            showMainFlow = newValue
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(viewModel: SplashViewModel(
            remoteConfigService: Resolver.resolve(),
            appState: Resolver.resolve())
        )
    }
}
