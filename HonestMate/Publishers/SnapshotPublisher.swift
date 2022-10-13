//
//  SnapshotPublisher.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 12.10.22.
//

import Foundation
import Combine
import FirebaseFirestore

enum FirestoreError: Error {
    case nilResultError
}

extension Publishers {
    struct SnapshotPublisher: Publisher {
        typealias Output = QuerySnapshot
        typealias Failure = Error
        
        private let query: Query
        private let includeMetadataChanges: Bool
        
        init(_ query: Query, includeMetadataChanges: Bool) {
            self.query = query
            self.includeMetadataChanges = includeMetadataChanges
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Error == S.Failure, QuerySnapshot == S.Input {
            let subscription = SnapshotSubscription(
                subscriber: subscriber,
                query: query,
                includeMetadataChanges: includeMetadataChanges
            )
            subscriber.receive(subscription: subscription)
        }
        
        private final class SnapshotSubscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == QuerySnapshot, SubscriberType.Failure == Error {
            
            private var registration: ListenerRegistration?
            
            init(
                subscriber: SubscriberType,
                query: Query,
                includeMetadataChanges: Bool
            ) {
                registration = query.addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { querySnapshot, error in
                    if let error = error {
                        subscriber.receive(completion: .failure(error))
                    } else if let querySnapshot = querySnapshot {
                        _ = subscriber.receive(querySnapshot)
                    } else {
                        subscriber.receive(completion: .failure(FirestoreError.nilResultError))
                    }
                }
            }
            
            func request(_ demand: Subscribers.Demand) {}
            
            func cancel() {
                registration?.remove()
                registration = nil
            }
        }
    }
}

