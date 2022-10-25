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
        VStack {
            List {
                ForEach(viewModel.groups) { group in
                    GroupView(group: group)
                        .onTapGesture {
                            viewModel.chooseGroup(group: group)
                        }
                }
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        }
        .navigationBarTitle(R.string.localizable.chooseGroupMyGroupsTitle(), displayMode: .large)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.getUserGroups()
        }
    }
}

struct ChooseGroup_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChooseGroupView(viewModel: ChooseGroupViewModel(groupsService: Resolver.resolve(), authService: Resolver.resolve(), appState: Resolver.resolve()))
        }
    }
}
