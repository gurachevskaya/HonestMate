//
//  NewExpenseView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 16.09.22.
//

import SwiftUI

struct NewExpenseView: View {
    
    @ObservedObject var viewModel: NewExpenseViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Description")
            TextField("Description", text: $viewModel.description)
                .modifier(TextFieldCustomRoundStyle())

            Text("Paid by")
            TextField("Karina", text: $viewModel.description)
                .modifier(TextFieldCustomRoundStyle())
        }
        .padding()
    }
}

struct NewExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        NewExpenseView(viewModel: NewExpenseViewModel())
    }
}
