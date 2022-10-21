//
//  GroupsService.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 13.10.22.
//

import Combine
import FirebaseFirestore

enum GroupsServiceError: LocalizedError {
    case inner(Error)
    case mapping
    case noData
}

protocol GroupsServiceProtocol {
    func getUserInfo(userID: UserIdentifier) -> AnyPublisher<UserInfoModel, GroupsServiceError>
    func getGroups() -> AnyPublisher<[GroupModel], GroupsServiceError>
    func getGroup(groupID: String) -> AnyPublisher<GroupModel, GroupsServiceError>
}

final class GroupsService: GroupsServiceProtocol {
    let db: Firestore
    
    init(db: Firestore) {
        self.db = db
    }
    
    func getGroup(groupID: String) -> AnyPublisher<GroupModel, GroupsServiceError> {
        let groupsCollection = db.collection(Constants.DatabaseReferenceNames.groups)
        let groupDocument = groupsCollection.document(groupID)
                
        return Publishers.FirestoreDocumentPublisher(ref: groupDocument)
            .tryMap { snapshot in
                try snapshot.data(as: GroupModel.self)
            }
            .mapError { error in .inner(error) }
            .eraseToAnyPublisher()
    }
    
    func getGroups() -> AnyPublisher<[GroupModel], GroupsServiceError> {
        let groupsCollection = db.collection(Constants.DatabaseReferenceNames.groups)

        return Future<[GroupModel], GroupsServiceError> { promise in
                groupsCollection.getDocuments { groupsSnapshot, error in
                    if let error = error {
                        promise(.failure(.inner(error)))
                        return
                    }
                                        
                    guard let data = groupsSnapshot?.documents else {
                        promise(.success([]))
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
    
    func getUserInfo(userID: UserIdentifier) -> AnyPublisher<UserInfoModel, GroupsServiceError> {
        let usersCollection = db.collection(Constants.DatabaseReferenceNames.users)
        let currentUserDocument = usersCollection.document(userID)
        
        return Future<UserInfoModel, GroupsServiceError> { promise in
            currentUserDocument.getDocument { snapshot, error in
                if let error = error {
                    promise(.failure(.inner(error)))
                    return
                }
                
                guard let snapshot = snapshot else {
                    promise(.failure(.noData))
                    return
                }

                do {
                    let user = try snapshot.data(as: UserInfoModel.self)
                    promise(.success(user))
                } catch {
                    promise(.failure(.mapping))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
