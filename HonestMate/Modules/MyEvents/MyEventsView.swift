//
//  MyEventsView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 5.09.22.
//

import SwiftUI
import Resolver

struct MyEventsView: View {
    
    @ObservedObject var viewModel: MyEventsViewModel
    
    @State private var appState = AppState()

    var body: some View {
        Button {
            viewModel.logout()
        } label: {
            Text("Logout")
        }
    }
}

struct MyEventsView_Previews: PreviewProvider {
    static var previews: some View {
        MyEventsView(viewModel: MyEventsViewModel(authService: Resolver.resolve(), isShowingMyEvents: .constant(true)))
    }
}
