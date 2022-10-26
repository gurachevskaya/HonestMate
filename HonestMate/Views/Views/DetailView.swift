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
    
    var body: some View {
        HStack {
            title
                .fontWeight(.medium)
            Spacer()
            value
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(title: Text("title"), value: Text("value"))
    }
}
