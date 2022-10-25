//
//  BalanceModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 25.10.22.
//

import Foundation

struct BalanceModel: Equatable, Identifiable {
    let id = UUID()
    var member: Member
    var balance: Double
}
