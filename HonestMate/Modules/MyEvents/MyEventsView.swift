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
    
    var addExpenseButton: some View {
        NavigationLink(value: Route.selectType) {
            RoundedTextButton(
                title: "Add Expense",
                style: .pink
            )
        }
    }

    var directPaymentButton: some View {
        NavigationLink(value: Route.directPayment) {
            RoundedTextButton(
                title: "Direct Payment",
                style: .pink
            )
        }
    }
    
    var body: some View {
        NavigationStack {
            Spacer()
            HStack {
                addExpenseButton
                directPaymentButton
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .selectType:
                    SelectExpenseTypeView(
                        viewModel: SelectExpenseTypeViewModel(
                            type: .select,
                            expenseType: nil
                        )
                    )
                    
                case .reselectType(let expenseType):
                    SelectExpenseTypeView(
                        viewModel: SelectExpenseTypeViewModel(
                            type: .reselect,
                            expenseType: expenseType
                        )
                    )
                    
                case .newExpense(let expenseType):
                    NewExpenseView(
                        viewModel: NewExpenseViewModel(
                            expenseType: expenseType,
                            authService: Resolver.resolve()
                        )
                    )
                case .directPayment:
                    DirectPaymentView(
                        viewModel: DirectPaymentViewModel()
                    )
                }
            }
        }
        .padding()
    }
}

struct MyEventsView_Previews: PreviewProvider {
    static var previews: some View {
        MyEventsView(viewModel: MyEventsViewModel())
    }
}
