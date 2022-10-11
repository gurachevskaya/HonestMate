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

    private var description: some View {
        VStack(alignment: .leading) {
            Text("Description")
                .font(.title2)
                .fontWeight(.bold)
            TextField("Description", text: $viewModel.description, axis: .vertical)
                .lineLimit(...3)
        }
    }
    
    private var paidBy: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Paid by")
                .font(.title2)
                .fontWeight(.bold)
            Text(viewModel.currentUserName)
        }
    }
    
    private var expenseType: some View {
        NavigationLink(value: Route.reselectType($viewModel.expenseType)) {
            HStack {
                Text("Type: ")
                    .foregroundColor(Color(uiColor: .systemGray))
                Text("\(viewModel.expenseType.name)")
            }
            .font(.subheadline)
        }
    }
    
    private var date: some View {
        HStack {
            Text("Date:")
                .foregroundColor(Color(uiColor: .systemGray))
                .font(.subheadline)
            DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
        }
    }
    
    private var amount: some View {
        HStack {
            Text("Amount: ")
                .foregroundColor(Color(uiColor: .systemGray))
            
            TextField("", text: $viewModel.amountText)
                .keyboardType(.decimalPad)
                .foregroundColor(viewModel.amountFieldColor)
        }
        .font(.subheadline)
    }
    
    private var currency: some View {
        HStack {
            Text("Currency: ")
                .foregroundColor(Color(uiColor: .systemGray))
            Text("PLN")
        }
        .font(.subheadline)
    }
    
    private var splitBetween: some View {
        VStack(alignment: .leading) {
            Text("Split between")
                .font(.title2)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(MockData.members) { member in
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
            viewModel.addExpense()
        } label: {
            RoundedTextButton(title: "OK", style: .pink)
        }
        .disabled(!viewModel.okButtonEnabled)
        .padding()
    }
        
    var body: some View {
        VStack {
            Form {
                Section {
                    description
                    paidBy
                }
                
                Section {
                    expenseType
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
        .background(Color(uiColor: .systemGray6))
        .navigationBarTitle("New expense", displayMode: .automatic)
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        }
    }
}

struct NewExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewExpenseView(viewModel: NewExpenseViewModel(
                expenseType: MockData.expenseType,
                authService: Resolver.resolve(),
                expensesService: Resolver.resolve(),
                path: .constant([])
            ))
        }
    }
}
