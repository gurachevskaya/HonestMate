//
//  HonestMateTabView.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import SwiftUI
import Resolver

struct HonestMateTabView: View {
    @StateObject var viewModel: HonestMateTabViewModel

    init(viewModel: HonestMateTabViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        
        UITabBar.appearance().backgroundColor = UIColor.systemGray6
    }
    
    var body: some View {
        TabView(selection: $viewModel.selection) {
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
        .accentColor(viewModel.accentColor)
    }
}

struct HonestMateTabView_Previews: PreviewProvider {
    static var previews: some View {
        HonestMateTabView(viewModel: HonestMateTabViewModel(remoteConfig: Resolver.resolve()))
    }
}
