//
//  SignInView_UITests.swift
//  HonestMateUITests
//
//  Created by Karina gurachevskaya on 13.09.22.
//

import XCTest
import Resolver

final class SignInView_UITests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
    }

    override func tearDown() {
        app.terminate()
        app = nil
    }
    
    func test_buttonsAndTitlesOnScreen() {
        let buttonsAmount = app.buttons.count
        let controlsCount = app.segmentedControls.buttons.count
        
        XCTAssertEqual(controlsCount, 2)

        XCTAssertEqual(buttonsAmount, 4 + controlsCount)

        let titleLabel = app.staticTexts[Constants.AccessebilityIDs.titleLabel]
        
        XCTAssertTrue(titleLabel.exists)
    }

    func test_picker_signInTextFields() {
        app.segmentedControls.buttons.element(boundBy: 0).tap()
        
        let emailTextField = app.textFields[Constants.AccessebilityIDs.emailTextField]
        let passwordTextField = app.secureTextFields[Constants.AccessebilityIDs.passwordTextField]
        let confirmPasswordTextField = app.secureTextFields[Constants.AccessebilityIDs.confirmPasswordTextField]
        
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordTextField.exists)
        XCTAssertFalse(confirmPasswordTextField.exists)
    }
    
    func test_picker_signUpTextFields() {
        app.segmentedControls.buttons.element(boundBy: 1).tap()
        
        let emailTextField = app.textFields[Constants.AccessebilityIDs.emailTextField]
        let passwordTextField = app.secureTextFields[Constants.AccessebilityIDs.passwordTextField]
        let confirmPasswordTextField = app.secureTextFields[Constants.AccessebilityIDs.confirmPasswordTextField]
        
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordTextField.exists)
        XCTAssertTrue(confirmPasswordTextField.exists)
    }
    
    func test_signInButton_enabled() {
        let signInButton = app.buttons[Constants.AccessebilityIDs.signInButton]
        
        XCTAssertFalse(signInButton.isEnabled)
        
        let emailTextField = app.textFields[Constants.AccessebilityIDs.emailTextField]
        let passwordTextField = app.secureTextFields[Constants.AccessebilityIDs.passwordTextField]
        let confirmPasswordTextField = app.secureTextFields[Constants.AccessebilityIDs.confirmPasswordTextField]

        emailTextField.tap()
        TestsSigninHelper.shared.pasteText(app: app, "email", in: emailTextField)
        passwordTextField.tap()
        if passwordTextField.exists {
            TestsSigninHelper.shared.pasteText(app: app, "password", in: passwordTextField)
        }
        app.buttons["Return"].tap()
        
        XCTAssertFalse(signInButton.isEnabled)
        
        emailTextField.tap()
        TestsSigninHelper.shared.pasteText(app: app, "email@gmail.com", in: emailTextField)
        passwordTextField.tap()
        TestsSigninHelper.shared.pasteText(app: app, "password1A", in: passwordTextField)
        app.buttons["Return"].tap()
      
        XCTAssertTrue(signInButton.isEnabled)
        
        app.segmentedControls.buttons.element(boundBy: 1).tap()
        
        XCTAssertFalse(signInButton.isEnabled)

        confirmPasswordTextField.tap()
        TestsSigninHelper.shared.pasteText(app: app, "password1A", in: confirmPasswordTextField)
        app.buttons["Return"].tap()

        XCTAssertTrue(signInButton.isEnabled)
    }
    
    func test_signInButton_showLoader() {
        let loader = app.activityIndicators.element
        
        let loaderWhenOpenExists = loader.exists
        XCTAssertFalse(loaderWhenOpenExists)
        
        TestsSigninHelper.shared.signIn(app: app)

        let loaderWhenTappedSignInExists = loader.exists
        XCTAssertTrue(loaderWhenTappedSignInExists)
        
        sleep(3)
        let loaderAfterCompletionExists = loader.exists
        XCTAssertFalse(loaderAfterCompletionExists)
    }
    
    func test_signInButton_showAlert() {
        TestsSigninHelper.shared.signIn(app: app)
                        
        let alert = app.alerts.firstMatch
        let okButton = alert.buttons["OK"]
        
        let exists = okButton.waitForExistence(timeout: 4)
        XCTAssertTrue(exists)
        
        okButton.tap()
        
        let existsAfterTap = okButton.waitForExistence(timeout: 1)
        XCTAssertFalse(existsAfterTap)
    }
}
