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
    
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_SignInViewModel_login_fail() {
        // Given
        let authService = AuthServiceMock()
        authService.shouldFail = true
                
        sut = SignInViewModel(
            authService: authService,
            remoteConfigService: RemoteConfigMock()
        )
        
        // When
        sut.selected = .login
        sut.actionButtonTapped()
        
        // Then
        let expectation = XCTestExpectation(description: "Login does fail")
        
        sut.$alertItem
            .dropFirst()
            .sink { item in
                expectation.fulfill()
                
                XCTAssertTrue(authService.loginWasCalled)
                XCTAssertNotNil(item)
                XCTAssertEqual(item, AlertContext.unableToComplete)
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }
    
    func test_SignInViewModel_login_success() {
        // Given
        let authService = AuthServiceMock()
        authService.shouldFail = false
        
        sut = SignInViewModel(
            authService: authService,
            remoteConfigService: RemoteConfigMock()
        )
        
        // When
        sut.selected = .login
        sut.actionButtonTapped()
        
        // Then
        let expectation = XCTestExpectation(description: "Login does succeed")
        
        sut.$path
            .dropFirst()
            .sink { path in
                expectation.fulfill()
                XCTAssertTrue(authService.loginWasCalled)
                XCTAssertEqual(SignInRoute.chooseGroup, path.last)
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }
    
    func test_SignInViewModel_register_fail() {
        // Given
        let authService = AuthServiceMock()
        authService.shouldFail = true
        
        sut = SignInViewModel(
            authService: authService,
            remoteConfigService: RemoteConfigMock()
        )
        
        // When
        sut.selected = .register
        sut.actionButtonTapped()
        
        // Then
        let expectation = XCTestExpectation(description: "Register does fail")

        sut.$alertItem
            .dropFirst()
            .sink { item in
                expectation.fulfill()
                
                XCTAssertTrue(authService.registerWasCalled)
                XCTAssertNotNil(item)
                XCTAssertEqual(item, AlertContext.alreadyInUse)
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }
    
    func test_SignInViewModel_register_success() {
        // Given
        let authService = AuthServiceMock()
        authService.shouldFail = false
        
        sut = SignInViewModel(
            authService: authService,
            remoteConfigService: RemoteConfigMock()
        )
        
        // When
        sut.selected = .register
        sut.actionButtonTapped()
        
        // Then
        let expectation = XCTestExpectation(description: "Register does succeed")

        sut.$path
            .dropFirst()
            .sink { path in
                expectation.fulfill()
                
                XCTAssertTrue(authService.registerWasCalled)
                XCTAssertEqual(SignInRoute.chooseGroup, path.last)
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }
    
    func test_SignInViewModel_accentColor() {
        // Given
        let remoteConfig = RemoteConfigMock()
        sut = SignInViewModel(
            authService: AuthServiceMock(),
            remoteConfigService: remoteConfig
        )
        
        // When
        remoteConfig.appConfig = AppConfig(
            loginConfig: LoginConfig(
                facebookEnabled: true,
                googleEnabled: true,
                appleEnabled: true
            ),
            accentColor: "#d3419d"
        )
    
        // Then
        let expectedColor = remoteConfig.appConfig?.accentColor
        XCTAssertEqual(expectedColor, sut.accentColor)
    }
    
    func test_SignInViewModel_loginConfig() {
        // Given
        let remoteConfig = RemoteConfigMock()
        sut = SignInViewModel(
            authService: AuthServiceMock(),
            remoteConfigService: remoteConfig
        )
        
        // When
        remoteConfig.appConfig = AppConfig(
            loginConfig: LoginConfig(
                facebookEnabled: true,
                googleEnabled: true,
                appleEnabled: true
            ),
            accentColor: "#d3419d"
        )
        
        // Then
        let expectedLoginConfig = remoteConfig.appConfig?.loginConfig
        XCTAssertEqual(expectedLoginConfig, sut.loginConfig)
    }
    
}
