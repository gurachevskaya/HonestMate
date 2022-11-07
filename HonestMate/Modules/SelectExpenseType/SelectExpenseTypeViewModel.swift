//
//  SelectExpenseTypeViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import Foundation
import Combine
import SwiftUI

class SelectExpenseTypeViewModel: ObservableObject {
    
    var type: ScreenType
    var expenseCategory: Binding<ExpenseCategory?>?
    private var expensesService: ExpensesServiceProtocol
    private var remoteConfig: RemoteConfigServiceProtocol

    init(
        type: ScreenType,
        expenseCategory: Binding<ExpenseCategory?>?,
        expensesService: ExpensesServiceProtocol,
        remoteConfig: RemoteConfigServiceProtocol
    ) {
        self.type = type
        self.expenseCategory = expenseCategory
        self.expensesService = expensesService
        self.remoteConfig = remoteConfig
    }
    
    enum ScreenType {
        case select
        case reselect
    }
    
    enum State {
        case idle
        case loading
        case loaded([ExpenseCategory])
        case error(String)
    }
        
    @Published private(set) var state = State.idle
    
    var colourful: Bool { remoteConfig.appConfig?.colourful ?? true }

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private var cancellables: Set<AnyCancellable> = []
    
    func getExpenseCategories() {
        state = .loading
        
        expensesService.getDefaultCategories()
            .receive(on: DispatchQueue.main)
            .map { categories in
                categories.filter { $0.isActive }
            }
            .map { model in
                State.loaded(model)
            }
            .catch { error in
                // TODO: map error
                Just(State.error(error.localizedDescription))
            }
            .assign(to: &$state)
    }
}
