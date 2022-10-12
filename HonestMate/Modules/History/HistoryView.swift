//
//  HistoryView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import SwiftUI

struct HistoryView: View {
    
    @ObservedObject var viewModel: HistoryViewModel

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.history) { item in
                    HistoryItemView(historyItem: item)
                }
            }
        }
        .navigationBarTitle("Group name", displayMode: .large)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HistoryView(viewModel: HistoryViewModel())
        }
    }
}
