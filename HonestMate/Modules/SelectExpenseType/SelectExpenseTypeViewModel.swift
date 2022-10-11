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
    
    enum ScreenType {
        case select
        case reselect
    }
        
    @Published var expenseTypes: [ExpenseCategory] = []
    @Published var alertItem: AlertItem?
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
       
    var type: ScreenType
    var expenseType: Binding<ExpenseCategory>?
    private var expensesService: ExpensesServiceProtocol

    init(
        type: ScreenType,
        expenseType: Binding<ExpenseCategory>?,
        expensesService: ExpensesServiceProtocol
    ) {
        self.type = type
        self.expenseType = expenseType
        self.expensesService = expensesService
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    func getExpenseCategories() {
        expensesService.getDefaultCategories()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] subscription in
                switch subscription {
                case .finished: break
                case .failure(let error):
                    // TODO: map error
                    self?.alertItem = AlertContext.innerError
                }
            } receiveValue: { [weak self] expenses in
                self?.expenseTypes = expenses
            }
            .store(in: &cancellables)
    }
}
