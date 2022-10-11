//
//  ExpenseModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 7.10.22.
//

import Foundation

typealias UserIdentifier = String

struct ExpenseModel: Codable {
    let amount: Double
    let description: String?
    let date: Date
    let categoryID: String
    let payerID: String
    let between: [UserIdentifier]
}
