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
    var expenseType: ExpenseType
    var description: String?
    var category: ExpenseCategory?
    var amount: Double
    var date: Date
    var payer: Member
    var between: [Member]
}

struct Member: Codable, Hashable {
    let id: String
    let name: String
}
