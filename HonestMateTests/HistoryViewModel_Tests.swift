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
            groupsService: groupsService,
            navigationState: NavigationStateMock()
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        expensesService.reset()
        groupsService.reset()
    }
    
    func test_HistoryViewModel_getData_loadingState() {
        // Given
        expensesService.shouldFail = true
        
        XCTAssertEqual(HistoryViewModel.State.idle, sut.state)
        
        // When
        sut.loadData()
        
        // Then
        XCTAssertEqual(HistoryViewModel.State.loading, sut.state)
    }
 
    func test_HistoryViewModel_getHistory_success() {
        // Given
        let historyMock = [MockData.historyItem]
        expensesService.history = historyMock
        expensesService.shouldFail = false
        
        // When
        sut.loadData()
        
        // Then
        let expectation = XCTestExpectation(description: "State is loaded")

        sut.$state
            .dropFirst()
            .sink { [weak self] state in
                expectation.fulfill()
                XCTAssertEqual(HistoryViewModel.State.loaded(historyMock), state)
                XCTAssertNil(self?.sut.alertItem)
                XCTAssertTrue(self?.expensesService.getHistoryWasCalled == true)
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 15)
    }
    
    func test_HistoryViewModel_getHistory_failed() {
        // Given
        let historyMock = [MockData.historyItem]
        expensesService.history = historyMock
        expensesService.shouldFail = true
        
        // When
        sut.loadData()
        
        // Then
        let expectation = XCTestExpectation(description: "Load history does fail")
        let expectation2 = XCTestExpectation(description: "State is loaded")

        sut.$alertItem
            .dropFirst()
            .sink { [weak self] alert in
                expectation.fulfill()
                XCTAssertTrue(self?.expensesService.getHistoryWasCalled == true)
                XCTAssertEqual(AlertContext.innerError, alert)
            }
            .store(in: &cancellables)
        
        sut.$state
            .dropFirst()
            .sink { state in
                expectation2.fulfill()
                XCTAssertEqual(HistoryViewModel.State.loaded([]), state)
            }
            .store(in: &cancellables)
        
        wait(for: [expectation, expectation2], timeout: 10)
    }
    
    func test_HistoryViewModel_getGroupName_success() {
        // Given
        let groupMock = MockData.currentGroup
        groupsService.group = groupMock
        groupsService.getGroupShouldFail = false
        
        // When
        sut.loadData()
        
        // Then
        let expectation = XCTestExpectation(description: "Get group name does succeed")

        sut.$groupName
            .dropFirst()
            .sink { [weak self] groupName in
                expectation.fulfill()
                XCTAssertEqual(groupMock.name, groupName)
                XCTAssertNil(self?.sut.alertItem)
                XCTAssertTrue(self?.groupsService.getGroupWasCalled == true)
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_HistoryViewModel_getGroupName_failure() {
        // Given
        let groupMock = MockData.currentGroup
        groupsService.group = groupMock
        groupsService.getGroupShouldFail = true
        
        // When
        sut.loadData()
        
        // Then
        let expectation = XCTestExpectation(description: "Get group name does fail")

        sut.$groupName
            .dropFirst()
            .sink { [weak self] groupName in
                expectation.fulfill()
                XCTAssertEqual("", groupName)
                XCTAssertNil(self?.sut.alertItem)
                XCTAssertTrue(self?.groupsService.getGroupWasCalled == true)
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_HistoryViewModel_deleteItem_whenOneItem_success() {
        // Given
        let historyMock = [MockData.historyItem]
        sut.state = .loaded(historyMock)
        
        // When
        sut.delete(at: IndexSet(integersIn: 0..<1))
        
        // Then
        XCTAssertTrue(expensesService.deleteItemWasCalled)
        sleep(3)
        XCTAssertEqual(sut.state, HistoryViewModel.State.loaded([]))
    }
    
    func test_HistoryViewModel_deleteRandomItem_success() {
        // Given
        let historyMock = MockData.historyMock
        sut.state = .loaded(historyMock)
        
        // When
        let randomIndex = Int.random(in: 0..<historyMock.count)
        sut.delete(at: IndexSet(integersIn: randomIndex...randomIndex))
        
        // Then
        XCTAssertTrue(expensesService.deleteItemWasCalled)
        
        let expectation = XCTestExpectation(description: "Delete random item does succeed")

        sut.$state
            .sink { state in
                expectation.fulfill()

                switch state {
                case .loaded(let model):
                    XCTAssertEqual(model.count, historyMock.count - 1)
                default:
                    XCTFail()
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }
    
    func test_HistoryViewModel_deleteFirstItem_success() {
        // Given
        var historyMock = MockData.historyMock
        sut.state = .loaded(historyMock)
        
        // When
        sut.delete(at: IndexSet(integersIn: 0..<1))
                
        // Then
        XCTAssertTrue(expensesService.deleteItemWasCalled)

        let removedElement = historyMock.removeFirst()
                
        let expectation = XCTestExpectation(description: "Delete first item does succeed")

        sut.$state
            .sink { state in
                expectation.fulfill()

                switch state {
                case .loaded(let model):
                    XCTAssertEqual(model.count, historyMock.count)
                    XCTAssertFalse(model.contains(removedElement))
                default:
                    XCTFail()
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }
    
    func test_HistoryViewModel_deleteFirstItem_failure_shouldShowAlert() {
        // Given
        let historyMock = [MockData.historyItem]
        sut.state = .loaded(historyMock)
        expensesService.shouldFail = true
        
        // When
        sut.delete(at: IndexSet(integersIn: 0..<1))
        
        // Then
        XCTAssertTrue(expensesService.deleteItemWasCalled)
        
        let expectation = XCTestExpectation(description: "Delete item does fail")

        sut.$alertItem
            .dropFirst()
            .sink { alert in
                expectation.fulfill()
                XCTAssertEqual(AlertContext.deletingError, alert)
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }
    
    func test_HistoryViewModel_deleteFirstItem_failure_state() {
        // Given
        let historyMock = [MockData.historyItem]
        sut.state = .loaded(historyMock)
        expensesService.shouldFail = true
        
        // When
        sut.delete(at: IndexSet(integersIn: 0...0))
        
        // Then
        XCTAssertTrue(expensesService.deleteItemWasCalled)

        let expectation = XCTestExpectation(description: "Same history count")

        sut.$state
            .dropFirst()
            .sink { state in
                expectation.fulfill()

                switch state {
                case .loaded(let model):
                    XCTAssertEqual(model.count, historyMock.count)

                default:
                    XCTFail()
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }
}
