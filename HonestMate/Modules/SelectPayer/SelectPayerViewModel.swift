//
//  SelectPayerViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 25.10.22.
//

import SwiftUI

class SelectPayerViewModel: ObservableObject {
    
    var payer: Binding<MemberModel?>
    var members: [MemberModel]
    
    init(
        payer: Binding<MemberModel?>,
        members: [MemberModel]
    ) {
        self.payer = payer
        self.members = members
    }
}
