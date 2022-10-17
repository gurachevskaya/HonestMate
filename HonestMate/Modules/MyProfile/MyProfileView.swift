//
//  MyProfileView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import SwiftUI
import Resolver

struct MyProfileView: View {
    @ObservedObject var viewModel: MyProfileViewModel

    var body: some View {
        List {
            Button {
                viewModel.changeGroup()
            } label: {
                Text("Change Group")
            }
            
            Button {
                viewModel.logout()
            } label: {
                Text("Logout")
            }
        }
        .foregroundColor(.primary)
        .fullScreenCover(isPresented: $viewModel.shouldShowChooseGroup) {
            ChooseGroupView(
                viewModel: ChooseGroupViewModel(
                    groupsService: Resolver.resolve(),
                    authService: Resolver.resolve(),
                    appState: Resolver.resolve()
                )
            )
        }
    }
}

struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView(viewModel: MyProfileViewModel(authService: Resolver.resolve(), appState: Resolver.resolve()))
    }
}
