//
//  AuthServiceMock.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import Foundation
import Combine
import Firebase

class AuthServiceMock: AuthServiceProtocol {
    
    var shouldFail = false
    var loginWasCalled = false
    var registerWasCalled = false
    var logoutWasCalled = false
    
    func reset() {
        shouldFail = false
        loginWasCalled = false
        registerWasCalled = false
        logoutWasCalled = false
    }
    
    var currentUser: User?
    
    func observeAuthChanges() -> AnyPublisher<Bool, Never> {
        Just(false)
            .eraseToAnyPublisher()
    }
    
    func signin(email: String, password: String) -> AnyPublisher<Void, AuthError> {
        loginWasCalled = true
        
        if shouldFail {
            return Fail(error: AuthError.networkError)
                .delay(for: 2, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        } else {
            return Just(())
                .setFailureType(to: AuthError.self)
                .eraseToAnyPublisher()
        }
    }
    
    func createUser(name: String, email: String, password: String) -> AnyPublisher<Void, AuthError> {
        registerWasCalled = true
        
        if shouldFail {
            return Fail(error: AuthError.alreadyInUse)
                .delay(for: 2, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        } else {
            return Just(())
                .setFailureType(to: AuthError.self)
                .eraseToAnyPublisher()
        }
    }
    
    func logout() -> AnyPublisher<Void, AuthError> {
        logoutWasCalled = true
        
        if shouldFail {
            return Fail(error: AuthError.networkError)
                .delay(for: 2, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        } else {
            return Just(())
                .setFailureType(to: AuthError.self)
                .eraseToAnyPublisher()
        }
    }
}
