//
//  Constants.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 8.09.22.
//

import Foundation

enum Constants {
    enum SFSymbols {
        static let list = "list.bullet"
        static let house = "house"
        static let gearshape = "gearshape"
    }
    
    enum StorageKeys {
        static let isLoggedIn = "isLoggedIn"
        static let groupID = "groupID"
    }
    
    enum FeatureFlagKeys {
        static let loginConfig = "loginConfig"
        static let accentColor = "accentColor"
    }
    
    enum AccessebilityIDs {
        static let emailTextField = "email"
        static let passwordTextField = "password"
        static let confirmPasswordTextField = "confirmPassword"
        static let signInButton = "signIn"
        static let titleLabel = "titleLabel"
    }
    
    enum DatabaseReferenceNames {
        static let users = "users"
        static let groups = "groups"
        static let categories = "categories"
        static let expensesHistory = "expensesHistory"
        static let members = "members"
    }
}
