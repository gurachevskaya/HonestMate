//
//  MockData.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 16.09.22.
//

import Foundation

struct MockData {
    static let userInfo: UserInfoModel = UserInfoModel(id: "1", groups: groups)
    static let expenseType: ExpenseCategory = ExpenseCategory(id: "2", isActive: true, name: "Food", hexColor: "#dd5bd4")
    
    static let members: [MemberModel] = [
        MemberModel(id: "1", name: "Karina"),
        MemberModel(id: "2", name: "Dima"),
        MemberModel(id: "3", name: "Zhenya"),
        MemberModel(id: "4", name: "Lopatina"),
        MemberModel(id: "5", name: "Julia"),
        MemberModel(id: "6", name: "Very long name for example"),
        MemberModel(id: "7", name: "Slava")
    ]
    
    static let member = Member(id: "2", name: "Dima")
    static let memberModel = MemberModel(id: "2", name: "Dima")

    static let groups = [
        "2XbqvhHg94S1UAdgRFWXCQakXra2",
        "8vSUg7L0d2Xth6nGhmlwVRV9JVA2",
        "1"
    ]
    
    static let currentGroupID = "5Pcoq4Yq4zwabAGmaafj"
    static let currentGroup = GroupModel(id: "5Pcoq4Yq4zwabAGmaafj", name: "Georgia", created: Date())
    static let groupModels = [
        GroupModel(id: "5Pcoq4Yq4zwabAGmaafj", name: "Georgia", created: Date()),
        GroupModel(id: "1", name: "Georgia", created: Date())
    ]

    static let defaultCurrency = "USD"
    
    static let historyItem = ExpenseModel(expenseType: .newExpense, category: MockData.expenseType, amount: 20, date: Date(), payer: MockData.member, between: [Member(id: "1", name: "Karina"), Member(id: "1", name: "Arina")])
    
    static let historyMock = [
        ExpenseModel(expenseType: .newExpense, category: MockData.expenseType, amount: 20, date: Date(), payer: MockData.member, between: [Member(id: "1", name: "Karina"), Member(id: "1", name: "Arina")]),
        ExpenseModel(expenseType: .directPayment, category: nil, amount: 20, date: Date(), payer: MockData.member, between: [Member(id: "1", name: "Karina"), Member(id: "1", name: "Arina")]),
        ExpenseModel(expenseType: .newExpense, description: "description", category: MockData.expenseType, amount: 30, date: Date(), payer: MockData.member, between: [Member(id: "1", name: "Karina"), Member(id: "1", name: "Arina")])
    ]
    
    static let balanceModel = BalanceModel(member: MockData.member, balance: 20)
}
