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
    
    var body: some View {
        Text("Home")
    }
}

struct MyEventsView_Previews: PreviewProvider {
    static var previews: some View {
        MyEventsView(viewModel: MyEventsViewModel())
    }
}
