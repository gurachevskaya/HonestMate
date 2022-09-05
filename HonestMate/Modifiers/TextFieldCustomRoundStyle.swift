//
//  TextFieldCustomRoundStyle.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 5.09.22.
//

import SwiftUI

struct TextFieldCustomRoundStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding(.horizontal, 20)
            .frame(height: 50)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
    }
    
}
