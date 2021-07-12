//
//  LineStyle.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation
import UIKit
import OrderedCollections

extension StyledMarkdown {
    func apply<T: Node>(lineStyle: T.Type, to range: NSRange) -> Void {
        #warning("Todo")
    }
}

extension Node {
    func intersectingText(in range: NSRange) -> [Text] {
        intersectingLeaves(in: range)
            /// Filter out non text nodes and warn me about them.
            .compactMap { (node: Node) -> Text? in
                if let text = node as? Text {
                    return text
                } else {
                    print("Intersected non text node: \(node)")
                    return nil
                }
            }
    }
    
    /// Get all leaf nodes in the AST which intersect the provided range.
    func intersectingLeaves(in range: NSRange) -> [Node] {
        /// If this does not intersect, none of its children will either
        guard range.lowerBound < position.nsRange.upperBound || range.upperBound > position.nsRange.lowerBound else {
            return []
        }
        
        if children.isEmpty {
            /// This is a leaf node (with no children).
            return [self]
        } else {
            /// Combine results from node children.
            return children
                .compactMap { $0 as? Node }
                .flatMap { $0.intersectingLeaves(in: range) }
        }
    }
    
    /// Find the top level skewered node
    func highestSkeweredAncestor(in range: NSRange) -> Node {
        var node: Node = self
        while (node.parent.skewered(by: range)) {
            node = node.parent
        }
        return node
    }
    
    /// whether the provided range totally encloses this node
    func skewered(by range: NSRange) -> Bool {
        range.lowerBound <= position.nsRange.lowerBound && range.upperBound >= position.nsRange.upperBound
    }
}

extension Root {
    func intersectingText(in range: NSRange) -> (partial: OrderedSet<Node>, complete: OrderedSet<Node>) {
        let textNodes: [Text] = intersectingText(in: range)
        var partial: OrderedSet<Node> = []
        var complete: OrderedSet<Node> = []
        textNodes.forEach {
            if $0.skewered(by: range) == false {
                /// partially intersected elements go into one pile
                partial.append($0)
            } else {
                /// complete elements are processed, then go in the other pile
                let skeweredAncestor = $0.highestSkeweredAncestor(in: range)
                complete.append(skeweredAncestor)
            }
        }
        return (partial, complete)
    }
}
