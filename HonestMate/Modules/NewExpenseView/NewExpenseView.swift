//
//  NewExpenseView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 16.09.22.
//

import SwiftUI
import Resolver
import Combine

struct NewExpenseView: View {

    @StateObject var viewModel: NewExpenseViewModel
    
    var body: some View {
        VStack {
            Form {
                Section {
                    description
                    paidBy
                }
                
                Section {
                    if viewModel.shouldShowExpenseCategory {
                        expenseCategory
                    }
                    date
                    amount
                    currency
                }
                
                Section {
                    splitBetween
                }
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.never)
            
            okButton
        }
        .onAppear {
            viewModel.loadGroupMembers()
        }
        .background(Color(uiColor: .systemGray6))
        .navigationBarTitle(viewModel.screenTitle, displayMode: .large)
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        }
    }
    
    private var description: some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.newExpenseDescriptionTitle())
                .font(.title2)
                .fontWeight(.bold)
            TextField(R.string.localizable.newExpenseDescriptionPlaceholder(), text: $viewModel.description, axis: .vertical)
                .lineLimit(...3)
        }
    }
    
    private var paidBy: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(R.string.localizable.newExpensePaidByTitle())
                .font(.title2)
                .fontWeight(.bold)
            NavigationLink(value: HomeRoute.selectPayer($viewModel.payer, viewModel.groupMembers)) {
                Text(viewModel.payer?.name ?? "")
            }
        }
    }
    
    private var expenseCategory: some View {
        NavigationLink(value: HomeRoute.reselectType($viewModel.expenseCategory)) {
            HStack {
                Text(R.string.localizable.newExpenseType())
                    .foregroundColor(Color(uiColor: .systemGray))
                Text("\(viewModel.expenseCategory?.name ?? "")")
            }
            .font(.subheadline)
        }
    }
    
    private var date: some View {
        HStack {
            Text(R.string.localizable.newExpenseDate())
                .foregroundColor(Color(uiColor: .systemGray))
                .font(.subheadline)
            DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
        }
    }
    
    private var amount: some View {
        HStack {
            Text(R.string.localizable.newExpenseAmount())
                .foregroundColor(Color(uiColor: .systemGray))
            
            TextField("", text: $viewModel.amountText)
                .keyboardType(.decimalPad)
                .foregroundColor(viewModel.amountFieldColor)
        }
        .font(.subheadline)
    }
    
    private var currency: some View {
        HStack {
            Text(R.string.localizable.newExpenseCurrency())
                .foregroundColor(Color(uiColor: .systemGray))
            Text(MockData.defaultCurrency)
        }
        .font(.subheadline)
    }
    
    private var splitBetween: some View {
        VStack(alignment: .leading) {
            Text(viewModel.splitBetweenTitle)
                .font(.title2)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.groupMembers) { member in
                        ReceiverView(
                            isSelected: .constant(viewModel.isSelectedReceiver(member)),
                            member: member
                        )
                        .onTapGesture {
                            viewModel.toggleSelection(selectable: member)
                        }
                    }
                }
            }
        }
    }
   
    private var okButton: some View {
        Button {
            viewModel.okButtonTapped()
        } label: {
            RoundedTextButton(
                title: R.string.localizable.newExpenseAddExpenseButtonTitle(),
                style: .filled(.pink)
            )
        }
        .disabled(!viewModel.okButtonEnabled)
        .padding()
    }
}

struct NewExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewExpenseView(viewModel: NewExpenseViewModel(
                expense: nil,
                expenseCategory: MockData.expenseType,
                expenseType: .newExpense,
                authService: Resolver.resolve(),
                expensesService: Resolver.resolve(),
                appState: Resolver.resolve(),
                navigationState: Resolver.resolve()
            ))
        }
    }
}
