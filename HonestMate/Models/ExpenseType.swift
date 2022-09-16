//
//  ExpenseType.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import Foundation

struct ExpenseType: Identifiable {
    let id = UUID()
    let name: String
}

struct MockData {
    static let expenseTypes: [ExpenseType] = [
        ExpenseType(name: "Eating out"),
        ExpenseType(name: "Food"),
        ExpenseType(name: "Transport"),
        ExpenseType(name: "Entertainment"),
        ExpenseType(name: "Accomodation"),
        ExpenseType(name: "Other")
    ]
}
