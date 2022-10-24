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
    
    init(
        navigationState: NavigationStateProtocol,
        expensesService: ExpensesServiceProtocol
    ) {
        self.navigationState = navigationState
        self.expensesService = expensesService
        
        setupPipeline()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var myBalance: Double = 0
    @Published var balances: [UserName: Double] = [:] {
        willSet {
            print(newValue)
        }
    }
    
    @Published var myBalanceViewColor: Color = .primary

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
        expensesService.getBalances(groupID: MockData.currentGroupID)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [:])
            .weakAssign(to: \.balances, on: self)
            .store(in: &cancellables)
        
        expensesService.getBalances(groupID: MockData.currentGroupID)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [:])
            .map { balances in
                let myBalance = balances.first(where: { $0.key == "Arina" })
                return myBalance?.value ?? 0
            }
            .weakAssign(to: \.myBalance, on: self)
            .store(in: &cancellables)
    }
}
