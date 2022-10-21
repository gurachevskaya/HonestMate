//
//  MyProfileViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import Foundation
import Combine

class MyProfileViewModel: ObservableObject {
    
    init(
        authService: AuthServiceProtocol,
        appState: AppStateProtocol
    ) {
        self.authService = authService
        self.appState = appState
        
        setupPipeline()
    }
    
    private var authService: AuthServiceProtocol
    private var appState: AppStateProtocol
    
    @Published var shouldShowChooseGroup = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    private func setupPipeline() {
        appState.objectWillChange
            .sink { [weak self] _ in
                self?.shouldShowChooseGroup = false
            }
            .store(in: &cancellables)
    }

    func logout() {
        authService.logout()
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}
