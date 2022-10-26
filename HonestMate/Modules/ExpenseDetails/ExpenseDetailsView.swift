//
//  ExpenseDetailsView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 25.10.22.
//

import SwiftUI
import Resolver

struct ExpenseDetailsView: View {
    
    @StateObject var viewModel: ExpenseDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(viewModel.headerColor)
                    
                    VStack {
                        Spacer()
                        Text(viewModel.title)
                            .multilineTextAlignment(.center)
                            .font(.title)
                            .fontWeight(.medium)
                            .padding()
                    }
                }
                .frame(height: 200)
                
                VStack(spacing: 20) {
                    if let category = viewModel.expense.category {
                        HStack {
                            Text("Category")
                            Spacer()
                            Text(category.name)
                        }
                        
                        Divider()
                            .background(Color.gray)
                    }
                    
                    HStack {
                        Text("Date")
                        Spacer()
                        Text(viewModel.expense.date, format: Date.FormatStyle().year().month().day().weekday())
                    }
                    
                    Divider()
                        .background(Color.gray)
                    
                    HStack {
                        Text("Amount")
                        Spacer()
                        Text(String(format: "%.1f", viewModel.expense.amount) + " USD")
                    }
                    
                    Divider()
                        .background(Color.gray)
                    
                    HStack {
                        Text("Paid by")
                        Spacer()
                        Text(viewModel.expense.payer.name)
                    }
                    
                    Divider()
                        .background(Color.gray)
                    
                    if viewModel.expense.expenseType == .newExpense {
                        HStack {
                            Text("Between")
                            Spacer()
                            Text(viewModel.expense.between.map {$0.name }.joined(separator: ", "))
                        }
                    }
                    
                    if viewModel.expense.expenseType == .directPayment {
                        HStack {
                            Text("Received by")
                            Spacer()
                            Text(viewModel.expense.between.first?.name ?? "")
                        }
                    }
                    Spacer()
                }
                .font(.title2)
                .padding()
            }
        }
        .ignoresSafeArea()
    }
}

struct ExpenseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseDetailsView(viewModel: ExpenseDetailsViewModel(expense: MockData.historyItem, remoteConfig: Resolver.resolve()))
    }
}
