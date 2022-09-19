//
//  MockData.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 16.09.22.
//

import Foundation

struct MockData {
    static let expenseTypes: [ExpenseType] = [
        ExpenseType(name: "Eating out"),
        ExpenseType(name: "Food"),
        ExpenseType(name: "Transport"),
        ExpenseType(name: "Entertainment"),
        ExpenseType(name: "Accomodation"),
        ExpenseType(name: "Other")
    ]
    
    static let expenseType: ExpenseType = ExpenseType(name: "Food")
    
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
}
