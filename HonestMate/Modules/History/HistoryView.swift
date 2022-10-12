//
//  HistoryView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import SwiftUI
import Resolver

struct HistoryView: View {
    
    @StateObject var viewModel: HistoryViewModel

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.history) { item in
                    HistoryItemView(historyItem: item)
                }
            }
        }
        .onAppear {
            viewModel.loadHistory()
        }
        .navigationBarTitle("Group name", displayMode: .large)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HistoryView(viewModel: HistoryViewModel(expensesService: Resolver.resolve()))
        }
    }
}
