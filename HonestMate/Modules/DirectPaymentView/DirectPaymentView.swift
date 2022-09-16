//
//  DirectPaymentView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 16.09.22.
//

import SwiftUI

struct DirectPaymentView: View {
    
    @ObservedObject var viewModel: DirectPaymentViewModel

    var body: some View {
        Text("Direct payment")
            .navigationBarTitle("Direct payment", displayMode: .large)

    }
}

struct DirectPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        DirectPaymentView(viewModel: DirectPaymentViewModel())
    }
}
