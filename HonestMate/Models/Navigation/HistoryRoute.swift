//
//  HistoryRoute.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 18.10.22.
//

import Foundation
import SwiftUI
import Resolver

enum HistoryRoute: NavigationRoute, Hashable {
    
    case history
    case expenseDetails(ExpenseModel)
    case editExpense(Binding<ExpenseModel>)
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .expenseDetails(let expense):
            ExpenseDetailsView(
                viewModel: ExpenseDetailsViewModel(
                    expense: expense,
                    remoteConfig: Resolver.resolve()
                )
            )
            
        case .history:
            HistoryView(
                viewModel: HistoryViewModel(
                    expensesService: Resolver.resolve(),
                    appState: Resolver.resolve(),
                    groupsService: Resolver.resolve(),
                    remoteConfig: Resolver.resolve(),
                    navigationState: Resolver.resolve()
                )
            )
            
        case .editExpense(let expense):
            NewExpenseView(
                viewModel: NewExpenseViewModel(
                    expense: expense,
                    expenseCategory: expense.wrappedValue.category,
                    expenseType: .newExpense,
                    authService: Resolver.resolve(),
                    expensesService: Resolver.resolve(),
                    appState: Resolver.resolve(),
                    navigationState: Resolver.resolve()
                )
            )
        }
    }
}
