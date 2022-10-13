//
//  GroupsService.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 13.10.22.
//

import Foundation
import Combine
import FirebaseFirestore


enum GroupsServiceError: LocalizedError {
    case inner
    case noData
}

protocol GroupsServiceProtocol {
    func getUserGroups(userID: UserIdentifier) -> AnyPublisher<[GroupModel], GroupsServiceError>
}

final class GroupsService: GroupsServiceProtocol {
    let db: Firestore
    
    init(db: Firestore) {
        self.db = db
    }
    
    func getUserGroups(userID: UserIdentifier) -> AnyPublisher<[GroupModel], GroupsServiceError> {
        let usersCollection = db.collection(Constants.DatabaseReferenceNames.users)
        let currentUserDocument = usersCollection.document(userID)
        let groupsCollection = currentUserDocument.collection(Constants.DatabaseReferenceNames.groups)

        return Future<[GroupModel], GroupsServiceError> { promise in
            groupsCollection.getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(.inner))
                }
                
                guard let data = snapshot?.documents else {
                    promise(.failure(.noData))
                    return
                }
                
                let groups = data.compactMap {
                    try? $0.data(as: GroupModel.self)
                }
                
                promise(.success(groups))
            }
        }
        .eraseToAnyPublisher()
    }
}
