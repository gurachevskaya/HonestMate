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
            HistoryRoute.history.view()
                .tabItem {
                    Image(systemName: Constants.SFSymbols.list)
                    Text(R.string.localizable.tabHistory())
                }.tag(0)
            
            HomeRoute.home.view()
            .tabItem {
                Image(systemName: Constants.SFSymbols.house)
                Text(R.string.localizable.tabHome())
            }.tag(1)
            
            ProfileRoute.profile.view()
                .tabItem {
                    Image(systemName: Constants.SFSymbols.gearshape)
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
