//
//  HistoryViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 11.10.22.
//

import Foundation

class HistoryViewModel: ObservableObject {
    @Published var history: [HistoryItemModel] = MockData.history
}
