//
//  MyProfileViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import Foundation
import Combine

class MyProfileViewModel: ObservableObject {
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    private var authService: AuthServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []

    func logout() {
        authService.logout()
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}
