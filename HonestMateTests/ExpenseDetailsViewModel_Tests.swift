//
//  ExpenseDetailsViewModel_Tests.swift
//  HonestMateTests
//
//  Created by Karina gurachevskaya on 2.11.22.
//

import XCTest
@testable import HonestMate
import Combine
import SwiftUI

final class ExpenseDetailsViewModel_Tests: XCTestCase {
    
    var sut: ExpenseDetailsViewModel!

    private var remoteConfig = RemoteConfigMock()
    
    override func setUpWithError() throws {
        sut = ExpenseDetailsViewModel(
            expense: MockData.historyItem,
            remoteConfig: remoteConfig
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_ExpenseDetailsViewModel_headerColor_whenDirectPayment() {
        sut.expense.expenseType = .directPayment
        let accentColor = "#d3419d"
        remoteConfig.appConfig = AppConfig(loginConfig: nil, accentColor: accentColor, colourful: true)
        
        let expectedColor = Color(hex: accentColor).opacity(0.5)
        XCTAssertEqual(sut.headerColor, expectedColor)
        
        let accentColor2 = "#fcba03"
        remoteConfig.appConfig = AppConfig(loginConfig: nil, accentColor: accentColor2, colourful: true)
        
        let expectedColor2 = Color(hex: accentColor2).opacity(0.5)
        XCTAssertEqual(sut.headerColor, expectedColor2)
    }
    
    func test_ExpenseDetailsViewModel_headerColor_whenNewExpense() {
        let expense = ExpenseModel(
            expenseType: .newExpense,
            category: ExpenseCategory(
                isActive: true,
                name: "name",
                hexColor: "#d3419d"
            ),
            amount: 20,
            date: Date(),
            payer: MockData.member,
            between: [MockData.member]
        )
        sut.expense = expense
        
        let expectedColor = Color(hex: expense.category?.hexColor ?? "").opacity(0.5)
        
        XCTAssertEqual(sut.headerColor, expectedColor)
        
        let expense2 = ExpenseModel(
            expenseType: .newExpense,
            category: ExpenseCategory(
                isActive: true,
                name: "name",
                hexColor: "#28fc03"
            ),
            amount: 20,
            date: Date(),
            payer: MockData.member,
            between: [MockData.member]
        )
        sut.expense = expense2
        
        let expectedColor2 = Color(hex: expense2.category?.hexColor ?? "").opacity(0.5)
        
        XCTAssertEqual(sut.headerColor, expectedColor2)
    }
    
    func test_ExpenseDetailsViewModel_title_whenNewExpense() {
        let expense = ExpenseModel(
            expenseType: .newExpense,
            category: ExpenseCategory(
                isActive: true,
                name: "name",
                hexColor: "#d3419d"
            ),
            amount: 20,
            date: Date(),
            payer: MockData.member,
            between: [MockData.member]
        )
        sut.expense = expense
        
        let expectedTitle = expense.category?.name
        
        XCTAssertEqual(sut.title, expectedTitle)
    }
    
    func test_ExpenseDetailsViewModel_title_whenDirectPayment() {
        let expense = ExpenseModel(
            expenseType: .directPayment,
            category: ExpenseCategory(
                isActive: true,
                name: "name",
                hexColor: "#d3419d"
            ),
            amount: 20,
            date: Date(),
            payer: MockData.member,
            between: [MockData.member]
        )
        sut.expense = expense
        
        let expectedTitle = R.string.localizable.expenseDetailsDirectPaymentTitle()
        
        XCTAssertEqual(sut.title, expectedTitle)
    }
}
