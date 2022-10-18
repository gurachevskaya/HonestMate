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
    
    @State var shouldShowChooseGroup = false

    var body: some View {
        List {
            Button {
                shouldShowChooseGroup = true
            } label: {
                Text(R.string.localizable.profileChangeGroup())
            }
            
            Button {
                viewModel.logout()
            } label: {
                Text(R.string.localizable.profileLogout())
            }
        }
        .onReceive(viewModel.$shouldShowChooseGroup) { newValue in
            shouldShowChooseGroup = newValue
        }
        .foregroundColor(.primary)
        .fullScreenCover(isPresented: $shouldShowChooseGroup) {
            ProfileRoute.chooseGroup.view()
        }
    }
}

struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView(viewModel: MyProfileViewModel(authService: Resolver.resolve(), appState: Resolver.resolve()))
    }
}
