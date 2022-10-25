//
//  HonestMateTabViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 25.10.22.
//

import SwiftUI

class HonestMateTabViewModel: ObservableObject {
    @Published var selection = 1
    
    private var remoteConfig: RemoteConfigServiceProtocol
    
    init(remoteConfig: RemoteConfigServiceProtocol) {
        self.remoteConfig = remoteConfig
    }
    
    var accentColor: Color { Color(hex: remoteConfig.appConfig?.accentColor ?? "") }
}
