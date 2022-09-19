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
    
    @ObservedObject var viewModel: NewExpenseViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text("Description")
                        .font(.title)
                    TextField("Description", text: $viewModel.description, axis: .vertical)
                        .lineLimit(...3)
                        .modifier(TextFieldCustomRoundStyle()) // ?
                    
                    Text("Paid by")
                        .font(.title)
                    Text(viewModel.currentUserName)
                        .modifier(TextFieldCustomRoundStyle())
                }
                
                Group {
                    NavigationLink(value: Route.reselectType.self) {
                        HStack {
                            Text("Type: ")
                            Text("\(viewModel.expenseType.name)")
                        }
                        .font(.title)
                    }
                    HStack {
                        Text("Date:")
                            .font(.title)
                        DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
                    }
                    HStack {
                        Text("Amount: ")
                        TextField("Amount", value: $viewModel.amount, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                    }
                    .font(.title)
                    
                    Text("Currency: PLN")
                        .font(.title)
                }
                
                Spacer()
                
                Group {
                    Text("Split between")
                        .font(.title)
                    
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
        .padding()
    }
}

struct NewExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewExpenseView(viewModel: NewExpenseViewModel(expenseType: MockData.expenseType, authService: Resolver.resolve()))
        }
    }
}
