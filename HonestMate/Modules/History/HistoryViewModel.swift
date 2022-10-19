//
//  HistoryViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 11.10.22.
//

import Foundation
import Combine

class HistoryViewModel: ObservableObject {
    
    private var expensesService: ExpensesServiceProtocol
    private var appState: AppStateProtocol
    private var groupsService: GroupsServiceProtocol
    
    init(
        expensesService: ExpensesServiceProtocol,
        appState: AppStateProtocol,
        groupsService: GroupsServiceProtocol
    ) {
        self.expensesService = expensesService
        self.appState = appState
        self.groupsService = groupsService
        
        setupPipeline()
    }
    
    enum State {
        case idle
        case loading
        case loaded
        case error
    }
        
    @Published private(set) var state = State.idle

    @Published var history: [ExpenseModel] = []
    @Published var alertItem: AlertItem?
    @Published var groupName: String = ""

    private var cancellables: Set<AnyCancellable> = []
    
    private func setupPipeline() {
        appState.objectWillChange
            .sink { [unowned self] _ in
                objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func loadData() {
        loadGroupName()
        loadHistory()
    }
    
    private func loadGroupName() {
        groupsService.getGroup(groupID: appState.groupID)
            .receive(on: DispatchQueue.main)
            .map { $0.name }
            .replaceError(with: "")
            .assign(to: \.groupName, on: self)
            .store(in: &cancellables)
    }
    
    private func loadHistory() {
        state = .loading
        expensesService.addListenerToExpenses(groupID: appState.groupID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] subscription in
                switch subscription {
                case .finished: break
                case .failure:
                    self?.alertItem = AlertContext.innerError
                    self?.state = .error
                }
            } receiveValue: { [weak self] model in
                self?.history = model
                self?.state = .loaded
            }
            .store(in: &cancellables)
    }
    
    func delete(at offsets: IndexSet) {
        offsets.map { $0 }.forEach { index in
            deleteItem(index: index)
        }
        history.remove(atOffsets: offsets)
    }
    
    private func deleteItem(index: Int) {
        let item = history[index]
        expensesService.deleteExpense(id: item.id ?? "", groupID: appState.groupID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] subscription in
                switch subscription {
                case .finished: break
                case .failure:
                    self?.history.insert(item, at: index)
                    self?.alertItem = AlertContext.deletingError
                    self?.state = .error
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
