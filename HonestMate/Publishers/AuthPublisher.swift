//
//  AuthPublisher.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 6.09.22.
//

import Foundation
import Combine
import FirebaseAuth

extension Publishers {
    struct AuthPublisher: Publisher {
        typealias Output = Bool
        typealias Failure = Never
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Bool == S.Input {
            let authSubsciption = AuthSubscription(subscriber: subscriber)
            subscriber.receive(subscription: authSubsciption)
        }
                
        class AuthSubscription<S: Subscriber>: Subscription where S.Input == Bool, S.Failure == Never {
            private var subscriber: S?
            private var handler: AuthStateDidChangeListenerHandle?
            
            init(subscriber: S) {
                self.subscriber = subscriber
                handler = Auth.auth().addStateDidChangeListener { auth, user in
                    _ = subscriber.receive(user != nil)
                }
            }
            
            func request(_ demand: Subscribers.Demand) {}
            
            func cancel() {
                subscriber = nil
                handler = nil
            }
        }
    }
}
