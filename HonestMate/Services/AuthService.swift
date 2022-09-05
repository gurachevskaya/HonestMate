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
    func currentUser() -> AnyPublisher<User?, Never>
    func signin(email: String, password: String) -> AnyPublisher<Void, AuthError>
}

final class AuthService: AuthServiceProtocol {
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
    
    func currentUser() -> AnyPublisher<User?, Never> {
        Just(Auth.auth().currentUser).eraseToAnyPublisher()
    }
}
