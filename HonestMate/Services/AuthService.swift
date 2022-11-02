//
//  AuthService.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 2.09.22.
//

import Combine
import FirebaseAuth
import SwiftUI
import FirebaseDatabase

enum AuthError: Error {
    case networkError
    case alreadyInUse
    case userNotFound
    case invalidEmail
    case wrongPassword
    case userDisabled
    case inner(String)
}

protocol AuthServiceProtocol {
    var currentUser: User? { get }
    
    func observeAuthChanges() -> AnyPublisher<Bool, Never>
    func signin(email: String, password: String) -> AnyPublisher<Void, AuthError>
    func createUser(email: String, password: String) -> AnyPublisher<Void, AuthError>
    func logout() -> AnyPublisher<Void, AuthError>
}

final class AuthService: AuthServiceProtocol {
    private var appState: AppStateProtocol
    private var navigationState: NavigationStateProtocol
    
    init(
        appState: AppStateProtocol,
        navigationState: NavigationStateProtocol
    ) {
        self.appState = appState
        self.navigationState = navigationState
    }
    
    var currentUser: User? { Auth.auth().currentUser }
    
    func observeAuthChanges() -> AnyPublisher<Bool, Never> {
        Publishers.AuthPublisher().eraseToAnyPublisher()
    }
    
    func signin(email: String, password: String) -> AnyPublisher<Void, AuthError> {
        return Future<Void, AuthError> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { [unowned self] result, error in
                if let error = error {
                    promise(.failure(mapError(error)))
                } else if let _ = result?.user {
                    appState.isLoggedIn = true
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func createUser(email: String, password: String) -> AnyPublisher<Void, AuthError> {
        return Future<Void, AuthError> { [unowned self] promise in
            Auth.auth().createUser(withEmail: email, password: password) { [unowned self] result, error in
                if let error = error {
                    promise(.failure(mapError(error)))
                } else {
                    appState.isLoggedIn = true
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func logout() -> AnyPublisher<Void, AuthError> {
        return Future<Void, AuthError> { [unowned self] promise in
            do {
                try Auth.auth().signOut()
                
                appState.clear()
                navigationState.clear()
                promise(.success(()))
            } catch let error {
                print(error)
                promise(.failure(mapError(error)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func mapError(_ error: Error) -> AuthError {
        if let nserror = error as NSError? {
            let errorCode = AuthErrorCode(_nsError: nserror)
            
            switch errorCode.code {
            case .invalidEmail:
                return .invalidEmail
            case .wrongPassword:
                return .wrongPassword
            case .userDisabled:
                return .userDisabled
            case .emailAlreadyInUse, .credentialAlreadyInUse, .accountExistsWithDifferentCredential:
                return .alreadyInUse
            case .userNotFound:
                return .userNotFound
            case .networkError:
                return .networkError
            default:
                return .inner(error.localizedDescription)
            }
        }
    }
}
