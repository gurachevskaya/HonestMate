//
//  SelectExpenseTypeViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import Foundation
import Combine
import SwiftUI

class SelectExpenseTypeViewModel: ObservableObject {
    
    enum ScreenType {
        case select
        case reselect
    }
        
    var expenseTypes: [ExpenseType] = MockData.expenseTypes
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
       
    var type: ScreenType
    
    init(type: ScreenType) {
        self.type = type
    }
    
}
