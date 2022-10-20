//
//  ExpenseCategory.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 15.09.22.
//

import Foundation
import FirebaseFirestoreSwift

struct ExpenseCategory: Identifiable, Hashable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    let isActive: Bool
    let name: String
    let hexColor: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case isActive
        case name
        case hexColor = "color"
    }
}
