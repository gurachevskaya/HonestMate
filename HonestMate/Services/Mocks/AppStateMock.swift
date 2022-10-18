//
//  AppStateMock.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import Foundation
import Combine

class AppStateMock: AppStateProtocol, ObservableObject {
    var homePath: [HomeRoute] = []
    
    var isLoggedIn: Bool = false
    var groupID: String = "5Pcoq4Yq4zwabAGmaafj"
    
    func clear() {
        isLoggedIn = false
        groupID = ""
    }
}
