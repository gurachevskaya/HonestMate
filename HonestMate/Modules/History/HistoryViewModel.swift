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
    
    init(
        expensesService: ExpensesServiceProtocol
    ) {
        self.expensesService = expensesService
    }
        
    @Published var history: [ExpenseModel] = []
    private var groupID: String = MockData.currentGroup

    private var cancellables: Set<AnyCancellable> = []
    
    func loadHistory() {
        expensesService.addListenerToExpenses(groupID: groupID)
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
            deleteItem(id: item.id ?? "", groupID: groupID)
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
