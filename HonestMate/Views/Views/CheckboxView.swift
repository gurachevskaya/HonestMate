//
//  CheckboxView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 16.09.22.
//

import Foundation
import SwiftUI

struct CheckBox: View {

    @Binding var isSelected: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(isSelected ? .white : .gray)
                .frame(width: 22, height: 22)
            Circle()
                .fill(isSelected ? .pink : .clear)
                .frame(width: 8, height: 8)
        }
    }
}
