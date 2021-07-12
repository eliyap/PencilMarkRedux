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
    mutating func apply<T: Node>(lineStyle: T.Type, to range: NSRange) -> Void {
        #warning("Todo")
        let (partial, complete) = ast.intersectingText(in: range)
        partial.forEach { $0.apply(style: lineStyle, to: range, in: self) }
        
        let changes = ast.gatherChanges()
        let replacements = changes
            .flatMap { $0.getReplacement() }
            /// sort in descending order
            .sorted { $0.range.lowerBound > $1.range.lowerBound }
        print("Replacements: \(replacements)")
        replacements.forEach { text.replace(from: $0.range.lowerBound, to: $0.range.upperBound, with: $0.replacement) }
        
        print(text)
        
        updateAttributes()
    }
}

extension Node {
    func gatherChanges() -> [Node] {
        /// include self if has changes
        ((_change == nil) ? [] : [self])
            /// and all changes from children
            + children
                .compactMap { $0 as? Node }
                .flatMap { $0.gatherChanges() }
    }
}

extension Node {
    
    /// Walks up the tree, looking for a node with the given type
    func has<T: Node>(style: T.Type) -> Bool {
        var node: Node = self
        while(node._type != Root.type) {
            if node._type == style.type {
                return true
            }
            node = node.parent
        }
        return false
    }
    
    func apply<T: Node>(style: T.Type, to range: NSRange, in document: StyledMarkdown) -> Void {
        assert(children.isEmpty, "Partial apply to node with children!")
        
        guard has(style: style) == false else {
            /// Style is already applied, no need to continue.
            return
        }
        
        /// construct styled node
        let styled: Node = style.init(
            dict: [
                "position": [
                    "start": [
                        "line": position.start.line,
                        "column": position.start.column,
                        "offset": range.lowerBound,
                    ],
                    "end": [
                        "line": position.end.line,
                        "column": position.end.column,
                        "offset": range.upperBound,
                    ],
                ],
                "type": style.type,
                "children": [],
            ],
            parent: self
        )!
        styled._change = .toAdd
        
        /// construct broken up nodes
        let (prefix, middle, suffix) = split(on: range, with: styled)
        
        children = [prefix, styled, suffix]
        print(children)
        
        print(document.text(for: middle))
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
                    print("Intersected non text node: \(node) with \(node.children.count) children")
                    return nil
                }
            }
    }
    
    /// Get all leaf nodes in the AST which intersect the provided range.
    func intersectingLeaves(in range: NSRange) -> [Node] {
        /// If this does not intersect, none of its children will either
        guard position.nsRange.intersects(with: range) else {
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
        range.lowerBound <= position.nsRange.lowerBound && position.nsRange.upperBound <= range.upperBound
    }
}

extension Root {
    func intersectingText(in range: NSRange) -> (partial: OrderedSet<Node>, complete: OrderedSet<Node>) {
        let textNodes: [Node] = intersectingLeaves(in: range)
        print(textNodes.count)
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

extension Node {
    func split(on range: NSRange, with styled: Node) -> (Text, Text, Text) {
        let prefix: Text = Text(
            dict: [
                "position": [
                    "start": [
                        "line": position.start.line,
                        "column": position.start.column,
                        "offset": position.start.offset,
                    ],
                    "end": [
                        "line": position.end.line,
                        "column": position.end.column,
                        "offset": range.lowerBound,
                    ],
                ],
                "type": Text.type,
                "children": [],
            ],
            parent: self
        )!
        let middle: Text = Text(
            dict: [
                "position": [
                    "start": [
                        "line": position.start.line,
                        "column": position.start.column,
                        "offset": range.lowerBound,
                    ],
                    "end": [
                        "line": position.end.line,
                        "column": position.end.column,
                        "offset": range.upperBound,
                    ],
                ],
                "type": Text.type,
                "children": [],
            ],
            parent: styled
        )!
        let suffix: Text = Text(
            dict: [
                "position": [
                    "start": [
                        "line": position.start.line,
                        "column": position.start.column,
                        "offset": range.upperBound,
                    ],
                    "end": [
                        "line": position.end.line,
                        "column": position.end.column,
                        "offset": position.nsRange.upperBound,
                    ],
                ],
                "type": Text.type,
                "children": [],
            ],
            parent: self
        )!
        
        return (
            prefix,
            middle,
            suffix
        )
    }
}
