//
//  AnyCancellable.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 18.10.22.
//

import Foundation
import Combine

protocol AnyObservableObject: AnyObject {
    var objectWillChange: ObservableObjectPublisher { get }
}
