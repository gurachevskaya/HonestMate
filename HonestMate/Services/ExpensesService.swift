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
    func addListenerToExpenses(groupID: String) -> AnyPublisher<[HistoryItemModel], ExpenseServiceError>
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
                promise(.failure(.inner))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getDefaultCategories() -> AnyPublisher<[ExpenseCategory], ExpenseServiceError> {
        let categoriesCollection = db.collection(Constants.DatabaseReferenceNames.categories)
      
        return Future<[ExpenseCategory], ExpenseServiceError> { promise in
            categoriesCollection.addSnapshotListener { snapshot, error in
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
        let groupsCollection = db.collection(Constants.DatabaseReferenceNames.groups)
        let currentGroupDocument = groupsCollection.document(groupID)
        let groupMembersCollection = currentGroupDocument.collection(Constants.DatabaseReferenceNames.members)
        
        return Future<[Member], ExpenseServiceError> { promise in
            groupMembersCollection.getDocuments { snapshot, error in
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
    
    
    func addListenerToExpenses(groupID: String) -> AnyPublisher<[HistoryItemModel], ExpenseServiceError> {
        let groupsCollection = db.collection(Constants.DatabaseReferenceNames.groups)
        let currentGroupDocument = groupsCollection.document(groupID)
        let historyCollection = currentGroupDocument.collection(Constants.DatabaseReferenceNames.expensesHistory)
        
        return Publishers.SnapshotPublisher(historyCollection, includeMetadataChanges: true)
            .map { snapshot in
                snapshot.documents.compactMap { try? $0.data(as: HistoryItemModel.self) }
            }
            .mapError { _ in .inner }
            .eraseToAnyPublisher()
    }
}
