//
//  ExpensesService.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 7.10.22.
//

import Foundation
import Combine
import Firebase

enum ExpenseServiceError: LocalizedError {
    case inner
}

protocol ExpensesServiceProtocol {
    func createExpense(expense: ExpenseModel) -> AnyPublisher<Void, ExpenseServiceError>
    func getDefaultCategories() -> AnyPublisher<[ExpenseCategory], ExpenseServiceError>
//    func addListenerToExpenses(completion: @escaping (Result<[ExpenseModel],Error>) -> Void)
}

final class ExpensesService: ExpensesServiceProtocol {
    let ref: DatabaseReference
    
    init(ref: DatabaseReference) {
        self.ref = ref
    }
    
    func createExpense(expense: ExpenseModel) -> AnyPublisher<Void, ExpenseServiceError> {
        let groupsRef = ref.child(Constants.DatabaseReferenceNames.groups)
        let currentGroupRef = groupsRef.child("1")
        let historyRef = currentGroupRef.child(Constants.DatabaseReferenceNames.expensesHistory)
        let uuidRef = historyRef.child(UUID().uuidString)
        
        let expenseJson: Any? = try? JSONEncoder().encode(expense).json
     
        return Future<Void, ExpenseServiceError> { promise in
            uuidRef.setValue(expenseJson) { error, _ in
                if let error = error {
                    print(error)
                    promise(.failure(.inner))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getDefaultCategories() -> AnyPublisher<[ExpenseCategory], ExpenseServiceError> {
        let categoriesRef = ref.child(Constants.DatabaseReferenceNames.categories)
      
        return Future<[ExpenseCategory], ExpenseServiceError> { promise in
            categoriesRef.observeSingleEvent(of: .value) { snapshot in
                guard let data = snapshot.value as? [String] else {
                    preconditionFailure("Check type in Firebase")
                }
                let categories = data.map {
                    ExpenseCategory(
                        id: UUID().uuidString,
                        name: $0
                    )
                }
                promise(.success(categories))
            }
        }
        .eraseToAnyPublisher()
    }
    
//    func getGroupMembers(amount: Double, paidByUserID: String, password: String) -> AnyPublisher<Void, ExpenseServiceError> {
//
//    }
    
    
//    func addListenerToExpenses(completion: @escaping (Result<[ExpenseModel],Error>) -> Void) {
//        let groupsRef = ref.child("groups")
//        let currentGroupRef = groupsRef.child("1")
//        let historyRef = currentGroupRef.child("expensesHistory")
//
//        groupsRef.observe(.value) { snapshot, someString  in
//            guard
//                let data = snapshot.value as? [String: Any]
//            else {
//                preconditionFailure("Check type in Firebase")
//            }
//
//            let expenses = data.values.compactMap {
//                try? JSONDecoder().decode([ExpenseModel].self, from: $0 as! Data)
//            }
//
//            print(expenses)
//
//            //            let history: [ExpenseModel] = data.map { model in
//            //                completion(.success(model))
//            //            }
//        }
//    }
}
