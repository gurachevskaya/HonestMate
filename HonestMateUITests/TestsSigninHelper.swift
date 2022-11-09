//
//  TestsSigninHelper.swift
//  HonestMateUITests
//
//  Created by Karina gurachevskaya on 8.11.22.
//

import Foundation
import XCTest

struct TestsSigninHelper {
    
    static let shared = TestsSigninHelper()
    
    private init() {}
    
    func signIn(app: XCUIApplication) {
        let signInButton = app.buttons[Constants.AccessebilityIDs.signInButton]
        pasteValidCredentials(app: app)
        signInButton.tap()
    }
    
    func selectGroup(app: XCUIApplication) {
        let groupsList = app.collectionViews.firstMatch
        let firstCell = groupsList.cells.firstMatch
        firstCell.tap()
    }
    
    func pasteText(app: XCUIApplication, _ text: String, in element: XCUIElement) {
        UIPasteboard.general.string = text
        element.doubleTap()
        app.menuItems["Paste"].tap()
    }
    
    private func pasteValidCredentials(app: XCUIApplication) {
        let emailTextField = app.textFields[Constants.AccessebilityIDs.emailTextField]
        let passwordTextField = app.secureTextFields[Constants.AccessebilityIDs.passwordTextField]
        
        emailTextField.tap()
        if passwordTextField.exists {
            pasteText(app: app, "gurachevich@mail.com", in: emailTextField)
        }
        passwordTextField.tap()
        if passwordTextField.exists {
            pasteText(app: app, "123456aa", in: passwordTextField)
        }
        app.buttons["Return"].tap()
    }
}
