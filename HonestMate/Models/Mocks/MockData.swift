//
//  MockData.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 16.09.22.
//

import Foundation

struct MockData {
    static let expenseType: ExpenseCategory = ExpenseCategory(id: "2", isActive: true, name: "Food", hexColor: "#dd5bd4")
    
    static let members: [Member] = [
        Member(id: "1", name: "Karina"),
        Member(id: "2", name: "Dima"),
        Member(id: "3", name: "Zhenya"),
        Member(id: "4", name: "Lopatina"),
        Member(id: "5", name: "Julia"),
        Member(id: "6", name: "Very long name for example"),
        Member(id: "7", name: "Slava")
    ]
    
    static let member = Member(id: "2", name: "Dima")
    
    static let group = [
        "2XbqvhHg94S1UAdgRFWXCQakXra2",
        "8vSUg7L0d2Xth6nGhmlwVRV9JVA2"
    ]
    
    static let currentGroupID = "5Pcoq4Yq4zwabAGmaafj"
    static let currentGroup = GroupModel(id: "5Pcoq4Yq4zwabAGmaafj", name: "Georgia", created: Date())

    static let defaultCurrency = "USD"
    
    static let historyItem = ExpenseModel(expenseType: .newExpense, category: "Food", amount: 20, date: Date(), payer: "1", between: ["1", "2"])

}
