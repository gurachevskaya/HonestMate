//
//  NewExpenseViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 16.09.22.
//

import Foundation
import SwiftUI

class NewExpenseViewModel: ObservableObject {
    
    @Published var expenseType: ExpenseType
    var authService: AuthServiceProtocol
    
    init(
        expenseType: ExpenseType,
        authService: AuthServiceProtocol
    ) {
        self.expenseType = expenseType
        self.authService = authService
    }
    
    @Published var description: String = ""
    @Published var amount = 0
    @Published var selectedDate = Date()
    @Published var recievers: [Member] = []

    var currentUserName: String { authService.currentUser?.displayName ?? "name"}
    
}
