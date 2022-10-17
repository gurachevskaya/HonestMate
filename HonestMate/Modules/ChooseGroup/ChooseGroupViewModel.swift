//
//  ChooseGroupViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 13.10.22.
//

import Foundation
import Combine
import SwiftUI

class ChooseGroupViewModel: ObservableObject {
    
    private var groupsService: GroupsServiceProtocol?
    private var authService: AuthServiceProtocol
    private var appState: AppStateProtocol
    
    init(
        groupsService: GroupsServiceProtocol,
        authService: AuthServiceProtocol,
        appState: AppStateProtocol
    ) {
        self.groupsService = groupsService
        self.authService = authService
        self.appState = appState
    }
    
    private var currentUserID: String? { authService.currentUser?.uid }
    
    @Published var groups: [GroupModel] = []
    @Published var alertItem: AlertItem?
    @AppStorage(Constants.StorageKeys.groupID) private var groupID = ""

    private var cancellables: Set<AnyCancellable> = []
    
    func chooseGroup(group: GroupModel) {
        appState.groupID = group.id ?? ""
    }
    
    func getUserGroups() {
        guard let currentUserID = currentUserID else {
            // TODO: map error
            authService.logout()
                .sink { _ in } receiveValue: { _ in }
                .store(in: &cancellables)

            alertItem = AlertContext.innerError
            return
        }
        groupsService?.getUserGroups(userID: currentUserID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] subscription in
                switch subscription {
                case .finished: break
                case .failure(let error):
                    // TODO: map error
                    self?.alertItem = AlertContext.innerError
                }
            }, receiveValue: { [weak self] model in
                self?.groups = model
            })
            .store(in: &cancellables)
    }
}
