//
//  MyEventsViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 5.09.22.
//

import Foundation
import Combine
import SwiftUI

class MyEventsViewModel: ObservableObject {
    
    @Published var navigationState: NavigationStateProtocol

    init(navigationState: NavigationStateProtocol) {
        self.navigationState = navigationState
        
       setupPipeline()
    }
    
    var anyCancellable: AnyCancellable?

    private func setupPipeline() {
        anyCancellable = navigationState.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
}
