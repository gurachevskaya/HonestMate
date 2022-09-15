//
//  Constants.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 8.09.22.
//

import Foundation

enum Constants {
    enum StorageKeys {
        static let isLoggedIn = "isLoggedIn"
    }
    
    enum FeatureFlagKeys {
        static let loginConfig = "loginConfig"
        static let isloginButtonPink = "isloginButtonPink"
    }
    
    enum AccessebilityIDs {
        static let emailTextField = "email"
        static let passwordTextField = "password"
        static let confirmPasswordTextField = "confirmPassword"
        static let signInButton = "signIn"
        static let titleLabel = "titleLabel"
    }
}
