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

    init(
        groupsService: GroupsServiceProtocol,
        authService: AuthServiceProtocol
    ) {
        self.groupsService = groupsService
        self.authService = authService
    }
    
    private var currentUserID: String? { authService.currentUser?.uid }
    
    @AppStorage(Constants.StorageKeys.groupID) var groupID = ""
    @Published var groups: [GroupModel] = []
    @Published var alertItem: AlertItem?
    
    private var cancellables: Set<AnyCancellable> = []
    
    func getUserGroups() {
        guard let currentUserID = currentUserID else {
            // TODO: map error
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
