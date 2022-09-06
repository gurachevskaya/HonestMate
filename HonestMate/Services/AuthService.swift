//
//  AuthService.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 2.09.22.
//

import Combine
import FirebaseAuth

enum AuthError: Error {
    case networkError
    case alreadyInUse
    case userNotFound
    case inner(String)
}

protocol AuthServiceProtocol {
    var currentUser: User? { get }
    
    func currentUserPublisher() -> AnyPublisher<User?, Never>
    func signin(email: String, password: String) -> AnyPublisher<Void, AuthError>
    func createUser(email: String, password: String) -> AnyPublisher<Void, AuthError>
    func logout() -> AnyPublisher<Void, AuthError>
}

final class AuthService: AuthServiceProtocol {
    var currentUser: User? { Auth.auth().currentUser }
    
    func signin(email: String, password: String) -> AnyPublisher<Void, AuthError> {
        return Future<Void, AuthError> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { [unowned self] result, error in
                if let error = error {
                    print(error)
                    promise(.failure(mapError(error)))
                } else if let _ = result?.user {
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
                    print(error)
                    promise(.failure(mapError(error)))
                } else if let _ = result?.user {
                    promise(.success(()))
                } else {
                    print("not handled correctly")
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func currentUserPublisher() -> AnyPublisher<User?, Never> {
        Just(Auth.auth().currentUser).eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, AuthError> {
        return Future<Void, AuthError> { [unowned self] promise in
            do {
                try Auth.auth().signOut()
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
            case .emailAlreadyInUse, .credentialAlreadyInUse, .accountExistsWithDifferentCredential:
                return .alreadyInUse
            case .networkError:
                return .networkError
            case .userNotFound:
                return .userNotFound
            default:
                return .inner(error.localizedDescription)
            }
        }
    }
}
