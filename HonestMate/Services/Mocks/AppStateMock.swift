//
//  AppStateMock.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import Foundation
import Combine

class AppStateMock: AppStateProtocol, ObservableObject{
    var isLoggedIn: Bool = false
}
