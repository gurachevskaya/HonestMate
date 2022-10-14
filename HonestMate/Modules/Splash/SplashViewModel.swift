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
    @Published var showGroupsScreen: Bool = false
    @Published var showLoginFlow: Bool = false

    private func setupPipeline() {
        appState.objectWillChange
            .sink { [unowned self] _ in
                showMainFlow = appState.isLoggedIn && !isLoading && !appState.groupID.isEmpty
                showGroupsScreen = appState.isLoggedIn && !isLoading && appState.groupID.isEmpty
                showLoginFlow = !appState.isLoggedIn && !isLoading
            }
            .store(in: &cancellables)

        $isLoading
            .map { [unowned self] in
                $0 == false && appState.isLoggedIn && !appState.groupID.isEmpty
            }
            .assign(to: \.showMainFlow, on: self)
            .store(in: &cancellables)
        
        $isLoading
            .map { [unowned self] in
                $0 == false && appState.isLoggedIn && appState.groupID.isEmpty
            }
            .assign(to: \.showGroupsScreen, on: self)
            .store(in: &cancellables)

        $isLoading
            .map { [unowned self] in
                $0 == false && !appState.isLoggedIn
            }
            .assign(to: \.showLoginFlow, on: self)
            .store(in: &cancellables)
    }
    
    func loadConfig() {
        remoteConfigService.appConfigPublisher
            .sink(receiveCompletion: { [unowned self] _ in
                isLoading = false
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}
