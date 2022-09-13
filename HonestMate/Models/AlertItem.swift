//
//  AlertItem.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 2.09.22.
//

import SwiftUI

struct AlertItem: Identifiable, Equatable {
    static func == (lhs: AlertItem, rhs: AlertItem) -> Bool {
        lhs.message == rhs.message
    }
    
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

extension AlertItem {
    init(message: Text) {
        self.init(
            title: Text(R.string.localizable.alertInnerErrorTitle()),
            message: message,
            dismissButton: .default(Text(R.string.localizable.alertDismissButtonTitle()))
        )
    }
    
    init(title: Text, message: Text) {
        self.init(
            title: title,
            message: message,
            dismissButton: .default(Text(R.string.localizable.alertDismissButtonTitle()))
        )
    }
}

struct AlertContext {
    //MARK: - Network Alerts
    static let invalidData = AlertItem(
        title: Text(R.string.localizable.alertInvalidDataTitle()),
        message: Text(R.string.localizable.alertInvalidDataMessage())
    )
    
    static let invalidResponse = AlertItem(
        title: Text(R.string.localizable.alertInvalidResponseTitle()),
        message: Text(R.string.localizable.alertInvalidResponseMessage())
    )
    
    static let unableToComplete = AlertItem(
        title: Text(R.string.localizable.alertUnableToCompleteTitle()),
        message: Text(R.string.localizable.alertUnableToCompleteMessage())
    )
    
    static let innerError = AlertItem(
        title: Text(R.string.localizable.alertInnerErrorTitle()),
        message: Text(R.string.localizable.alertInnerErrorMessage())
    )
    
    //MARK: - Sign in, Sign out
    static let alreadyInUse = AlertItem(
        title: Text(R.string.localizable.alertAlreadyInUseTitle()),
        message: Text(R.string.localizable.alertAlreadyInUseMessage())
    )
    
    static let userNotFound = AlertItem(
        title: Text(R.string.localizable.alertUserNotFoundTitle()),
        message: Text(R.string.localizable.alertUserNotFoundMessage())
    )
    
    static let invalidEmail = AlertItem(
        title: Text(R.string.localizable.alertInvalidEmailErrorTitle()),
        message: Text(R.string.localizable.alertInvalidEmailErrorMessage())
    )
    
    static let wrondPassword = AlertItem(
        title: Text(R.string.localizable.alertWrongPasswordErrorTitle()),
        message: Text(R.string.localizable.alertWrongPasswordErrorMessage())
    )
    
    static let userDisabled = AlertItem(
        title: Text(R.string.localizable.alertUserDisabledErrorTitle()),
        message: Text(R.string.localizable.alertUserDisabledErrorMessage())
    )
}

