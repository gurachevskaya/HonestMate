//
//  GroupsServiceMock.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 28.10.22.
//

import Foundation
import Combine

class GroupsServiceMock: GroupsServiceProtocol {
    func getUserInfo(userID: UserIdentifier) -> AnyPublisher<UserInfoModel, GroupsServiceError> {
        return Just(MockData.userInfo)
            .delay(for: 2, scheduler: RunLoop.main)
            .setFailureType(to: GroupsServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func getGroups() -> AnyPublisher<[GroupModel], GroupsServiceError> {
        return Just(([MockData.currentGroup]))
            .delay(for: 2, scheduler: RunLoop.main)
            .setFailureType(to: GroupsServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func getGroup(groupID: String) -> AnyPublisher<GroupModel, GroupsServiceError> {
        return Just((MockData.currentGroup))
            .delay(for: 2, scheduler: RunLoop.main)
            .setFailureType(to: GroupsServiceError.self)
            .eraseToAnyPublisher()
    }
}
