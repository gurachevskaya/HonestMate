//
//  ExpenseType.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import Foundation

struct ExpenseType: Identifiable, Hashable {
    let id = UUID()
    let name: String
}
