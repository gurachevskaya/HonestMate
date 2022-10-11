//
//  ExpenseTypeView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import SwiftUI

public typealias Action = () -> ()

struct ExpenseTypeView: View {
    var type: ExpenseCategory

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
        ExpenseTypeView(type: MockData.expenseType)
    }
}
