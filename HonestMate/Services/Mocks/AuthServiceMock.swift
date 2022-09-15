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
    var currentUser: User?
    
    func observeAuthChanges() -> AnyPublisher<Bool, Never> {
        Just(false)
            .eraseToAnyPublisher()
    }
    
    func signin(email: String, password: String) -> AnyPublisher<Void, AuthError> {
        Fail(error: AuthError.networkError)
            .delay(for: 2, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func createUser(email: String, password: String) -> AnyPublisher<Void, AuthError> {
        Fail(error: AuthError.networkError)
            .delay(for: 2, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, AuthError> {
        Just(())
            .setFailureType(to: AuthError.self)
            .eraseToAnyPublisher()
    }
}
