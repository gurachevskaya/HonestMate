//
//  MyEventsView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 5.09.22.
//

import SwiftUI
import Resolver

struct MyEventsView: View {
    
    @ObservedObject var viewModel: MyEventsViewModel
    @StateObject var appState = AppState()

    var addExpenseButton: some View {
        NavigationLink(value: HomeRoute.selectType) {
            RoundedTextButton(
                title: "Add Expense",
                style: .pink
            )
        }
    }

    var directPaymentButton: some View {
        NavigationLink(value: HomeRoute.directPayment) {
            RoundedTextButton(
                title: "Direct Payment",
                style: .pink
            )
        }
    }
    
    var body: some View {
        NavigationStack(path: $appState.homePath) {
            Spacer()
            HStack {
                addExpenseButton
                directPaymentButton
            }
            .navigationDestination(for: HomeRoute.self) { route in
                route.view()
            }
        }
        .environmentObject(appState)
        .padding()
    }
}

struct MyEventsView_Previews: PreviewProvider {
    static var previews: some View {
        MyEventsView(viewModel: MyEventsViewModel())
    }
}
