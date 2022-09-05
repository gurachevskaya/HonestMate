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


struct AlertContext {
    //MARK: - Network Alerts
    static let invalidData = AlertItem(
        title: Text(R.string.localizable.alertInvalidDataTitle()),
        message: Text(R.string.localizable.alertInvalidDataMessage()),
        dismissButton: .default(Text(R.string.localizable.alertDismissButtonTitle()))
    )
    
    static let invalidResponse = AlertItem(
        title: Text(R.string.localizable.alertInvalidResponseTitle()),
        message: Text(R.string.localizable.alertInvalidResponseMessage()),
        dismissButton: .default(Text(R.string.localizable.alertDismissButtonTitle()))
    )
    
    static let unableToComplete = AlertItem(
        title: Text(R.string.localizable.alertUnableToCompleteTitle()),
        message: Text(R.string.localizable.alertUnableToCompleteMessage()),
        dismissButton: .default(Text(R.string.localizable.alertDismissButtonTitle()))
    )
    
    static let innerError = AlertItem(
        title: Text(R.string.localizable.alertInnerErrorTitle()),
        message: Text(R.string.localizable.alertInnerErrorMessage()),
        dismissButton: .default(Text(R.string.localizable.alertDismissButtonTitle()))
    )
}

