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
    func createUser(name: String, email: String, password: String) -> AnyPublisher<Void, AuthError>
    func logout() -> AnyPublisher<Void, AuthError>
}

final class AuthService: AuthServiceProtocol {
    @AppStorage(Constants.StorageKeys.isLoggedIn) private var isLoggedIn = true
    
    let ref: DatabaseReference
    
    init(ref: DatabaseReference) {
        self.ref = ref
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
                    isLoggedIn = true
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func createUser(name: String, email: String, password: String) -> AnyPublisher<Void, AuthError> {
        return Future<Void, AuthError> { [unowned self] promise in
            Auth.auth().createUser(withEmail: email, password: password) { [unowned self] result, error in
                if let error = error {
                    promise(.failure(mapError(error)))
                } else if let user = result?.user {
                    saveName(user: user, name: name)
                    isLoggedIn = true
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func saveName(user: User, name: String) {
        let usersRef = ref.child(Constants.DatabaseReferenceNames.users)
        let currentUserRef = usersRef.child(user.uid)
        let userData = ["userName": name] as [String : Any]
        currentUserRef.updateChildValues(userData)
    }

    func logout() -> AnyPublisher<Void, AuthError> {
        return Future<Void, AuthError> { [unowned self] promise in
            do {
                try Auth.auth().signOut()
                isLoggedIn = false
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
