//
//  MyEventsViewModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 5.09.22.
//

import Foundation
import Combine
import SwiftUI

enum Route {
    case selectType
    case newExpense
    case directPayment
}

class MyEventsViewModel: ObservableObject {
    @Published var path: [Route] = []
}
