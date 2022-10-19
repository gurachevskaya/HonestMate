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
    case reselectType(Binding<ExpenseCategory>)
    case newExpense(ExpenseCategory)
    case directPayment
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home:
            MyEventsView(
                viewModel: MyEventsViewModel(
                    navigationState: Resolver.resolve()
                )
            )
        case .selectType:
            SelectExpenseTypeView(
                viewModel: SelectExpenseTypeViewModel(
                    type: .select,
                    expenseType: nil,
                    expensesService: Resolver.resolve()
                )
            )
        case .reselectType(let expenseType):
            SelectExpenseTypeView(
                viewModel: SelectExpenseTypeViewModel(
                    type: .reselect,
                    expenseType: expenseType,
                    expensesService: Resolver.resolve()
                )
            )
        case .newExpense(let expenseType):
            NewExpenseView(
                viewModel: NewExpenseViewModel(
                    expenseType: expenseType,
                    authService: Resolver.resolve(),
                    expensesService: Resolver.resolve(),
                    appState: Resolver.resolve(),
                    navigationState: Resolver.resolve()
                )
            )
        case .directPayment:
            DirectPaymentView(
                viewModel: DirectPaymentViewModel()
            )
        }
    }
}
