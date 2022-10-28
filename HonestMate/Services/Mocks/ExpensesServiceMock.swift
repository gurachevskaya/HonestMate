//
//  ExpensesServiceMock.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 28.10.22.
//

import Foundation
import Combine

class ExpensesServiceMock: ExpensesServiceProtocol {
    func createExpense(groupID: String, expense: ExpenseModel) -> AnyPublisher<Void, ExpenseServiceError> {
        return Just(())
            .delay(for: 2, scheduler: RunLoop.main)
            .setFailureType(to: ExpenseServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func getDefaultCategories() -> AnyPublisher<[ExpenseCategory], ExpenseServiceError> {
        return Just([MockData.expenseType])
            .delay(for: 2, scheduler: RunLoop.main)
            .setFailureType(to: ExpenseServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func getGroupMembers(groupID: String) -> AnyPublisher<[MemberModel], ExpenseServiceError> {
        return Just(MockData.members)
            .delay(for: 2, scheduler: RunLoop.main)
            .setFailureType(to: ExpenseServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func addListenerToExpenses(groupID: String) -> AnyPublisher<[ExpenseModel], ExpenseServiceError> {
        return Just([MockData.historyItem])
            .delay(for: 2, scheduler: RunLoop.main)
            .setFailureType(to: ExpenseServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func deleteExpense(id: String, groupID: String) -> AnyPublisher<Void, ExpenseServiceError> {
        return Just(())
            .delay(for: 2, scheduler: RunLoop.main)
            .setFailureType(to: ExpenseServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func getBalances(groupID: String) -> AnyPublisher<[BalanceModel], ExpenseServiceError> {
        return Just([MockData.balanceModel])
            .delay(for: 2, scheduler: RunLoop.main)
            .setFailureType(to: ExpenseServiceError.self)
            .eraseToAnyPublisher()
    }
}
