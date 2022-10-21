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
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationState.homePath) {
            VStack {
                Spacer()
                HStack {
                    addExpenseButton
                    directPaymentButton
                }
            }
            .padding()
            .navigationDestination(for: HomeRoute.self) { route in
                route.view()
            }
        }
    }

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
}

struct MyEventsView_Previews: PreviewProvider {
    static var previews: some View {
        MyEventsView(viewModel: MyEventsViewModel(navigationState: Resolver.resolve()))
    }
}
