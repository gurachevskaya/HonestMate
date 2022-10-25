//
//  ExpensesService.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 7.10.22.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

enum ExpenseServiceError: LocalizedError {
    case inner(Error)
}

protocol ExpensesServiceProtocol {
    func createExpense(groupID: String, expense: ExpenseModel) -> AnyPublisher<Void, ExpenseServiceError>
    func getDefaultCategories() -> AnyPublisher<[ExpenseCategory], ExpenseServiceError>
    func getGroupMembers(groupID: String) -> AnyPublisher<[MemberModel], ExpenseServiceError>
    func addListenerToExpenses(groupID: String) -> AnyPublisher<[ExpenseModel], ExpenseServiceError>
    func deleteExpense(id: String, groupID: String) -> AnyPublisher<Void, ExpenseServiceError>
    func getBalances(groupID: String) -> AnyPublisher<[BalanceModel], ExpenseServiceError>
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
    
    func getGroupMembers(groupID: String) -> AnyPublisher<[MemberModel], ExpenseServiceError> {
        let groupsCollection = db.collection(Constants.DatabaseReferenceNames.groups)
        let currentGroupDocument = groupsCollection.document(groupID)
        let groupMembersCollection = currentGroupDocument.collection(Constants.DatabaseReferenceNames.members)
        
        return Future<[MemberModel], ExpenseServiceError> { promise in
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
                    try? $0.data(as: MemberModel.self)
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
    
    func getBalances(groupID: String) -> AnyPublisher<[BalanceModel], ExpenseServiceError> {
        addListenerToExpenses(groupID: groupID)
            .map { [unowned self] expenses in
                calculateBalances(expenses: expenses)
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    private func calculateBalances(expenses: [ExpenseModel]) -> [BalanceModel] {
        var balances: [BalanceModel] = []
        
        for expense in expenses {
            if let i = balances.firstIndex(where: { $0.member.id == expense.payer.id }) {
                balances[i].balance += expense.amount
            } else {
                balances.append(BalanceModel(member: expense.payer, balance: expense.amount))
            }
            
            let amountForOne = expense.amount / Double(expense.between.count)
            
            for member in expense.between {
                if let i = balances.firstIndex(where: { $0.member.id == member.id }) {
                    balances[i].balance -= amountForOne
                } else {
                    balances.append(BalanceModel(member: member, balance: -amountForOne))
                }
            }
        }
        return balances
    }
    
}
