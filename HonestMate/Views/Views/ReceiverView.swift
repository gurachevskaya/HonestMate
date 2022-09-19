//
//  ReceiverView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 16.09.22.
//

import Foundation
import SwiftUI

struct ReceiverView: View {
    
    @State var isSelected: Bool = false
    let member: Member
    
    var body: some View {
            Button {
                isSelected.toggle()
            } label: {
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
            }
        .frame(width: 80)
        .onChange(of: isSelected) { newValue in
            
        }
    }
}

struct ReceiverView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiverView(member: MockData.member)
    }
}
