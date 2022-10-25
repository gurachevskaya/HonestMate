//
//  SelectPayerView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 25.10.22.
//

import SwiftUI

struct SelectPayerView: View {
    
    @StateObject var viewModel: SelectPayerViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.members) { member in
                    PayerView(
                        member: member,
                        payer: viewModel.payer.onChange(payerChanged)
                    )
                }
            }
            Spacer()
        }

    }
    
    private func payerChanged(to value: MemberModel?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct SelectPayerView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPayerView(viewModel: SelectPayerViewModel(payer: .constant(MockData.memberModel), members: MockData.members))
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
