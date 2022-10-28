//
//  HistoryViewModel_Tests.swift
//  HonestMateTests
//
//  Created by Karina gurachevskaya on 28.10.22.
//

import XCTest
@testable import HonestMate
import Combine

final class HistoryViewModel_Tests: XCTestCase {
    
    var sut: HistoryViewModel!
    
    private var expensesService = ExpensesServiceMock()
    private var appState = AppStateMock()
    private var groupsService = GroupsServiceMock()

    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        sut = HistoryViewModel(
            expensesService: expensesService,
            appState: appState,
            groupsService: groupsService
        )
    }

    override func tearDownWithError() throws {
    }
}
