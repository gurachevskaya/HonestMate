//
//  MyEventsView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 5.09.22.
//

import SwiftUI
import Resolver

struct MyEventsView: View {
    
    @StateObject var viewModel: MyEventsViewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationState.homePath) {
            VStack {
                myBalanceView
                
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
            .onAppear {
                viewModel.getBalances()
            }
        }
    }

    var myBalanceView: some View {
        HStack {
            Text("my balance")
            Spacer()
            Text(String(format: "%.1f", viewModel.myBalance) )
        }
        .font(.title3)
        .padding(28)
        .frame(height: 50)
        .background(viewModel.myBalanceViewColor)
        .cornerRadius(10)
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
        MyEventsView(viewModel: MyEventsViewModel(
            navigationState: Resolver.resolve(),
            expensesService: Resolver.resolve()
        ))
    }
}
