//
//  AppConfig.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 9.09.22.
//

import Foundation

struct AppConfig: Codable {
    let loginConfig: LoginConfig?
    let accentColor: String
}

struct LoginConfig: Codable, Equatable {
    let facebookEnabled: Bool
    let googleEnabled: Bool
    let appleEnabled: Bool
}
