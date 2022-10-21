//
//  UIApplication+Ext.swift
//  HonestMate
//
//  Created by Karina gurachevskaya on 19.09.22.
//

import Foundation
import SwiftUI

extension UIApplication {
    func addTapGestureRecognizer() {
        let windowScene = connectedScenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
    
    func addBackAnimation() {
        let animation = CATransition()
        animation.isRemovedOnCompletion = true
        animation.type = .moveIn
        animation.subtype = .fromLeft
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let windowScene = connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.layer.add(animation, forKey: nil)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `false` if you don't want to detect tap during other gestures
    }
}
