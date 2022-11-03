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
    private var remoteConfig: RemoteConfigServiceProtocol
    var navigationState: NavigationStateProtocol
    
    init(
        expensesService: ExpensesServiceProtocol,
        appState: AppStateProtocol,
        groupsService: GroupsServiceProtocol,
        remoteConfig: RemoteConfigServiceProtocol,
        navigationState: NavigationStateProtocol
    ) {
        self.expensesService = expensesService
        self.appState = appState
        self.groupsService = groupsService
        self.remoteConfig = remoteConfig
        self.navigationState = navigationState
        
        setupPipeline()
    }
    
    enum State: Equatable {
        case idle
        case loading
        case loaded([ExpenseModel])
    }
        
    @Published var state = State.idle

    @Published var alertItem: AlertItem?
    @Published var groupName: String = ""
    
    var colourful: Bool { remoteConfig.appConfig?.colourful ?? true }

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
        let history = getHistoryModel()
        var newHistory = history
        newHistory.remove(atOffsets: offsets)
        state = .loaded(newHistory)
        offsets.map { history[$0] }.forEach { item in
            deleteItem(item)
        }
    }
    
    private func deleteItem(_ item: ExpenseModel) {
        var history = getHistoryModel()
        expensesService.deleteExpense(id: item.id ?? "", groupID: appState.groupID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] subscription in
                switch subscription {
                case .finished: break
                case .failure:
                    history.append(item)
                    let sortedHistory = history.sorted { $0.date > $1.date }
                    self?.state = .loaded(sortedHistory)
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
