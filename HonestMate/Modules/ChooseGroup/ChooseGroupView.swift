//
//  ChooseGroup.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 13.10.22.
//

import SwiftUI
import Resolver

struct ChooseGroupView: View {
    
    @StateObject var viewModel: ChooseGroupViewModel

    var body: some View {
        List {
            ForEach(viewModel.groups) { group in
                Text(group.name)
                    .onTapGesture {
                        viewModel.choseGroup(groupID: group.id ?? "")
                    }
            }
        }
        .onAppear {
            viewModel.getUserGroups()
        }
        .navigationBarTitle("My Groups", displayMode: .large)
    }
}

struct ChooseGroup_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChooseGroupView(viewModel: ChooseGroupViewModel(groupsService: Resolver.resolve(), authService: Resolver.resolve(), appState: Resolver.resolve()))
        }
    }
}
