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
    var colourful: Bool

    var body: some View {
        VStack {
            Circle()
                .frame(width: 88, height: 88)
                .foregroundColor(colourful ? Color(hex: type.hexColor) : Color(uiColor: .systemGray))
            Text(type.name)
                .foregroundColor(.primary)
        }
    }
}

struct ExpenseTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseTypeView(type: MockData.expenseType, colourful: true)
    }
}
