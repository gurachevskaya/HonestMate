//
//  ExpenseTypeView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import SwiftUI

struct ExpenseTypeView: View {
    var type: ExpenseType
    
    var body: some View {
        VStack {
            Circle()
                .frame(width: 88, height: 88)
                .foregroundColor(.yellow)
            Text(type.name)
                .foregroundColor(.primary)
        }
    }
}

struct ExpenseTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseTypeView(type: MockData.expenseTypes[0])
    }
}
