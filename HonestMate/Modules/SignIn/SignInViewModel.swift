//
//  SignInViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 1.09.22.
//

import SwiftUI
import CoreData
import Firebase
import Combine

class SignInViewModel: ObservableObject {
    
    init(authService: AuthServiceProtocol, remoteConfigService: RemoteConfigServiceProtocol) {
        self.authService = authService
        self.remoteConfigService = remoteConfigService
        
        setupPipeline()
    }
    
    private var authService: AuthServiceProtocol
    private var remoteConfigService: RemoteConfigServiceProtocol
    
    var loginConfig: LoginConfig? { remoteConfigService.appConfig?.loginConfig }
    var accentColor: Color {
        remoteConfigService.appConfig?.colourful == true ? Color(hex: remoteConfigService.appConfig?.accentColor ?? "") : Color(uiColor: .systemBlue)
    }
    
    @Published var path: [SignInRoute] = []
    
    enum SignInOption {
        case facebook, apple, google, mail
    }
    
    enum PickerCase: Equatable, CaseIterable {
        case login
        case register
        
        var title: String {
            switch self {
            case .login:
                return R.string.localizable.signinPickerLogin()
            case .register:
                return R.string.localizable.signinPickerRegister()
            }
        }
    }
    
    @Published var email = EnvironmentConstants.isDebug ? "gurachevich@mail.ru" : ""
    @Published var password = EnvironmentConstants.isDebug ? "123456aa" : ""
    @Published var confirmPassword = ""
    @Published var agreeTerms = true
    @Published var actionButtonEnabled = false
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    @Published var selected: PickerCase = .login
    
    private var cancellables: Set<AnyCancellable> = []
    
    private func setupPipeline() {
        configureSignUpButtonBehavior()
    }
    
    private func configureSignUpButtonBehavior() {
        isValidFormPublisher.assign(to: &$actionButtonEnabled)
    }
    
    func actionButtonTapped() {
        switch selected {
        case .login:
            login()
        case .register:
            register()
        }
    }
    
    private func register() {
        isLoading = true
        authService.createUser(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                isLoading = false
                
                switch completion {
                case .failure(let error):
                    alertItem = alertItem(for: error)
                case .finished:
                    path.append(.chooseGroup)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    private func login() {
        isLoading = true
        authService.signin(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                isLoading = false
                
                switch completion {
                case .failure(let error):
                    alertItem = alertItem(for: error)
                case .finished:
                    path.append(.chooseGroup)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    private func alertItem(for error: AuthError) -> AlertItem {
        switch error {
        case .networkError:
            return AlertContext.unableToComplete
        case .alreadyInUse:
            return AlertContext.alreadyInUse
        case .userNotFound:
            return AlertContext.userNotFound
        case .invalidEmail:
            return AlertContext.invalidEmail
        case .wrongPassword:
            return AlertContext.wrondPassword
        case .userDisabled:
            return AlertContext.userDisabled
        case .inner:
            return AlertContext.innerError
        }
    }
}

// MARK: Validation

extension SignInViewModel {
    private var isValidFormPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(
            isValidLoginFormPublisher, isValidRegisterFormPublisher
        ).map { validLogin, validRegister in
            validLogin || validRegister
        }
        .eraseToAnyPublisher()
    }
    
    private var isValidRegisterFormPublisher: AnyPublisher<Bool, Never> {
        let publisher = Publishers.CombineLatest4(
            validEmailAddress, validAndConfirmedPassword, $agreeTerms, $selected
        ).map { email, validAndConfirmedPassword, terms, selected in
            email && validAndConfirmedPassword && terms && selected == .register
        }
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    private var isValidLoginFormPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(
            validEmailAddress, validPassword, $agreeTerms, $selected
        ).map { email, validPassword, terms, selected in
            email && validPassword && terms && selected == .login
        }
        .eraseToAnyPublisher()
    }
    
    private var passwordMatchesConfirmation: AnyPublisher<Bool, Never> {
        $password.combineLatest($confirmPassword)
            .map { pass, confirm in
                pass == confirm
            }
            .eraseToAnyPublisher()
    }
    
    private var validPassword: AnyPublisher<Bool, Never> {
        $password
            .map { [unowned self] in
                isValidPassword($0)
            }
            .eraseToAnyPublisher()
    }
    
    private var validAndConfirmedPassword: AnyPublisher<Bool, Never> {
        validPassword.combineLatest(passwordMatchesConfirmation)
            .map { $0.0 && $0.1}
            .eraseToAnyPublisher()
    }
    
    private var validEmailAddress: AnyPublisher<Bool, Never> {
        $email
            .map { [unowned self] in
                isValidEmailAddress($0)
            }
            .eraseToAnyPublisher()
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        // Minimum 8 characters at least 1 Alphabet and 1 Number
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    private func isValidEmailAddress(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

