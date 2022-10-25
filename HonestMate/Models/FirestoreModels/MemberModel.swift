//
//  User.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 16.09.22.
//

import Foundation
import FirebaseFirestoreSwift

struct MemberModel: Identifiable, Equatable, Hashable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    let name: String
}
