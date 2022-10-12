//
//  HistoryItemModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 11.10.22.
//

import Foundation
import FirebaseFirestoreSwift

struct HistoryItemModel: Identifiable, Equatable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var description: String?
    var category: String
    var amount: Double
    var date: Date
    var payerID: String
    var between: [String]
}
