//
//  AuthService.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 2.09.22.
//

import Combine
import FirebaseAuth

enum AuthError: Error {
    case failed
}

protocol AuthServiceProtocol {
    var currentUser: User? { get }
    
    func currentUserPublisher() -> AnyPublisher<User?, Never>
    func signin(email: String, password: String) -> AnyPublisher<Void, AuthError>
    func logout() -> AnyPublisher<Void, AuthError>
}

final class AuthService: AuthServiceProtocol {
    var currentUser: User? { Auth.auth().currentUser }
    
    func signin(email: String, password: String) -> AnyPublisher<Void, AuthError> {
        return Future<Void, AuthError> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    promise(.failure(AuthError.failed))
                } else if let user = result?.user {
                    print("success")
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func currentUserPublisher() -> AnyPublisher<User?, Never> {
        Just(Auth.auth().currentUser).eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, AuthError> {
        return Future<Void, AuthError> { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(.failed))
            }
        }
        .eraseToAnyPublisher()
    }
}
