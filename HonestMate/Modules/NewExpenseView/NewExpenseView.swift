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
        Form {
            Section {
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.title2)
                    //                                .foregroundColor(Color(uiColor: .systemGray))
                        .fontWeight(.bold)
                    TextField("Description", text: $viewModel.description, axis: .vertical)
                        .lineLimit(...3)
                }
                
                VStack(alignment: .leading) {
                    Text("Paid by")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(viewModel.currentUserName)
                }
            }
            
            Section {
                NavigationLink(value: Route.reselectType($viewModel.expenseType)) {
                    HStack {
                        Text("Type: ")
                            .foregroundColor(Color(uiColor: .systemGray))
                        Text("\(viewModel.expenseType.name)")
                    }
                    .font(.title3)
                }
                HStack {
                    Text("Date:")
                        .foregroundColor(Color(uiColor: .systemGray))
                        .font(.title3)
                    DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
                }
                HStack {
                    Text("Amount: ")
                        .foregroundColor(Color(uiColor: .systemGray))

                    TextField("0", value: $viewModel.amount, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                }
                .font(.title3)
                
                Text("Currency: PLN")
                    .foregroundColor(Color(uiColor: .systemGray))
                    .font(.title3)
            }
            
            Section {
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
