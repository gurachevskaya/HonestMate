//
//  AppStateMock.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import Foundation
import Combine

class AppStateMock: AppStateProtocol, ObservableObject {
    @Published var homePath: [HomeRoute] = []
    
    @Published var isLoggedIn: Bool = false
    @Published var groupID: String = "5Pcoq4Yq4zwabAGmaafj"
    
    func clear() {
        isLoggedIn = false
        groupID = ""
    }
}
