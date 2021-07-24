//
//  LineErase.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/7/21.
//

import Foundation
import UIKit

extension StyledMarkdownDocument {
    /// A straight line erase operation.
    func erase(to range: NSRange, in view: PMTextView) -> Void {
        /// reject empty ranges
        guard range.length > 0 else { return }
        let intersected: [Text] = ast.intersectingText(in: range)
        
        /// Mark nodes that were directly erased along this range in the AST.
        intersected.forEach { $0.erase(in: range, in: self) }
        
        /// Mark nodes that need to be removed as a result of previous removals.
        ast.infect()
        #warning("Todo: run some form of `consume`!")
        
        makeReplacements(in: view)
    }
}

extension Text {
    /// Mark changes in the AST needed to erase the passed range.
    func erase(in range: NSRange, in document: StyledMarkdownDocument) -> Void {
        /**
         Compare the targeted substring and our contents, ignoring surrounding whitespace.
         If they are equal, then this whole node can be removed.
         */
        let intersection = position.nsRange.intersection(with: range)
        let trimmedTarget = document.text[intersection].trimmingCharacters(in: .whitespaces)
        let trimmedWhole = document.text[position.nsRange].trimmingCharacters(in: .whitespaces)
        if trimmedWhole == trimmedTarget {
            _change = .toRemove
        } else {
            let (prefix, middle, suffix) = self.split(on: range)
            
            /// point split nodes to parent
            prefix?.parent = parent
            middle.parent = parent
            suffix?.parent = parent
            
            /// mark target for removal
            middle._change = .toRemove
            
            /// remove `nil` nodes
            let pieces: [Text] = [prefix, middle, suffix].compactMap{ $0 }
            
            /// replace self in parent's children
            parent.children.replaceSubrange(indexInParent..<(indexInParent+1), with: pieces)
            
            /// finally, remove parent pointer, should now be de-allocated
            parent = nil
        }
    }
}