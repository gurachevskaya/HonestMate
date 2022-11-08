//
//  NewExpenseViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 16.09.22.
//

import Foundation
import SwiftUI
import Combine
import Resolver

class NewExpenseViewModel: ObservableObject {
    
    private var expense: Binding<ExpenseModel>?
    @Published var expenseCategory: ExpenseCategory?
    private var expenseType: ExpenseType
    private var authService: AuthServiceProtocol
    private var expensesService: ExpensesServiceProtocol
    private var appState: AppStateProtocol
    var navigationState: NavigationStateProtocol
    
    init(
        expense: Binding<ExpenseModel>?,
        expenseCategory: ExpenseCategory?,
        expenseType: ExpenseType,
        authService: AuthServiceProtocol,
        expensesService: ExpensesServiceProtocol,
        appState: AppStateProtocol,
        navigationState: NavigationStateProtocol
    ) {
        self.expense = expense
        self.expenseCategory = expenseCategory
        self.expenseType = expenseType
        self.authService = authService
        self.expensesService = expensesService
        self.appState = appState
        self.navigationState = navigationState
                        
        setupPipeline()
        setupInitialStateIfNeeded()
    }
            
    @Published var description: String = ""
    @Published var amountText: String = ""
    @Published var selectedDate = Date()
    @Published var payer: MemberModel?
    @Published var groupMembers: [MemberModel] = []
    @Published var recievers: [MemberModel] = []
    
    @Published var amountFieldColor: Color = .primary
    @Published var okButtonEnabled: Bool = false
    
    @Published var alertItem: AlertItem?

    private var currentUserID: String? { authService.currentUser?.uid }
    private var isEditMode: Bool { expense != nil }
    
    var screenTitle: String {
        switch expenseType {
        case .newExpense:
            if isEditMode {
                return R.string.localizable.newExpenseAddExpenseEditExpenseTitle()
            } else {
                return R.string.localizable.newExpenseTitle()
            }
        case .directPayment:
            if isEditMode {
                return R.string.localizable.newExpenseAddExpenseEditPaymentTitle()
            } else {
                return R.string.localizable.directPaymentTitle()
            }
        }
    }
    var splitBetweenTitle: String {
        expenseType == .newExpense ? R.string.localizable.newExpenseSplitBetweenTitle() : R.string.localizable.directPaymentReceivedBy()
    }
    var shouldShowExpenseCategory: Bool {
        expenseType == .newExpense
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func setupPipeline() {
        configureAmountTextFieldBehavior()
        configureOkButtonBehavior()
    }
    
    private func setupInitialStateIfNeeded() {
        guard let expense = expense else { return }
        
        description = expense.wrappedValue.description ?? ""
        amountText = "\(expense.wrappedValue.amount)"
        selectedDate = expense.wrappedValue.date
        payer = MemberModel(id: expense.wrappedValue.payer.id, name: expense.wrappedValue.payer.name)
        recievers = expense.wrappedValue.between.map { MemberModel(id: $0.id, name: $0.name) }
        expenseCategory = expense.wrappedValue.category
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
            .map { Double($0) != nil }
            .eraseToAnyPublisher()
    }
    
    private var receiversSelectedPublisher: AnyPublisher<Bool, Never> {
        $recievers
            .map { !$0.isEmpty }
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
        navigationState.homePath = NavigationPath()
    }
    
    func okButtonTapped() {
        if isEditMode {
            editExpense()
        } else {
            addExpense()
        }
    }
    
    func toggleSelection(selectable: MemberModel) {
        switch expenseType {
        case .newExpense:
            if let existingIndex = recievers.firstIndex(where: { $0 == selectable }) {
                recievers.remove(at: existingIndex)
            } else {
                recievers.append(selectable)
            }
        case .directPayment:
            if let existingIndex = recievers.firstIndex(where: { $0 == selectable }) {
                recievers.remove(at: existingIndex)
            } else {
                recievers = [selectable]
            }
        }
    }
    
    func isSelectedReceiver(_ member: MemberModel) -> Bool {
        recievers.contains(member)
    }
    
    func loadGroupMembers() {
        expensesService.getGroupMembers(groupID: appState.groupID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] subscription in
                if case .failure = subscription {
                    self?.alertItem = AlertContext.innerError
                }
                
            } receiveValue: { [weak self] members in
                guard let self else { return }
                if self.payer == nil {
                    self.payer = members.first(where: { $0.id == self.currentUserID })
                }
                switch self.expenseType {
                case .newExpense:
                    self.groupMembers = members
                case .directPayment:
                    self.groupMembers = members.filter { $0.id != self.currentUserID }
                }
            }
            .store(in: &cancellables)
    }
    
    func editExpense() {
        guard let expenseModel = currentExpenseModel(id: expense?.id) else { return }
        
        expensesService.editExpense(groupID: appState.groupID, expense: expenseModel)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] subscription in
                switch subscription {
                case .finished:
                    self?.expense?.wrappedValue = expenseModel
                    // TODO: pop view controller
                    UIApplication.shared.addBackAnimation()
                    self?.navigationState.historyPath.removeLast()
                    
                case .failure:
                    self?.alertItem = AlertContext.innerError
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func addExpense() {
        guard let expenseModel = currentExpenseModel(id: nil) else { return }
            
        expensesService.createExpense(groupID: appState.groupID, expense: expenseModel)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] subscription in
                switch subscription {
                case .finished:
                    self?.popToRootView()
                    
                case .failure:
                    self?.alertItem = AlertContext.innerError
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    private func currentExpenseModel(id: String?) -> ExpenseModel? {
        guard
            let amount = Double(amountText),
            let payer = self.payer
        else {
            return nil
        }
        
        let expenseModel = ExpenseModel(
            id: id,
            expenseType: expenseType,
            description: description.isEmpty ? nil : description,
            category: expenseCategory == nil ? nil : expenseCategory,
            amount: amount,
            date: selectedDate,
            payer: Member(id: payer.id ?? "", name: payer.name),
            between: recievers.map { Member(id: $0.id ?? "", name: $0.name) }
        )
        
        return expenseModel
    }
}
