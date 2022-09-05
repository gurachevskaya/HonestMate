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
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
        
        setupPipeline()
        
        if authService.currentUser != nil {
            isShowingMyEvents = true
        }
    }
    
    private var authService: AuthServiceProtocol
    
    enum SignInRoute {
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
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var agreeTerms = true
    @Published var actionButtonEnabled = false
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    @Published var selected: PickerCase = .login
    @Published var isShowingMyEvents = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    private func setupPipeline() {
        configureSignUpButtonBehavior()
    }
    
    private func configureSignUpButtonBehavior() {
        isValidFormPublisher.assign(to: &$actionButtonEnabled)
    }
    
    func login() {
        isLoading = true
        authService.signin(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                isLoading = false
                
                switch completion {
                case .failure(let error):
                    alertItem = AlertContext.innerError
                    print("completed with error \(error)")
                case .finished:
                    print("finished")
                }
            } receiveValue: { [unowned self] _ in
                isShowingMyEvents = true
                print("completed, go to the next screen")
            }
            .store(in: &cancellables)
    }
}

// MARK: Validation

extension SignInViewModel {
    private var isValidFormPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(
            validEmailAddress, selected == .login ? validPassword : validAndConfirmedPassword, $agreeTerms
        ).map { email, pw, terms in
            email && pw && terms
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

