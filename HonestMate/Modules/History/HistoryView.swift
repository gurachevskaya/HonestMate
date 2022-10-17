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
                        NavigationLink(value: HistoryRoute.expenseDetails(item)) {
                            HistoryItemView(historyItem: item)
                                .animation(Animation.spring())
                        }
                    }
                    .onDelete(perform: viewModel.delete)
                }
            }
            .navigationDestination(for: HistoryRoute.self) { route in
                switch route {
                case .expenseDetails(let model):
                    EmptyView().foregroundColor(.red)
                }
            }
            .navigationBarTitle(viewModel.groupName, displayMode: .large)
            .onAppear {
                viewModel.loadGroupName()
                viewModel.loadHistory()
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HistoryView(viewModel: HistoryViewModel(expensesService: Resolver.resolve(), appState: Resolver.resolve(), groupsService: Resolver.resolve()))
        }
    }
}
