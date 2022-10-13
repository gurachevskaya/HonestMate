//
//  HonestMateTabView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import SwiftUI
import Resolver

struct HonestMateTabView: View {
    @State private var selection = 1
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.systemGray6
    }
    
    var body: some View {
        TabView(selection: $selection) {
            HistoryView(viewModel: HistoryViewModel(
                expensesService: Resolver.resolve()
            ))
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text(R.string.localizable.tabHistory())
                }.tag(0)
            
            MyEventsView(viewModel: MyEventsViewModel())
                .tabItem {
                    Image(systemName: "house")
                    Text(R.string.localizable.tabHome())
                }.tag(1)
            
            MyProfileView(viewModel: MyProfileViewModel(authService: Resolver.resolve()))
                .tabItem {
                    Image(systemName: "gearshape")
                    Text(R.string.localizable.tabSettings())
                }.tag(2)
        }
        .accentColor(.pink)
    }
}

struct HonestMateTabView_Previews: PreviewProvider {
    static var previews: some View {
        HonestMateTabView()
    }
}
