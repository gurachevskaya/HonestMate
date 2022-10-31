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
    var navigationState: NavigationStateProtocol
    
    init(
        expensesService: ExpensesServiceProtocol,
        appState: AppStateProtocol,
        groupsService: GroupsServiceProtocol,
        navigationState: NavigationStateProtocol
    ) {
        self.expensesService = expensesService
        self.appState = appState
        self.groupsService = groupsService
        self.navigationState = navigationState
        
        setupPipeline()
    }
    
    enum State: Equatable {
        case idle
        case loading
        case loaded([ExpenseModel])
    }
        
    @Published private(set) var state = State.idle

    @Published var alertItem: AlertItem?
    @Published var groupName: String = ""

    private var cancellables: Set<AnyCancellable> = []
    
    private func setupPipeline() {
        appState.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
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
            .weakAssign(to: \.groupName, on: self)
            .store(in: &cancellables)
    }
    
    private func loadHistory() {
        state = .loading
        expensesService.addListenerToExpenses(groupID: appState.groupID)
            .receive(on: DispatchQueue.main)
            .map { history in State.loaded(history) }
            .catch { [weak self] error in
                self?.alertItem = AlertContext.innerError
                return Just(State.loaded([]))
            }
            .weakAssign(to: \.state, on: self)
            .store(in: &cancellables)
    }
    
    func delete(at offsets: IndexSet) {
        var history = getHistoryModel()
        offsets.map { $0 }.forEach { index in
            deleteItem(index: index)
        }
        history.remove(atOffsets: offsets)
        state = .loaded(history)
    }
    
    private func deleteItem(index: Int) {
        var history = getHistoryModel()

        let item = history[index]
        expensesService.deleteExpense(id: item.id ?? "", groupID: appState.groupID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] subscription in
                switch subscription {
                case .finished: break
                case .failure:
                    history.insert(item, at: index)
                    self?.state = .loaded(history)
                    self?.alertItem = AlertContext.deletingError
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    private func getHistoryModel() -> [ExpenseModel] {
        switch state {
        case .loaded(let model):
            return model
        default: return []
        }
    }
}
