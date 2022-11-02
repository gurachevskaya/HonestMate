//
//  SignInViewModel_Tests.swift
//  HonestMateTests
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import XCTest
@testable import HonestMate
import Combine
import SwiftUI

final class SignInViewModel_Tests: XCTestCase {
    
    var sut: SignInViewModel!
    
    private var authService = AuthServiceMock()
    private var remoteConfig = RemoteConfigMock()
    
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        sut = SignInViewModel(
            authService: authService,
            remoteConfigService: remoteConfig
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        authService.reset()
    }
    
    func test_SignInViewModel_login_fail() {
        // Given
        authService.error = .networkError
        
        // When
        sut.selected = .login
        sut.actionButtonTapped()
        
        // Then
        let expectation = XCTestExpectation(description: "Login does fail")
        
        sut.$alertItem
            .dropFirst()
            .sink { [weak self] item in
                expectation.fulfill()
                
                XCTAssertTrue(self?.authService.loginWasCalled == true)
                XCTAssertNotNil(item)
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_SignInViewModel_login_success() {
        // When
        sut.selected = .login
        sut.actionButtonTapped()
        
        // Then
                
        let expectation = XCTestExpectation(description: "Login does succeed")
        
        sut.$path
            .dropFirst()
            .sink { [weak self] path in
                expectation.fulfill()
                XCTAssertTrue(self?.authService.loginWasCalled == true)
                XCTAssertEqual(SignInRoute.chooseGroup, path.last)
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_SignInViewModel_register_fail() {
        // When
        authService.error = .alreadyInUse
        sut.selected = .register
        sut.actionButtonTapped()
        
        // Then
        let expectation = XCTestExpectation(description: "Register does fail")
        
        sut.$alertItem
            .dropFirst()
            .sink { [weak self] item in
                expectation.fulfill()
                
                XCTAssertTrue(self?.authService.registerWasCalled == true)
                XCTAssertNotNil(item)
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_SignInViewModel_login_isLoading() {
        sut.selected = .login
        XCTAssertFalse(sut.isLoading)
        sut.actionButtonTapped()
        XCTAssertTrue(sut.isLoading)
    }
    
    func test_SignInViewModel_register_isLoading() {
        sut.selected = .register
        XCTAssertFalse(sut.isLoading)
        sut.actionButtonTapped()
        XCTAssertTrue(sut.isLoading)
    }
    
    func test_SignInViewModel_login_mapError_invalidEmail() {
        // When
        authService.error = .invalidEmail
        sut.actionButtonTapped()
        
        // Then
        let expectation = XCTestExpectation(description: "Alert is invalidEmail")
        
        sut.$alertItem
            .dropFirst()
            .sink { item in
                if item == AlertContext.invalidEmail {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_SignInViewModel_login_mapError_userDisabled() {
        // When
        authService.error = .userDisabled
        sut.actionButtonTapped()
        
        // Then
        let expectation = XCTestExpectation(description: "Alert is userDisabled")
        
        sut.$alertItem
            .dropFirst()
            .sink { item in
                if item == AlertContext.userDisabled {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_SignInViewModel_login_mapError_unableToComplete() {
        // When
        authService.error = .networkError
        sut.actionButtonTapped()
        
        // Then
        let expectation = XCTestExpectation(description: "Alert is unableToComplete")
        
        sut.$alertItem
            .dropFirst()
            .sink { item in
                if item == AlertContext.unableToComplete {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_SignInViewModel_login_mapError_alreadyInUse() {
        // When
        authService.error = .alreadyInUse
        sut.actionButtonTapped()
        
        // Then
        let expectation = XCTestExpectation(description: "Alert is alreadyInUse")
        
        sut.$alertItem
            .dropFirst()
            .sink { item in
                if item == AlertContext.alreadyInUse {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_SignInViewModel_login_mapError_userNotFound() {
        // When
        authService.error = .userNotFound
        sut.actionButtonTapped()
        
        // Then
        let expectation = XCTestExpectation(description: "Alert is userNotFound")
        
        sut.$alertItem
            .dropFirst()
            .sink { item in
                if item == AlertContext.userNotFound {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_SignInViewModel_login_mapError_innerError() {
        // When
        authService.error = .inner("error")
        sut.actionButtonTapped()
        
        // Then
        let expectation = XCTestExpectation(description: "Alert is innerError")
        
        sut.$alertItem
            .dropFirst()
            .sink { item in
                if item == AlertContext.innerError {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_SignInViewModel_login_mapError_wrondPassword() {
        // When
        authService.error = .wrongPassword
        sut.actionButtonTapped()
        
        // Then
        let expectation = XCTestExpectation(description: "Alert is wrondPassword")
        
        sut.$alertItem
            .dropFirst()
            .sink { item in
                if item == AlertContext.wrondPassword {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_SignInViewModel_register_success() {
        // When
        sut.selected = .register
        sut.actionButtonTapped()
        
        // Then
        let expectation = XCTestExpectation(description: "Register does succeed")
        
        sut.$path
            .dropFirst()
            .sink { [weak self] path in
                expectation.fulfill()
                
                XCTAssertTrue(self?.authService.registerWasCalled == true)
                XCTAssertEqual(SignInRoute.chooseGroup, path.last)
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_SignInViewModel_login_buttonShouldBeDisabledWhenInvalidPassword() {
        sut.selected = .login
        sut.email = "test@gmail.com"

        sut.password = ""
        XCTAssertFalse(sut.actionButtonEnabled)
        
        sut.password = "11111111"
        XCTAssertFalse(sut.actionButtonEnabled)
        
        sut.password = "111111a"
        XCTAssertFalse(sut.actionButtonEnabled)
    }
    
    func test_SignInViewModel_login_buttonShouldBeDisabledWhenInvalidEmail() {
        sut.selected = .login
        sut.password = "123456aa"
        
        sut.email = ""
        XCTAssertFalse(sut.actionButtonEnabled)
        
        sut.email = "fsksufjksf"
        XCTAssertFalse(sut.actionButtonEnabled)
    }
    
    func test_SignInViewModel_login_buttonShouldBeEnabled() {
        sut.selected = .login
        sut.email = "test@gmail.com"
        sut.password = "123456aa"
        XCTAssertTrue(sut.actionButtonEnabled)
    }
    
    func test_SignInViewModel_register_buttonShouldBeEnabled() {
        sut.selected = .register
        sut.email = "test@gmail.com"
        sut.password = "123456aa"
        sut.confirmPassword = "123456aa"
        XCTAssertTrue(sut.actionButtonEnabled)
    }
    
    func test_SignInViewModel_register_buttonShouldBeDisabledWithoutConfirmedPassword() {
        sut.selected = .register
        sut.email = "test@gmail.com"
        sut.password = "123456aa"
        XCTAssertFalse(sut.actionButtonEnabled)
    }
    
    func test_SignInViewModel_register_buttonShouldBeDisabledWhenInvalidPassword() {
        sut.selected = .register
        sut.email = "test@gmail.com"

        sut.password = ""
        XCTAssertFalse(sut.actionButtonEnabled)
        
        sut.password = "11111111"
        XCTAssertFalse(sut.actionButtonEnabled)
        
        sut.password = "111111a"
        XCTAssertFalse(sut.actionButtonEnabled)
    }
    
    func test_SignInViewModel_register_buttonShouldBeDisabledWhenInvalidEmail() {
        sut.selected = .register
        sut.password = "123456aa"
        
        sut.email = ""
        XCTAssertFalse(sut.actionButtonEnabled)
        
        sut.email = "fsksufjksf"
        XCTAssertFalse(sut.actionButtonEnabled)
    }
    
    func test_SignInViewModel_buttonShouldBeDisabledWhenAgreeTermsFalse() {
        sut.agreeTerms = false
        
        sut.selected = .register
        XCTAssertFalse(sut.actionButtonEnabled)
        sut.selected = .login
        XCTAssertFalse(sut.actionButtonEnabled)
    }
    
    func test_SignInViewModel_accentColor() {
        // When
        remoteConfig.appConfig = AppConfig(
            loginConfig: LoginConfig(
                facebookEnabled: true,
                googleEnabled: true,
                appleEnabled: true
            ),
            accentColor: "#d3419d",
            colourful: true
        )
        
        // Then
        let expectedColor = Color(hex: remoteConfig.appConfig?.accentColor ?? "")
        XCTAssertEqual(expectedColor, sut.accentColor)
    }
    
    func test_SignInViewModel_loginConfig() {
        // When
        remoteConfig.appConfig = AppConfig(
            loginConfig: LoginConfig(
                facebookEnabled: true,
                googleEnabled: true,
                appleEnabled: true
            ),
            accentColor: "#d3419d",
            colourful: true
        )
        
        // Then
        let expectedLoginConfig = remoteConfig.appConfig?.loginConfig
        XCTAssertEqual(expectedLoginConfig, sut.loginConfig)
    }
    
}
