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
        NavigationStack(path: $viewModel.navigationState.historyPath) {
            content
                .navigationBarTitle(viewModel.groupName, displayMode: .large)
                .navigationDestination(for: HistoryRoute.self) { route in
                    route.view()
                }
                .navigationDestination(for: HomeRoute.self) { route in
                    route.view()
                }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return ProgressView().scaleEffect(2).eraseToAnyView()
        case .loaded(let model):
            return history(model)
                .alert(item: $viewModel.alertItem) { alertItem in
                    Alert(
                        title: alertItem.title,
                        message: alertItem.message,
                        dismissButton: alertItem.dismissButton
                    )
                }.eraseToAnyView()
        }
    }
    
    private func history(_ model: [ExpenseModel]) -> some View {
        VStack {
            List {
                ForEach(model) { item in
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
            HistoryView(viewModel: HistoryViewModel(expensesService: Resolver.resolve(), appState: Resolver.resolve(), groupsService: Resolver.resolve(), navigationState: Resolver.resolve()))
        }
    }
}
