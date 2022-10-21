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
            .navigationBarTitle(R.string.localizable.directPaymentTitle(), displayMode: .large)
    }
}

struct DirectPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DirectPaymentView(viewModel: DirectPaymentViewModel())
        }
    }
}
