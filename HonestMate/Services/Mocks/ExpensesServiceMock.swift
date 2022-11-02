//
//  ExpensesServiceMock.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 28.10.22.
//

import Foundation
import Combine

class ExpensesServiceMock: ExpensesServiceProtocol {
    var history: [ExpenseModel] = []
    var shouldFail = false
    
    var getHistoryWasCalled = false
    var deleteItemWasCalled = false
    
    enum ExpenseServiceMockError: Error {
        case getHistoryFailed
        case deleteFailed
    }
    
    func reset() {
        history = []
        shouldFail = false
        getHistoryWasCalled = false
        deleteItemWasCalled = false
    }

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
        getHistoryWasCalled = true
        if !shouldFail {
            return Just(history)
                .delay(for: 2, scheduler: RunLoop.main)
                .setFailureType(to: ExpenseServiceError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: ExpenseServiceError.inner(ExpenseServiceMockError.getHistoryFailed))
                .delay(for: 2, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
    }
    
    func deleteExpense(id: String, groupID: String) -> AnyPublisher<Void, ExpenseServiceError> {
        deleteItemWasCalled = true
        if !shouldFail {
            return Just(())
                .delay(for: 2, scheduler: RunLoop.main)
                .setFailureType(to: ExpenseServiceError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: ExpenseServiceError.inner(ExpenseServiceMockError.deleteFailed))
                .delay(for: 2, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
    }
    
    func getBalances(groupID: String) -> AnyPublisher<[BalanceModel], ExpenseServiceError> {
        return Just([MockData.balanceModel])
            .delay(for: 2, scheduler: RunLoop.main)
            .setFailureType(to: ExpenseServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func editExpense(groupID: String, expense: ExpenseModel) -> AnyPublisher<Void, ExpenseServiceError> {
        return Just(())
            .delay(for: 2, scheduler: RunLoop.main)
            .setFailureType(to: ExpenseServiceError.self)
            .eraseToAnyPublisher()
    }
    
}
