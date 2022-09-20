//
//  NewExpenseViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 16.09.22.
//

import Foundation
import SwiftUI
import Combine

class NewExpenseViewModel: ObservableObject {
    
    @Published var expenseType: ExpenseType
    var authService: AuthServiceProtocol
    
    init(
        expenseType: ExpenseType,
        authService: AuthServiceProtocol
    ) {
        self.expenseType = expenseType
        self.authService = authService
        
        setupPipeline()
    }
    
    @Published var description: String = ""
    @Published var amountText: String = ""
    @Published var amount: Double?
    @Published var selectedDate = Date()
    @Published var recievers: [Member] = []
    
    @Published var amountFieldColor: Color = .primary
    @Published var okButtonEnabled: Bool = false

    var currentUserName: String { authService.currentUser?.displayName ?? "name"}
    
    private func setupPipeline() {
        configureAmountTextFieldBehavior()
        configureOkButtonBehavior()
    }
    
    private func configureAmountTextFieldBehavior() {
        validAmountPublisher
            .map { isValid -> Color in
                isValid ? .primary : .red
            }
            .eraseToAnyPublisher()
            .assign(to: &$amountFieldColor)
    }
    
    private func configureOkButtonBehavior() {
        formIsValid.assign(to: &$okButtonEnabled)
    }
   
    private var validAmountPublisher: AnyPublisher<Bool, Never> {
        $amountText
            .map {
                if let _ = Double($0) {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var receiversSelectedPublisher: AnyPublisher<Bool, Never> {
        $recievers
            .map {
                !$0.isEmpty
            }
            .eraseToAnyPublisher()
    }
    
    private var formIsValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(
            validAmountPublisher, receiversSelectedPublisher
        ).map { amount, recievers in
            amount && recievers
        }
        .eraseToAnyPublisher()
    }
    
    
    func toggleSelection(selectable: Member) {
        if let existingIndex = recievers.firstIndex(where: { $0 == selectable }) {
            recievers.remove(at: existingIndex)
        } else {
            recievers.append(selectable)
        }
    }
    
    func isSelectedReceiver(_ member: Member) -> Bool {
        recievers.contains(member)
    }
    
    func addExpense() {
        
    }
}
