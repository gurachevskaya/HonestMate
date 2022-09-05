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
    
    init(authService: AuthServiceProtocol, isShowingMyEvents: Binding<Bool>) {
        self.authService = authService
        self.isShowingMyEvents = isShowingMyEvents
    }
    
    private var isShowingMyEvents: Binding<Bool>
    private var authService: AuthServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []

    func logout() {
        authService.logout()
            .sink { [unowned self] completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    isShowingMyEvents.wrappedValue = false
                }
            } receiveValue: { _ in
            }
            .store(in: &cancellables)

    }
}
