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
    let name: String
}
