//
//  SelectExpenseTypeView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import SwiftUI

struct SelectExpenseTypeView: View {
    
    @ObservedObject var viewModel: SelectExpenseTypeViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ScrollView {
            LazyVGrid(columns: viewModel.columns, spacing: 20) {
                ForEach(MockData.expenseTypes) { type in
                    switch viewModel.type {
                    case .select:
                        NavigationLink(value: Route.newExpense(type)) {
                            ExpenseTypeView(type: type)
                        }
                    case .reselect:
                        ExpenseTypeView(type: type)
                            .onTapGesture {
                                viewModel.expenseType?.wrappedValue = type
                                presentationMode.wrappedValue.dismiss()
                            }
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
        NavigationStack {
            SelectExpenseTypeView(viewModel: SelectExpenseTypeViewModel(type: .select, expenseType: .constant(MockData.expenseType)))
        }
    }
}
