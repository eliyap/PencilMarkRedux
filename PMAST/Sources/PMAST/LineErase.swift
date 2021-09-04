//
//  LineErase.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/7/21.
//

import Foundation
import UIKit

extension Markdown {
    #warning("Experimental")
    /// A straight line erase operation.
    public mutating func erase(_ ranges: [NSRange]) -> Void {
        /// Freeze a copy of the AST before mutation.
        var backup = deepCopy()
        
        /// Reject empty ranges.
        let ranges = ranges.filter { $0.length > 0 }
        
        for range in ranges {
            let intersected: [Text] = ast.intersectingText(in: range)
            
            /// Mark nodes that were directly erased along this range in the AST.
            intersected.forEach { $0.erase(in: range, in: self) }    
        }
        
        /// Mark nodes that need to be removed as a result of previous removals.
        ast.infect()
        
        combine()
        
        makeReplacements()
        
        /// Finally, reformat document based on updated source Markdown.
        backup.updateAST(new: plain)
        ast = backup.ast
        
        /// Check tree links.
        try! ast.linkCheck()
    }
}

extension Text {
    /// Mark changes in the AST needed to erase the passed range.
    func erase(in range: NSRange, in document: Markdown) -> Void {
        /**
         Compare the targeted substring and our contents, ignoring surrounding whitespace.
         If they are equal, then this whole node can be removed.
         */
        let intersection = position.nsRange.intersection(with: range)
        let trimmedTarget = document.plain[intersection].trimmingCharacters(in: .whitespaces)
        let trimmedWhole = document.plain[position.nsRange].trimmingCharacters(in: .whitespaces)
        if trimmedWhole == trimmedTarget {
            _content_change = .toRemove
        } else {
            let (prefix, middle, suffix) = self.split(on: range)
            
            /// Point split nodes to parent.
            prefix?.parent = parent
            middle.parent = parent
            suffix?.parent = parent
            
            /// Mark target for removal.
            middle._content_change = .toRemove
            
            /// remove `nil` nodes
            let pieces: [Text] = [prefix, middle, suffix].compactMap{ $0 }
            
            /// replace self in parent's children
            parent.children.replaceSubrange(indexInParent!..<(indexInParent!+1), with: pieces)
            
            /// finally, remove parent pointer, should now be de-allocated
            parent = nil
        }
    }
}
