//
//  ExpenseModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 7.10.22.
//

import Foundation
import FirebaseFirestoreSwift

struct ExpenseModel: Identifiable, Hashable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var expenseType: ExpenseType? = .newExpense
    var description: String?
    var category: String?
    var amount: Double
    var date: Date
    var payer: UserName
    var between: [UserName]
}
