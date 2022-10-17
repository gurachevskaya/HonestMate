//
//  GroupView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 17.10.22.
//

import SwiftUI

struct GroupView: View {
    var group: GroupModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(group.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(group.created, format: Date.FormatStyle().year().month().day().weekday())
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .frame(height: 94)
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView(group: MockData.currentGroup)
    }
}
