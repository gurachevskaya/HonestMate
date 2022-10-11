//
//  ExpensesService.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 7.10.22.
//

import Foundation
import Combine
import FirebaseFirestore

enum ExpenseServiceError: LocalizedError {
    case inner
    case decodingError
    case noData
}

protocol ExpensesServiceProtocol {
    func createExpense(groupID: String, expense: ExpenseModel) -> AnyPublisher<Void, ExpenseServiceError>
    func getDefaultCategories() -> AnyPublisher<[ExpenseCategory], ExpenseServiceError>
    func getGroupMembers(groupID: String) -> AnyPublisher<[Member], ExpenseServiceError>
//    func addListenerToExpenses(completion: @escaping (Result<[ExpenseModel],Error>) -> Void)
}

final class ExpensesService: ExpensesServiceProtocol {
    let db: Firestore
    
    init(db: Firestore) {
        self.db = db
    }
    
    func createExpense(groupID: String, expense: ExpenseModel) -> AnyPublisher<Void, ExpenseServiceError> {
        let groupsRef = db.collection(Constants.DatabaseReferenceNames.groups)
        let currentGroupRef = groupsRef.document(groupID)
        let historyRef = currentGroupRef.collection(Constants.DatabaseReferenceNames.expensesHistory)
             
        return Future<Void, ExpenseServiceError> { promise in
            do {
                let _ = try historyRef.addDocument(from: expense)
                promise(.success(()))
            } catch let error {
                promise(.failure(.inner))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getDefaultCategories() -> AnyPublisher<[ExpenseCategory], ExpenseServiceError> {
        let categoriesRef = db.collection(Constants.DatabaseReferenceNames.categories)
      
        return Future<[ExpenseCategory], ExpenseServiceError> { promise in
            categoriesRef.addSnapshotListener { snapshot, error in
                if let error = error {
                    promise(.failure(.inner))
                }
                
                guard let data = snapshot?.documents else {
                    promise(.failure(.noData))
                    return
                }
                
                let categories = data.compactMap {
                    try? $0.data(as: ExpenseCategory.self)
                }
                
                promise(.success(categories))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getGroupMembers(groupID: String) -> AnyPublisher<[Member], ExpenseServiceError> {
        let groupsRef = db.collection(Constants.DatabaseReferenceNames.groups)
        let currentGroup = groupsRef.document(groupID)
        let groupMembersRef = currentGroup.collection(Constants.DatabaseReferenceNames.members)
        
        return Future<[Member], ExpenseServiceError> { promise in
            groupMembersRef.getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(.inner))
                }

                guard let data = snapshot?.documents else {
                    promise(.failure(.noData))
                    return
                }

                let members = data.compactMap {
                    try? $0.data(as: Member.self)
                }

                promise(.success(members))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    
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
