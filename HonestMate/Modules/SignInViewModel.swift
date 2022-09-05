//
//  SignInViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 1.09.22.
//

import SwiftUI
import CoreData
import Firebase
import Resolver
import Combine

class SignInViewModel: ObservableObject {
    
    private var authService: AuthServiceProtocol = Resolver.resolve()

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
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    @Published var selected: PickerCase = .login

    private var cancellables: Set<AnyCancellable> = []
    
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
                isLoading = false
                print("completed, go to the next screen")
            }
            .store(in: &cancellables)
    }
    
}

