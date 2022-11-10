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
    
    private var groupsService: GroupsServiceProtocol
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
    
    private var currentUserID: String? { authService.currentUserID }
    
    @Published var groups: [GroupModel] = []
    @Published var alertItem: AlertItem?
    @AppStorage(Constants.StorageKeys.groupID) private var groupID = ""
    
    private var cancellables: Set<AnyCancellable> = []
    
    func chooseGroup(group: GroupModel) {
        appState.groupID = group.id ?? ""
    }
    
    func getUserGroups() {
        guard let currentUserID = currentUserID else {
            authService.logout()
                .sink { _ in } receiveValue: { _ in }
                .store(in: &cancellables)
            
            alertItem = AlertContext.innerError
            return
        }
        
        let userInfoPublisher = groupsService.getUserInfo(userID: currentUserID)
        let groupsPublisher = groupsService.getGroups()
        
        userInfoPublisher.zip(groupsPublisher) { userInfo, groups in
            let filteredGroups = groups.filter { group in
                userInfo.groups.contains(group.id ?? "")
            }
            return filteredGroups
        }
        .receive(on: DispatchQueue.main)
        .catch { [weak self] _ in
            self?.alertItem = AlertContext.innerError
            return Just([GroupModel]())
        }
        .assign(to: &$groups)
    }
}
