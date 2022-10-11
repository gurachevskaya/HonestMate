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
    
    @Published var expenseType: ExpenseCategory
    private var authService: AuthServiceProtocol
    private var expensesService: ExpensesServiceProtocol
    private var path: Binding<[Route]>
    
    init(
        expenseType: ExpenseCategory,
        authService: AuthServiceProtocol,
        expensesService: ExpensesServiceProtocol,
        path: Binding<[Route]>
    ) {
        self.expenseType = expenseType
        self.authService = authService
        self.expensesService = expensesService
        self.path = path
        
        setupPipeline()
    }
    
    @Published var description: String = ""
    @Published var amountText: String = ""
    @Published var selectedDate = Date()
    @Published var groupMembers: [Member] = []
    @Published var recievers: [Member] = []
    
    @Published var amountFieldColor: Color = .primary
    @Published var okButtonEnabled: Bool = false
    
    @Published var alertItem: AlertItem?

    var currentUserName: String { authService.currentUser?.displayName ?? "name"}
    private var currentUserID: String? { authService.currentUser?.uid }
    
    private var cancellables = Set<AnyCancellable>()
    
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
    
    private func popToRootView() {
        UIApplication.shared.addBackAnimation()
        path.wrappedValue = []
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
    
    func loadGroupMembers() {
        expensesService.getGroupMembers(groupID: MockData.currentGroup)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] subscription in
                switch subscription {
                case .finished: break
                case .failure(let error):
                    // TODO: map error
                    self?.alertItem = AlertContext.innerError
                }
            } receiveValue: { [weak self] members in
                self?.groupMembers = members
            }
            .store(in: &cancellables)
    }
    
    func addExpense() {
        guard
            let amount = Double(amountText),
            let payerID = currentUserID
        else {
            return
        }
  
        let expenseModel = ExpenseModel(
            amount: amount,
            description: description,
            date: selectedDate,
            category: expenseType.name,
            payerID: payerID,
            between: recievers.compactMap { $0.id }
        )
        
        expensesService.createExpense(groupID: MockData.currentGroup, expense: expenseModel)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] subscription in
                switch subscription {
                case .finished:
                    popToRootView()
                    
                case .failure(let error):
                    // TODO: map error
                    alertItem = AlertContext.innerError
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
