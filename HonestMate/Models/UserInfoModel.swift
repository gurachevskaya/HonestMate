//
//  UserInfoModel.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 13.10.22.
//

import Foundation
import FirebaseFirestoreSwift

struct UserInfoModel: Codable {
    @DocumentID var id: String? = UUID().uuidString
    let groups: [String]
}
