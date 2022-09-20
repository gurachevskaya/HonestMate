//
//  Route.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 16.09.22.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case selectType
    case reselectType(Binding<ExpenseType>)
    case newExpense(ExpenseType)
    case directPayment
}

