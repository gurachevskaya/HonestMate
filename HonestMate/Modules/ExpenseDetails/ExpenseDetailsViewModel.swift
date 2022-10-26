//
//  ExpenseDetailsViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 25.10.22.
//

import SwiftUI

class ExpenseDetailsViewModel: ObservableObject {
    
    var expense: ExpenseModel
    var remoteConfig: RemoteConfigServiceProtocol
    
    init(
        expense: ExpenseModel,
        remoteConfig: RemoteConfigServiceProtocol
    ) {
        self.expense = expense
        self.remoteConfig = remoteConfig
    }
    
    var title: String {
        switch expense.expenseType {
        case .directPayment:
            return R.string.localizable.expenseDetailsDirectPaymentTitle()
        case .newExpense:
            return expense.description ?? (expense.category?.name ?? "")
        }
    }
    
    var headerColor: Color {
        switch expense.expenseType {
        case .directPayment:
            return Color(hex: remoteConfig.appConfig?.accentColor ?? "").opacity(0.5)

        case .newExpense:
            return Color(hex: expense.category?.hexColor ?? "")
        }
    }
}
