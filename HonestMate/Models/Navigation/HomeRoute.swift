//
//  HomeRouter.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 18.10.22.
//

import SwiftUI
import Resolver

enum HomeRoute: NavigationRoute, Hashable {
        
    case home
    case selectType
    case reselectType(Binding<ExpenseCategory?>)
    case newExpense(ExpenseCategory)
    case directPayment
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home:
            MyEventsView(
                viewModel: MyEventsViewModel(
                    navigationState: Resolver.resolve(),
                    expensesService: Resolver.resolve(),
                    authService: Resolver.resolve(),
                    appState: Resolver.resolve()
                )
            )
        case .selectType:
            SelectExpenseTypeView(
                viewModel: SelectExpenseTypeViewModel(
                    type: .select,
                    expenseCategory: nil,
                    expensesService: Resolver.resolve()
                )
            )
        case .reselectType(let expenseCategory):
            SelectExpenseTypeView(
                viewModel: SelectExpenseTypeViewModel(
                    type: .reselect,
                    expenseCategory: expenseCategory,
                    expensesService: Resolver.resolve()
                )
            )
        case .newExpense(let expenseCategory):
            NewExpenseView(
                viewModel: NewExpenseViewModel(
                    expenseCategory: expenseCategory,
                    expenseType: .newExpense,
                    authService: Resolver.resolve(),
                    expensesService: Resolver.resolve(),
                    appState: Resolver.resolve(),
                    navigationState: Resolver.resolve()
                )
            )
        case .directPayment:
            NewExpenseView(
                viewModel: NewExpenseViewModel(
                    expenseCategory: nil,
                    expenseType: .directPayment,
                    authService: Resolver.resolve(),
                    expensesService: Resolver.resolve(),
                    appState: Resolver.resolve(),
                    navigationState: Resolver.resolve()
                )
            )
        }
    }
}
