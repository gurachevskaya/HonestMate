//
//  RSwift+Ext.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 1.09.22.
//

import SwiftUI
import Rswift

// MARK: - ImageResource
extension ImageResource {
    var image: Image {
        Image(name)
    }
}

// MARK: - ColorResource
extension ColorResource {
    var color: Color {
        Color(name)
    }
}

// MARK: - FontResource
extension FontResource {
    func font(size: CGFloat) -> Font {
        Font.custom(fontName, size: size)
    }
}


