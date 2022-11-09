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
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }

    func test_elementsOnScreen() {   
        openFirstCellDetails()
        
        let labelsCount = app.staticTexts.count
        XCTAssertEqual(labelsCount, 13)
        
        let header = app.otherElements[Constants.AccessebilityIDs.headerView]
        XCTAssertTrue(header.exists)
    }
    
    func test_backButtonTapped() {
        openFirstCellDetails()
        
        let detailsView = app.scrollViews[Constants.AccessebilityIDs.detailsView]
        XCTAssertTrue(detailsView.exists)
        XCTAssertTrue(detailsView.isHittable)
        
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        backButton.tap()

        XCTAssertFalse(detailsView.exists)
        XCTAssertFalse(detailsView.isHittable)
    }
    
    func test_editButtonTapped() {
        openFirstCellDetails()
        
        let detailsView = app.scrollViews[Constants.AccessebilityIDs.detailsView]
        XCTAssertTrue(detailsView.exists)
        XCTAssertTrue(detailsView.isHittable)
        
        let editButton = app.navigationBars.buttons.element(boundBy: 1)
        editButton.tap()
        
        XCTAssertFalse(detailsView.exists)
        XCTAssertFalse(detailsView.isHittable)
    }
    
    private func openFirstCellDetails() {
        openHistory()
        sleep(3)
        let historyList = app.collectionViews.firstMatch
        let firstCell = historyList.cells.firstMatch
        firstCell.tap()
    }
}

extension ExpenseDetails_UITests {
    private func openHistory() {
        TestsSigninHelper.shared.signIn(app: app)
        sleep(3)
        TestsSigninHelper.shared.selectGroup(app: app)
        
        app.tabBars["Tab Bar"].buttons.element(boundBy: 0).tap()
    }
}

