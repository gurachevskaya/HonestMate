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
    case inner(Error)
}

protocol ExpensesServiceProtocol {
    func createExpense(groupID: String, expense: ExpenseModel) -> AnyPublisher<Void, ExpenseServiceError>
    func getDefaultCategories() -> AnyPublisher<[ExpenseCategory], ExpenseServiceError>
    func getGroupMembers(groupID: String) -> AnyPublisher<[Member], ExpenseServiceError>
    func addListenerToExpenses(groupID: String) -> AnyPublisher<[ExpenseModel], ExpenseServiceError>
    func deleteExpense(id: String, groupID: String) -> AnyPublisher<Void, ExpenseServiceError>
}

final class ExpensesService: ExpensesServiceProtocol {
    let db: Firestore
    
    init(db: Firestore) {
        self.db = db
    }
    
    func createExpense(groupID: String, expense: ExpenseModel) -> AnyPublisher<Void, ExpenseServiceError> {
        let groupsCollection = db.collection(Constants.DatabaseReferenceNames.groups)
        let currentGroupDocument = groupsCollection.document(groupID)
        let historyCollection = currentGroupDocument.collection(Constants.DatabaseReferenceNames.expensesHistory)
             
        return Future<Void, ExpenseServiceError> { promise in
            do {
                let _ = try historyCollection.addDocument(from: expense)
                promise(.success(()))
            } catch let error {
                promise(.failure(.inner(error)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getDefaultCategories() -> AnyPublisher<[ExpenseCategory], ExpenseServiceError> {
        let categoriesCollection = db.collection(Constants.DatabaseReferenceNames.categories)

        return Future<[ExpenseCategory], ExpenseServiceError> { promise in
            categoriesCollection.addSnapshotListener { snapshot, error in
                if let error = error {
                    promise(.failure(.inner(error)))
                    return
                }
                
                guard let data = snapshot?.documents else {
                    promise(.success([]))
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
        let groupsCollection = db.collection(Constants.DatabaseReferenceNames.groups)
        let currentGroupDocument = groupsCollection.document(groupID)
        let groupMembersCollection = currentGroupDocument.collection(Constants.DatabaseReferenceNames.members)
        
        return Future<[Member], ExpenseServiceError> { promise in
            groupMembersCollection.getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(.inner(error)))
                    return
                }

                guard let data = snapshot?.documents else {
                    promise(.success([]))
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
    
    
    func addListenerToExpenses(groupID: String) -> AnyPublisher<[ExpenseModel], ExpenseServiceError> {
        let groupsCollection = db.collection(Constants.DatabaseReferenceNames.groups)
        let currentGroupDocument = groupsCollection.document(groupID)
        let historyCollection = currentGroupDocument.collection(Constants.DatabaseReferenceNames.expensesHistory).order(by: "date", descending: true)
        
        return Publishers.SnapshotPublisher(historyCollection, includeMetadataChanges: true)
            .map { snapshot in
                snapshot.documents.compactMap { try? $0.data(as: ExpenseModel.self) }
            }
            .mapError { error in .inner(error) }
            .eraseToAnyPublisher()
    }
    
    func deleteExpense(id: String, groupID: String) -> AnyPublisher<Void, ExpenseServiceError> {
        let groupsCollection = db.collection(Constants.DatabaseReferenceNames.groups)
        let currentGroupDocument = groupsCollection.document(groupID)
        let historyCollection = currentGroupDocument.collection(Constants.DatabaseReferenceNames.expensesHistory)
        let historyItem = historyCollection.document(id)

        return Future<Void, ExpenseServiceError> { promise in
            historyItem.delete { error in
                if let error = error {
                    promise(.failure(.inner(error)))
                    return
                }
                
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
}
