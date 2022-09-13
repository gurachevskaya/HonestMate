//
//  MyEventsViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 5.09.22.
//

import Foundation
import Combine
import SwiftUI

class MyEventsViewModel: ObservableObject {
    
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
