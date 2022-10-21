//
//  HistoryItemView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 11.10.22.
//

import SwiftUI

struct HistoryItemView: View {
    var historyItem: ExpenseModel
    
    @State var showMembers: Bool = false
    
    private var membersString: String {
        historyItem.between.joined(separator: ", ")
    }
    
    private var expenseTitle: String {
        let type = historyItem.expenseType
        switch type {
        case .newExpense:
            return historyItem.description?.capitalized ?? (historyItem.category?.name ?? "")
        case .directPayment:
            return R.string.localizable.historyExpenseTitleDirectPayment()
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(expenseTitle)
                if historyItem.expenseType == .newExpense {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(hex: historyItem.category?.hexColor ?? "#FC6DAB"))
                }
                Spacer()
                Text(String(format: "%.2f", historyItem.amount))
                Text(MockData.defaultCurrency)
            }
            .font(.title3)
            
            VStack(alignment: .leading) {
                Text(R.string.localizable.historyDateTitle() + " ") +
                     Text(historyItem.date, format: Date.FormatStyle().year().month().day().weekday())
                
                Text(R.string.localizable.historyPaidByTitle() + " \(historyItem.payer)")
                
                if historyItem.expenseType == .newExpense {
                    newExpense
                }
                if historyItem.expenseType == .directPayment {
                    directPayment
                }

                if showMembers {
                    Text(membersString)
                }
            }
            .foregroundColor(.gray)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
    }
    
    var newExpense: some View {
        HStack {
            Text(R.string.localizable.historyShareBetweenTitle(historyItem.between.count))
            
            Text(showMembers ? R.string.localizable.historyHideAll() : R.string.localizable.historySeeAll())
                .foregroundColor(.blue)
                .fontWeight(.bold)
                .padding(.leading, 4)
                .onTapGesture {
                    showMembers.toggle()
                }
                .animation(.none)
        }
    }
    
    var directPayment: some View {
        Text(R.string.localizable.historyReceivedByTitle() + " \(historyItem.between.first ?? "")")
    }
}

struct HistoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryItemView(historyItem: MockData.historyItem)
    }
}
