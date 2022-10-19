//
//  WeakAssign.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 19.10.22.
//

import Combine

extension Publisher where Failure == Never {
    func weakAssign<T: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<T, Output>,
        on object: T
    ) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
