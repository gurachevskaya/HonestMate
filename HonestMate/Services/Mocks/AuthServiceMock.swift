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
    
    var error: AuthError?
    var loginWasCalled = false
    var registerWasCalled = false
    var logoutWasCalled = false
    
    func reset() {
        error = nil
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
        
        if let error = error {
            return Fail(error: error)
                .delay(for: 2, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        } else {
            return Just(())
                .delay(for: 2, scheduler: RunLoop.main)
                .setFailureType(to: AuthError.self)
                .eraseToAnyPublisher()
        }
    }
    
    func createUser(email: String, password: String) -> AnyPublisher<Void, AuthError> {
        registerWasCalled = true
        
        if let error = error {
            return Fail(error: error)
                .delay(for: 2, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        } else {
            return Just(())
                .delay(for: 2, scheduler: RunLoop.main)
                .setFailureType(to: AuthError.self)
                .eraseToAnyPublisher()
        }
    }
    
    func logout() -> AnyPublisher<Void, AuthError> {
        logoutWasCalled = true
        
        if let error = error {
            return Fail(error: error)
                .delay(for: 2, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        } else {
            return Just(())
                .delay(for: 2, scheduler: RunLoop.main)
                .setFailureType(to: AuthError.self)
                .eraseToAnyPublisher()
        }
    }
}
