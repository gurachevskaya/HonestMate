//
//  ReceiverView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 16.09.22.
//

import Foundation
import SwiftUI

struct ReceiverView: View {
    
    @Binding var isSelected: Bool
    let member: MemberModel
    
    var body: some View {
        VStack {
            Circle()
                .frame(width: 36, height: 36)
                .foregroundColor(.yellow)
            Text(member.name)
                .foregroundColor(.primary)
                .lineLimit(1)
            CheckBox(isSelected: $isSelected)
                .padding(.top, 5)
        }
        .frame(width: 80)
    }
}

struct ReceiverView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiverView(isSelected: .constant(true), member: MockData.memberModel)
    }
}
