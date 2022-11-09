//
//  HistoryView_UITests.swift
//  HonestMateUITests
//
//  Created by Karina gurachevskaya on 3.11.22.
//

import XCTest

final class HistoryView_UITests: XCTestCase {
    
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
        openHistory()

        let loader = app.activityIndicators.element
        let loaderExists = loader.waitForExistence(timeout: 0.5)
        XCTAssertTrue(loaderExists)
        
        sleep(3)
        
        XCTAssertFalse(loader.exists)
        
        let navigationTitle = app.navigationBars.firstMatch.staticTexts.firstMatch
        XCTAssertTrue(navigationTitle.exists)
        
        let historyList = app.collectionViews.firstMatch
        XCTAssertTrue(historyList.exists)
    }
    
    func test_firstCellInitialElements() {
        openHistory()
        sleep(3)

        let historyList = app.collectionViews.firstMatch
        
        let firstCell = historyList.cells.firstMatch
        XCTAssertTrue(firstCell.exists)
        
        let textElementsCount = firstCell.staticTexts.count
        XCTAssertEqual(textElementsCount, 7)
        
        let circle = firstCell.otherElements[Constants.AccessebilityIDs.circle]
        XCTAssertTrue(circle.exists)
        
        let seeAll = firstCell.staticTexts[Constants.AccessebilityIDs.seeAllButton]
        XCTAssertTrue(seeAll.exists)

        let cellsCount = historyList.cells.count
        XCTAssertEqual(cellsCount, 3)
    }
    
    func test_BetweenLabelAppearsAfterTapSeeAll() {
        openHistory()
        sleep(3)

        let historyList = app.collectionViews.firstMatch
        let firstCell = historyList.cells.firstMatch
        
        let betweenMatesLabel = firstCell.staticTexts[Constants.AccessebilityIDs.betweenMatesLabel]
        XCTAssertFalse(betweenMatesLabel.exists)
        XCTAssertFalse(betweenMatesLabel.isHittable)

        let seeAll = firstCell.staticTexts[Constants.AccessebilityIDs.seeAllButton]
        seeAll.tap()
        
        let betweenMatesLabelExists = betweenMatesLabel.waitForExistence(timeout: 0.5)
        XCTAssertTrue(betweenMatesLabelExists)
        XCTAssertTrue(betweenMatesLabel.isHittable)
    }
    
    func test_tapRow() {
        openHistory()
        sleep(3)

        let historyView = app.collectionViews.firstMatch
        XCTAssertTrue(historyView.exists)
        XCTAssertTrue(historyView.isHittable)

        historyView.cells.firstMatch.tap()
        XCTAssertFalse(historyView.exists)
        XCTAssertFalse(historyView.isHittable)
    }
}

extension HistoryView_UITests {
    private func openHistory() {
        TestsSigninHelper.shared.signIn(app: app)
        sleep(3)
        TestsSigninHelper.shared.selectGroup(app: app)
        
        app.tabBars["Tab Bar"].buttons.element(boundBy: 0).tap()
    }
}
