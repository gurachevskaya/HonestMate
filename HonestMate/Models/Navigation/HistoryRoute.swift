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
                    groupsService: Resolver.resolve()
                )
            )
        }
    }
}
