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
    
    @Published var navigationState: NavigationStateProtocol
    private var expensesService: ExpensesServiceProtocol
    private var authService: AuthServiceProtocol
    private var appState: AppStateProtocol
    private var remoteConfig: RemoteConfigServiceProtocol
    private var groupsService: GroupsServiceProtocol
    
    init(
        navigationState: NavigationStateProtocol,
        expensesService: ExpensesServiceProtocol,
        authService: AuthServiceProtocol,
        appState: AppStateProtocol,
        remoteConfig: RemoteConfigServiceProtocol,
        groupsService: GroupsServiceProtocol
    ) {
        self.navigationState = navigationState
        self.expensesService = expensesService
        self.authService = authService
        self.appState = appState
        self.remoteConfig = remoteConfig
        self.groupsService = groupsService
        
        setupPipeline()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var myBalance: Double = 0
    @Published var balances: [BalanceModel] = []
    @Published var myBalanceViewColor: Color = .primary
    
    var accentColor: Color {
        remoteConfig.appConfig?.colourful == true ?
        Color(hex: remoteConfig.appConfig?.accentColor ?? "") : Color(uiColor: .systemBlue)
    }

    private func setupPipeline() {
        navigationState.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        .store(in: &cancellables)
        
        configureMyBalanceBehavior()
    }
    
    private func configureMyBalanceBehavior() {
        $myBalance
            .map { balance -> Color in
                balance >= 0 ? R.color.customGreen.color : R.color.customRed.color
            }
            .eraseToAnyPublisher()
            .assign(to: &$myBalanceViewColor)
    }

    func getBalances() {
        expensesService.getBalances(groupID: appState.groupID)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .weakAssign(to: \.balances, on: self)
            .store(in: &cancellables)
        
        expensesService.getBalances(groupID: appState.groupID)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .map { balances in
                let myBalance = balances.first(where: { $0.member.id == self.authService.currentUser?.uid })
                return myBalance?.balance ?? 0
            }
            .weakAssign(to: \.myBalance, on: self)
            .store(in: &cancellables)
    }
}
