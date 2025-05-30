//
//  SplashViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 9.09.22.
//

import Foundation
import Combine
import SwiftUI
import Resolver


class SplashViewModel: ObservableObject {
    
    private var remoteConfigService: RemoteConfigServiceProtocol
    private var appState: AppStateProtocol

    init(remoteConfigService: RemoteConfigServiceProtocol, appState: AppStateProtocol) {
        self.remoteConfigService = remoteConfigService
        self.appState = appState
        
        setupPipeline()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published private(set) var isLoading: Bool = true
    @Published var showMainFlow: Bool = false
    @Published var showLoginFlow: Bool = false

    private func setupPipeline() {
        appState.objectWillChange
            .sink { [unowned self] _ in
                if !isLoading {
                    showMainFlow = appState.isLoggedIn && !appState.groupID.isEmpty
                    showLoginFlow = !appState.isLoggedIn || appState.groupID.isEmpty
                }
            }
            .store(in: &cancellables)

        $isLoading
            .map { [unowned self] in
                $0 == false && appState.isLoggedIn && !appState.groupID.isEmpty
            }
            .assign(to: &$showMainFlow)
        
        $isLoading
            .map { [unowned self] in
                ($0 == false && !appState.isLoggedIn) || ($0 == false && appState.groupID.isEmpty)
            }
            .assign(to: &$showLoginFlow)
    }
    
    func loadConfig() {
        remoteConfigService.appConfigPublisher
            .map { false }
            .assign(to: &$isLoading)
    }
}
