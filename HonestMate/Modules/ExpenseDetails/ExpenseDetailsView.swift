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
        VStack {
            headerView
                .frame(height: 200)
            
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.expense.expenseType == .newExpense {
                        categoryView
                    }
                    
                    dateView
                    
                    amountView
                    
                    paidByView
                    
                    if viewModel.expense.expenseType == .newExpense {
                        betweenView
                    }
                    
                    if viewModel.expense.expenseType == .directPayment {
                        receivedByView
                    }
                    
                    if let description = viewModel.expense.description {
                        descriptionView(description: description)
                    }
                    
                    Spacer()
                }
                .font(.title2)
                .padding()
            }
            .accessibilityIdentifier(Constants.AccessebilityIDs.detailsView)
            .scrollIndicators(.hidden)
            .padding(.vertical)
        }
        .toolbar {
            NavigationLink(value: HistoryRoute.editExpense($viewModel.expense)) {
                Text(R.string.localizable.expenseDetailsEditButtonTitle())
            }
        }
        .ignoresSafeArea()
    }

    private var headerView: some View {
        ZStack {
            Rectangle()
                .fill(viewModel.headerColor)
                .accessibilityIdentifier(Constants.AccessebilityIDs.headerView)
            
            VStack {
                Spacer()
                Text(viewModel.title)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.medium)
                    .padding()
            }
        }
    }
    
    private var categoryView: some View {
        DetailView(
            title: Text(R.string.localizable.expenseDetailsCategory()),
            value: Text(viewModel.expense.category?.name ?? "")
        )
    }
    
    private var dateView: some View {
        DetailView(
            title: Text(R.string.localizable.expenseDetailsDate()),
            value: Text(viewModel.expense.date, format: Date.FormatStyle().year().month().day().weekday())
        )
    }
    
    private var amountView: some View {
        DetailView(
            title: Text(R.string.localizable.expenseDetailsAmount()),
            value: Text(String(format: "%.1f", viewModel.expense.amount) + " " + MockData.defaultCurrency)
        )
    }
    
    private var paidByView: some View {
        DetailView(
            title: Text(R.string.localizable.expenseDetailsPaidBy()),
            value: Text(viewModel.expense.payer.name)
        )
    }
    
    private var betweenView: some View {
        DetailView(
            title: Text(R.string.localizable.expenseDetailsBetween()),
            value: Text(viewModel.expense.between.map {$0.name }.joined(separator: ", ")),
            withDivider: false
        )
    }
    
    private var receivedByView: some View {
        DetailView(
            title: Text(R.string.localizable.expenseDetailsReceivedBy()),
            value: Text(viewModel.expense.between.first?.name ?? ""),
            withDivider: false
        )
    }
    
    private func descriptionView(description: String) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            BasicDivider()
            Text(R.string.localizable.expenseDetailsDescription())
                .fontWeight(.medium)
            Text(description)
                .foregroundColor(.secondary)
        }
    }
}

struct ExpenseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseDetailsView(viewModel: ExpenseDetailsViewModel(
            expense: MockData.historyItem,
            remoteConfig: Resolver.resolve()
        ))
    }
}
