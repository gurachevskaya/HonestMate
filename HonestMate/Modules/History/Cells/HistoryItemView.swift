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

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(historyItem.description?.capitalized ?? (historyItem.category ?? ""))
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.yellow)
                Spacer()
                Text(String(format: "%.2f", historyItem.amount))
                Text(MockData.defaultCurrency)
            }
            .font(.title3)
            
            VStack(alignment: .leading) {
                Text(R.string.localizable.historyDateTitle() + " ") +
                     Text(historyItem.date, format: Date.FormatStyle().year().month().day().weekday())
                Text(R.string.localizable.historyPaidByTitle() + " \(historyItem.payer)")
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

                if showMembers {
                    Text(membersString)
                }
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
