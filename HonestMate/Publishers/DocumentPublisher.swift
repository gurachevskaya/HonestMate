//
//  DocumentPublisher.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 17.10.22.
//

import Foundation
import FirebaseFirestore
import Combine

extension Publishers {
    struct FirestoreDocumentPublisher: Publisher {
        typealias Output = DocumentSnapshot
        typealias Failure = Error
        
        private let ref: DocumentReference
        
        init(ref: DocumentReference) {
            self.ref = ref
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = FirestoreDocumentSubscription(
                documentRef: ref,
                subscriber: subscriber
            )
            subscriber.receive(subscription: subscription)
        }
        
        private final class FirestoreDocumentSubscription<S: Subscriber>: Combine.Subscription where S.Input == DocumentSnapshot, S.Failure == Error {

            private var subscriber: S?
            private var listener: ListenerRegistration?

            init(
                documentRef: DocumentReference,
                subscriber: S
            ) {
                self.subscriber = subscriber
                
                listener = documentRef.addSnapshotListener { snapshot, error in
                    if let error = error {
                        subscriber.receive(completion: .failure(error))
                    } else if let snapshot = snapshot {
                        _ = subscriber.receive(snapshot)
                    } else {
                        subscriber.receive(completion: .failure(FirestoreError.nilResultError))
                    }
                }
            }

            func request(_ demand: Subscribers.Demand) {}

            func cancel() {
                subscriber = nil
                listener?.remove()
                listener = nil
            }
        }
    }
}
