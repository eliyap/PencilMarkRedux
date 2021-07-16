//
//  LineErase.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/7/21.
//

import Foundation

extension StyledMarkdown {
    /// A straight line erase operation.
    mutating func erase(in range: NSRange) -> Void {
        /// reject empty ranges
        guard range.length > 0 else { return }
        let intersected: [Text] = ast.intersectingText(in: range)
        
        for textNode in intersected {
            /**
             Compare the targeted substring, and the text node contents, ignoring surrounding whitespace.
             If equal, then the whole node can be removed.
             */
            let intersection = textNode.position.nsRange.intersection(with: range)
            let trimmedTarget = text[intersection].trimmingCharacters(in: .whitespaces)
            let trimmedWhole = text[textNode.position.nsRange].trimmingCharacters(in: .whitespaces)
            if trimmedWhole == trimmedTarget {
                textNode._change = .toRemove
            } else {
                let (prefix, middle, suffix) = textNode.split(on: range)
                
                /// point split nodes to parent
                prefix?.parent = textNode.parent
                middle.parent = textNode.parent
                suffix?.parent = textNode.parent
                
                /// mark target for removal
                middle._change = .toRemove
                
                /// remove `nil` nodes
                let pieces: [Text] = [prefix, middle, suffix].compactMap{ $0 }
                
                /// replace self in parent's children
                textNode.parent.children.replaceSubrange(textNode.indexInParent..<(textNode.indexInParent+1), with: pieces)
                
                /// finally, remove parent pointer, should now be de-allocated
                textNode.parent = nil
            }
        }
        
        #warning("Todo: port infected tree code!")
        #warning("Todo: run some form of `consume`!")
        
        makeReplacements()
    }
}
