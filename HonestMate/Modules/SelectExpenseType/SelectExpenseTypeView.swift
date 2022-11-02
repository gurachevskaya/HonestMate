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
        content
            .navigationBarTitle(R.string.localizable.selectExpenseTypeTitle(), displayMode: .large)
            .onAppear {
                viewModel.getExpenseCategories()
            }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return ProgressView().scaleEffect(2).eraseToAnyView()
        case .error(let error):
            return errorView(error).eraseToAnyView()
        case .loaded(let model):
            return categories(model: model).eraseToAnyView()
        }
    }
    
    private func categories(model: [ExpenseCategory]) -> some View {
        ScrollView {
            LazyVGrid(columns: viewModel.columns, spacing: 20) {
                ForEach(model) { type in
                    switch viewModel.type {
                    case .select:
                        NavigationLink(value: HomeRoute.newExpense(type)) {
                            ExpenseTypeView(
                                type: type,
                                colourful: viewModel.colourful
                            )
                        }
                    case .reselect:
                        ExpenseTypeView(
                            type: type,
                            colourful: viewModel.colourful
                        )
                        .onTapGesture {
                            viewModel.expenseCategory?.wrappedValue = type
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
        .padding(.top, 20)
    }
    
    private func errorView(_ error: String) -> some View {
        Text(error)
            .foregroundColor(.secondary)
    }
}

struct SelectExpenseTypeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SelectExpenseTypeView(viewModel: SelectExpenseTypeViewModel(
                type: .select,
                expenseCategory: .constant(MockData.expenseType),
                expensesService: Resolver.resolve(),
                remoteConfig: Resolver.resolve())
            )
        }
    }
}
