//
//  MyEventsViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 5.09.22.
//

import Foundation
import Combine
import SwiftUI

enum Route: Hashable {
    case selectType
    case newExpense(ExpenseType)
    case directPayment
}

class MyEventsViewModel: ObservableObject {
    @Published var path: [Route] = []
}
