//
//  ScribbleBlockers.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 18/7/21.
//

import Foundation
import UIKit

/// Block Scribble interactions.
final class ScribbleBlocker: NSObject, UIScribbleInteractionDelegate {
    func scribbleInteraction(_ interaction: UIScribbleInteraction, shouldBeginAt location: CGPoint) -> Bool {
        false
    }
}

/// Block Indirect Scribble interactions.
final class IndirectScribbleBlocker: NSObject, UIIndirectScribbleInteractionDelegate {
    
    /// should not be invoked
    func indirectScribbleInteraction(_ interaction: UIInteraction, isElementFocused id: String) -> Bool {
        print("focusElementIfNeeded Invoked for element \(id)")
        return true
    }
    
    func indirectScribbleInteraction(_ interaction: UIInteraction, focusElementIfNeeded elementIdentifier: String, referencePoint point: CGPoint, completion: @escaping ((UIResponder & UITextInput)?) -> Void) {
        print("focusElementIfNeeded Invoked at point \(point)")
        
        /// do nothing
        completion(nil)
    }
    
    func indirectScribbleInteraction(_ interaction: UIInteraction, frameForElement id: String) -> CGRect {
        /// return unreachable invisible rectangle
        CGRect(origin: CGPoint(x: -10000, y: -10000), size: .zero)
    }
    
    func indirectScribbleInteraction(_ interaction: UIInteraction, requestElementsIn rect: CGRect, completion: @escaping ([String]) -> Void) {
        /// return nothing
        completion([])
    }
}

