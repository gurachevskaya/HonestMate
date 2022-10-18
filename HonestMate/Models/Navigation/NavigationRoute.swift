//
//  NavigationRouter.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 18.10.22.
//

import Foundation
import SwiftUI

protocol NavigationRoute {
    
    associatedtype V: View

    @ViewBuilder
    func view() -> V
}
