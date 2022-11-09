//
//  GroupsServiceMock.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 28.10.22.
//

import Foundation
import Combine

class GroupsServiceMock: GroupsServiceProtocol {
    var groups: [GroupModel] = []
    var group = MockData.currentGroup
    
    var getGroupsShouldFail = false
    var getGroupShouldFail = false

    var getGroupsWasCalled = false
    var getGroupWasCalled = false
    
    func reset() {
        groups = []
        getGroupShouldFail = false
        getGroupShouldFail = false
        getGroupsWasCalled = false
        getGroupWasCalled = true
    }
    
    func getUserInfo(userID: UserIdentifier) -> AnyPublisher<UserInfoModel, GroupsServiceError> {
        return Just(MockData.userInfo)
            .delay(for: 2, scheduler: RunLoop.main)
            .setFailureType(to: GroupsServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func getGroups() -> AnyPublisher<[GroupModel], GroupsServiceError> {
        getGroupsWasCalled = true
        if !getGroupsShouldFail {
            return Just((MockData.groupModels))
                .delay(for: 2, scheduler: RunLoop.main)
                .setFailureType(to: GroupsServiceError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: GroupsServiceError.noData)
                .delay(for: 2, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
    }
    
    func getGroup(groupID: String) -> AnyPublisher<GroupModel, GroupsServiceError> {
        getGroupWasCalled = true
        if !getGroupShouldFail {
            return Just((group))
                .delay(for: 2, scheduler: RunLoop.main)
                .setFailureType(to: GroupsServiceError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: GroupsServiceError.noData)
                .delay(for: 2, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
    }
}
