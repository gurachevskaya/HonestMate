//
//  ExpenseDetails_UITests.swift
//  HonestMateUITests
//
//  Created by Karina gurachevskaya on 3.11.22.
//

import XCTest

final class ExpenseDetails_UITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launchEnvironment["isLoggedIn"] = "true"
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }

    func test_elementsOnScreen() {
    }
    
    func test_backButtonTapped() {
    }
    
    func test_editButtonTapped() {
    }
}
