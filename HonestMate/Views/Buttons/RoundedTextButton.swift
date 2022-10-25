//
//  RoundedTextButton.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 1.09.22.
//

import SwiftUI

struct RoundedTextButton: View {
    @Environment(\.isEnabled) var isEnabled
    
    enum RoundedButtonStyle {
        case filled(Color)
    }

    var title: String
    var style: RoundedButtonStyle
    var height: CGFloat = 50
    
    private var backgroundColor: Color {
        switch style {
        case .filled(let color):
            return color
        }
    }
    
    private var titleColor: Color {
        switch style {
        case .filled:
            return .white
        }
    }
    
    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.semibold)
            .frame(height: height)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(isEnabled ? backgroundColor : backgroundColor.opacity(0.5))
            .foregroundColor(titleColor)
            .cornerRadius(10)
    }
}

struct RoundedTextButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedTextButton(title: "title", style: .filled(.pink))
    }
}
