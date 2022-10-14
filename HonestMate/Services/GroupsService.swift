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
        
        let groupsCollection = db.collection(Constants.DatabaseReferenceNames.groups)

        return Future<[GroupModel], GroupsServiceError> { promise in
            currentUserDocument.getDocument { snapshot, error in
                if let error = error {
                    promise(.failure(.inner))
                }
                
                let user = try? snapshot?.data(as: UserInfoModel.self)
                
                guard let userGroups = user?.groups else {
                    promise(.failure(.noData))
                    return
                }
                
                groupsCollection.getDocuments { groupsSnapshot, error in
                    if let error = error {
                        promise(.failure(.inner))
                    }
                    
                    guard let data = groupsSnapshot?.documents else {
                        promise(.failure(.noData))
                        return
                    }
                    
                    let groups = data.compactMap {
                        try? $0.data(as: GroupModel.self)
                    }
                    
                    let filteredGroups = groups.filter { group in
                        userGroups.contains(group.id ?? "")
                    }
                                        
                    promise(.success(filteredGroups))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
