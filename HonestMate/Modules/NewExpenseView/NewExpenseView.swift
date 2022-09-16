//
//  NewExpenseView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 16.09.22.
//

import SwiftUI
import Resolver

struct NewExpenseView: View {
    
    @ObservedObject var viewModel: NewExpenseViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Description")
            TextField("Description", text: $viewModel.description)
                .modifier(TextFieldCustomRoundStyle())

            Text("Paid by")
            TextField(viewModel.currentUserName, text: $viewModel.description)
                .modifier(TextFieldCustomRoundStyle())
            
            Text("Type: \(viewModel.expenseType.name)")
        }
        .navigationBarTitle("New expense", displayMode: .large)
        .padding()
    }
}

struct NewExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        NewExpenseView(viewModel: NewExpenseViewModel(expenseType: MockData.expenseType, authService: Resolver.resolve()))
    }
}
