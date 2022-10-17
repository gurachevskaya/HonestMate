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
        
    @Published var history: [ExpenseModel] = []
    @Published var groupName: String = ""

    private var cancellables: Set<AnyCancellable> = []
    
    private func setupPipeline() {
        appState.objectWillChange
            .sink { [unowned self] _ in
                objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func loadGroupName() {
        groupsService.getGroup(groupID: appState.groupID)
            .receive(on: DispatchQueue.main)
            .map { $0.name }
            .replaceError(with: "")
            .assign(to: \.groupName, on: self)
            .store(in: &cancellables)
    }
    
    func loadHistory() {
        expensesService.addListenerToExpenses(groupID: appState.groupID)
            .receive(on: DispatchQueue.main)
            .sink { subscription in
                print(subscription)
            } receiveValue: { [weak self] model in
                print(model)
                self?.history = model
            }
            .store(in: &cancellables)
    }
    
    func delete(at offsets: IndexSet) {
        offsets.map { history[$0] }.forEach { item in
            deleteItem(
                id: item.id ?? "",
                groupID: appState.groupID
            )
        }
        history.remove(atOffsets: offsets)
    }
    
    private func deleteItem(id: String, groupID: String) {
        expensesService.deleteExpense(id: id, groupID: groupID)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
