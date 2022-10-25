//
//  MyEventsView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 5.09.22.
//

import SwiftUI
import Resolver
import Charts

struct MyEventsView: View {
    
    @StateObject var viewModel: MyEventsViewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationState.homePath) {
            VStack {
                myBalanceView
                chart
  
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
            Text(R.string.localizable.homeMyBalance())
            Spacer()
            Text(String(format: "%.1f", viewModel.myBalance) )
        }
        .font(.title3)
        .padding(28)
        .frame(height: 50)
        .background(viewModel.myBalanceViewColor)
        .cornerRadius(10)
    }
    
    var chart: some View {
        Chart(viewModel.balances) { balance in
            BarMark(
                x: .value("Name", balance.member.name),
                y: .value("Balance", balance.balance)
            )
        }
        .foregroundColor(Color(uiColor:.systemGray3))
        .padding()
    }
    
    var addExpenseButton: some View {
        NavigationLink(value: HomeRoute.selectType) {
            RoundedTextButton(
                title: R.string.localizable.homeAddExpenseButtonTitle(),
                style: .filled(viewModel.accentColor)
            )
        }
    }

    var directPaymentButton: some View {
        NavigationLink(value: HomeRoute.directPayment) {
            RoundedTextButton(
                title: R.string.localizable.homeDirectPaymentButtonTitle(),
                style: .filled(viewModel.accentColor)
            )
        }
    }
}

struct MyEventsView_Previews: PreviewProvider {
    static var previews: some View {
        MyEventsView(viewModel: MyEventsViewModel(
            navigationState: Resolver.resolve(),
            expensesService: Resolver.resolve(),
            authService: Resolver.resolve(),
            appState: Resolver.resolve(),
            remoteConfig: Resolver.resolve()
        ))
    }
}
