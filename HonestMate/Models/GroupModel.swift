//
//  GroupModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 13.10.22.
//

import Foundation
import FirebaseFirestoreSwift

struct GroupModel: Identifiable, Equatable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    let name: String
}
