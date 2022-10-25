//
//  SelectPayerView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 25.10.22.
//

import SwiftUI

struct SelectPayerView: View {
    
    @StateObject var viewModel: SelectPayerViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.payer.wrappedValue?.name ?? "")
            Text(viewModel.members.description)
        }
    }
}

struct SelectPayerView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPayerView(viewModel: SelectPayerViewModel(payer: .constant(MockData.memberModel), members: MockData.members))
    }
}
