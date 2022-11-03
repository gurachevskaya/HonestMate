//
//  HistoryItemView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 11.10.22.
//

import SwiftUI

struct HistoryItemView: View {
    var historyItem: ExpenseModel
    var colourful: Bool
    
    @State var showMembers: Bool = false
    
    private var membersString: String {
        historyItem.between.map { $0.name }.joined(separator: ", ")
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
                    .lineLimit(2)
                if historyItem.expenseType == .newExpense {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(colourful == true ? Color(hex: historyItem.category?.hexColor ?? "#FC6DAB") : Color(uiColor: .systemGray))
                        .accessibilityIdentifier(Constants.AccessebilityIDs.circle)
                }
                Spacer()
                Text(String(format: "%.2f", historyItem.amount))
                Text(MockData.defaultCurrency)
            }
            .font(.title3)
            
            VStack(alignment: .leading) {
                Text(R.string.localizable.historyDateTitle() + " ") +
                     Text(historyItem.date, format: Date.FormatStyle().year().month().day().weekday())
                
                Text(R.string.localizable.historyPaidByTitle() + " \(historyItem.payer.name)")
                
                if historyItem.expenseType == .newExpense {
                    newExpense
                }
                if historyItem.expenseType == .directPayment {
                    directPayment
                }

                if showMembers {
                    Text(membersString)
                        .accessibilityIdentifier(Constants.AccessebilityIDs.betweenMatesLabel)
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
                .accessibilityIdentifier(Constants.AccessebilityIDs.seeAllButton)
                .animation(.none)
        }
    }
    
    var directPayment: some View {
        Text(R.string.localizable.historyReceivedByTitle() + " \(historyItem.between.first?.name ?? "")")
    }
}

struct HistoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryItemView(historyItem: MockData.historyItem, colourful: true)
    }
}
