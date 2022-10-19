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
            content
                .navigationBarTitle(viewModel.groupName, displayMode: .large)
        }
        .onAppear {
            viewModel.loadData()
        }
        .navigationDestination(for: HistoryRoute.self) { route in
            route.view()
        }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return ProgressView().scaleEffect(2).eraseToAnyView()
        case .error, .loaded:
            return history
                .alert(item: $viewModel.alertItem) { alertItem in
                    Alert(
                        title: alertItem.title,
                        message: alertItem.message,
                        dismissButton: alertItem.dismissButton
                    )
                }.eraseToAnyView()
        }
    }
    
    private var history: some View {
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
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HistoryView(viewModel: HistoryViewModel(expensesService: Resolver.resolve(), appState: Resolver.resolve(), groupsService: Resolver.resolve()))
        }
    }
}
