//
//  PayerView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 25.10.22.
//

import SwiftUI

struct PayerView: View {
    let member: MemberModel
    @Binding var payer: MemberModel?

    @State private var scale = false
    
    var body: some View {
        Text(member.name)
            .scaleEffect(scale ? 1.2 : 1)
            .animation(.spring(), value: scale)
            .onTapGesture {
                scale = true
                payer = member
            }
    }
}

struct PayerView_Previews: PreviewProvider {
    static var previews: some View {
        PayerView(member: MockData.memberModel, payer: .constant(MockData.memberModel))
    }
}
