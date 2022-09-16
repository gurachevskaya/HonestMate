//
//  NewExpenseViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 16.09.22.
//

import Foundation

class NewExpenseViewModel: ObservableObject {
    
    var expenseType: ExpenseType
    var authService: AuthServiceProtocol
    
    init(
        expenseType: ExpenseType,
        authService: AuthServiceProtocol
    ) {
        self.expenseType = expenseType
        self.authService = authService
    }
    
    @Published var description: String = ""
    
    var currentUserName: String { authService.currentUser?.displayName ?? "name"}
    
}
