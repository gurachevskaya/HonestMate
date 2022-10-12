//
//  HistoryItemView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 11.10.22.
//

import SwiftUI

struct HistoryItemView: View {
    var historyItem: HistoryItemModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(historyItem.description?.capitalized ?? "Expense")
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.yellow)
                Spacer()
                Text(String(format: "%.2f", historyItem.amount))
                Text(MockData.defaultCurrency)
            }
            .font(.title3)
            
            VStack(alignment: .leading) {
                Text(R.string.localizable.historyDateTitle()
                     + " \(historyItem.date.description)")
                Text(R.string.localizable.historyPaidByTitle() + " \(historyItem.payerID)")
                Text(R.string.localizable.historyShareBetweenTitle(historyItem.between.count))
            }
            .foregroundColor(.gray)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
    }
}

struct HistoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryItemView(historyItem: MockData.historyItem)
    }
}
