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
    
    init(expensesService: ExpensesServiceProtocol) {
        self.expensesService = expensesService
    }
    
    @Published var history: [HistoryItemModel] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    func loadHistory() {
        expensesService.addListenerToExpenses(groupID: MockData.currentGroup)
            .receive(on: DispatchQueue.main)
            .sink { subscription in
                print(subscription)
            } receiveValue: { [weak self] model in
                print(model)
                self?.history = model
            }
            .store(in: &cancellables)
    }
}
