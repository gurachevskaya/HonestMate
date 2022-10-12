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
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.history) { item in
                        HistoryItemView(historyItem: item)
                    }
                    .onDelete(perform: delete)
                }
            }
            .navigationBarTitle("Group name", displayMode: .large)
            .onAppear {
                viewModel.loadHistory()
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        viewModel.delete(at: offsets)
     }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HistoryView(viewModel: HistoryViewModel(expensesService: Resolver.resolve()))
        }
    }
}
