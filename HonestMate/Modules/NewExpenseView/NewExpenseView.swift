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
            //                                .foregroundColor(Color(uiColor: .systemGray))
                .fontWeight(.bold)
            TextField("Description", text: $viewModel.description, axis: .vertical)
                .lineLimit(...3)
        }
    }
    
    private var paidBy: some View {
        VStack(alignment: .leading) {
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
            .font(.title3)
        }
    }
    
    private var date: some View {
        HStack {
            Text("Date:")
                .foregroundColor(Color(uiColor: .systemGray))
                .font(.title3)
            DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
        }
    }
    
    private var amount: some View {
        HStack {
            Text("Amount: ")
                .foregroundColor(Color(uiColor: .systemGray))
            
            TextField("0", value: $viewModel.amount, formatter: NumberFormatter())
                .keyboardType(.decimalPad)
        }
        .font(.title3)
    }
    
    private var currency: some View {
        Text("Currency: PLN")
            .foregroundColor(Color(uiColor: .systemGray))
            .font(.title3)
    }
    
    private var splitBetween: some View {
        VStack(alignment: .leading) {
            Text("Split between")
                .font(.title2)
                .fontWeight(.bold)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(MockData.members) { member in
                        ReceiverView(member: member)
                    }
                }
            }
            .scrollIndicators(.never)
        }
    }
    
    private var okButton: some View {
        Button {
            
        } label: {
            RoundedTextButton(title: "OK", style: .pink)
        }
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
            .scrollIndicators(.never)
            
            okButton
        }
        .modifier(DismissingKeyboard())
        .navigationBarTitle("New expense", displayMode: .automatic)
    }
}

struct NewExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewExpenseView(viewModel: NewExpenseViewModel(expenseType: MockData.expenseType, authService: Resolver.resolve()))
        }
    }
}
