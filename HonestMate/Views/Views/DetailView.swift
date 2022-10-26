//
//  DetailView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 26.10.22.
//

import SwiftUI

struct DetailView: View {
    var title: Text
    var value: Text
    var withDivider: Bool = true
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                title
                    .fontWeight(.medium)
                Spacer()
                value
            }
            if withDivider {
                BasicDivider()
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(title: Text("title"), value: Text("value"))
    }
}
