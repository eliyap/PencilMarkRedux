//
//  IntersectingText.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation
import OrderedCollections

extension Root {
    /**
     Produces a two lists of items intersecting the provided "line"
     - the "line" is represented by a `NSRange` corresponding to a `UITextRange` which should span **one** line in the source ``StyledMarkdown`` document.
     - `partial`: ``Text``s partially intersected by the range
     - `complete`: ``Content`` elements completely skewered by the range, the highest ones in the tree we could find.
     */
    func intersectingText(in range: NSRange) -> (partial: OrderedSet<Text>, complete: OrderedSet<Node>) {
        let textContents: [Text] = intersectingText(in: range)
        
        /// Use `OrderedSet` to avoid possibility of duplicate nodes.
        var partial: OrderedSet<Text> = []
        var complete: OrderedSet<Node> = []
        
        /// Sort nodes based on the extent of their intersection with the `range`.
        textContents.forEach {
            /// Can append without checking for duplicates.
            /// Discard result from `append`.
            _ = $0.skewered(by: range)
                ? complete.append($0.highestSkeweredAncestor(in: range))
                : partial.append($0)
        }
        return (partial, complete)
    }
}

extension Parent {
    /// Get all ``Text`` nodes in the AST which intersect the provided range.
    func intersectingText(in range: NSRange) -> [Text] {
        intersectingLeaves(in: range)
            /// Filter out non text nodes and warn me about them.
            .compactMap { (content: Node) -> Text? in
                if let text = content as? Text {
                    return text
                } else {
                    print("Intersected non text: \(content)")
                    return nil
                }
            }
    }
}

extension Node {
    /// Get all leaf nodes in the AST which intersect the provided range.
    func intersectingLeaves(in range: NSRange) -> [Node] {
        /// If this does not intersect, none of its children will either
        guard position.nsRange.intersects(with: range) else {
            return []
        }
        
        if let node = self as? Parent, node.children.isEmpty == false {
            /// Combine results from node children.
            return node.children
                .flatMap { $0.intersectingLeaves(in: range) }
        } else {
            /// This is a leaf node (with no children).
            return [self]
        }
    }
}
