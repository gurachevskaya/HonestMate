//
//  SelectExpenseTypeView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import SwiftUI
import Resolver

struct SelectExpenseTypeView: View {
    
    @StateObject var viewModel: SelectExpenseTypeViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ScrollView {
            LazyVGrid(columns: viewModel.columns, spacing: 20) {
                ForEach(viewModel.expenseTypes) { type in
                    switch viewModel.type {
                    case .select:
                        NavigationLink(value: HomeRoute.newExpense(type)) {
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
            .navigationBarTitle(R.string.localizable.selectExpenseTypeTitle(), displayMode: .large)
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        }
        .onAppear {
            viewModel.getExpenseCategories()
        }
        .padding(.top, 20)
    }
}

struct SelectExpenseTypeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SelectExpenseTypeView(viewModel: SelectExpenseTypeViewModel(
                type: .select,
                expenseType: .constant(MockData.expenseType),
                expensesService: Resolver.resolve())
            )
        }
    }
}
