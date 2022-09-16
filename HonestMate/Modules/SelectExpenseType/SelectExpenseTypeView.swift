//
//  SelectExpenseTypeView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import SwiftUI

struct SelectExpenseTypeView: View {
    
    @ObservedObject var viewModel: SelectExpenseTypeViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: viewModel.columns, spacing: 20) {
                ForEach(MockData.expenseTypes) { type in
                    NavigationLink(value: Route.newExpense(type)) {
                        ExpenseTypeView(type: type)
                    }
                }
            }
            .navigationBarTitle("Select type of expense", displayMode: .large)
        }
        .padding(.top, 20)
    }
}

struct SelectExpenseTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectExpenseTypeView(viewModel: SelectExpenseTypeViewModel())
    }
}
