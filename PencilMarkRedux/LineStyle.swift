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
        /// Find which parts of the document were partially or completely intersected by this line.
        let (partial, complete) = ast.intersectingText(in: range)
        
        print("DEBUG: \(partial.count) partial, \(complete.count) complete")
        
        /// Apply changes to AST
        partial.forEach { $0.apply(style: lineStyle, to: range, in: self) }
        complete.forEach { $0.apply(style: lineStyle, in: self) }
        #warning("Todo: Port Complete Skewer Code, Merge Code")
        
        /// Figure out what replacements to make in the Markdown, in order to match the AST changes.
        let replacements = ast
            .gatherChanges()
            .flatMap { $0.getReplacement() }
            /// Sort in descending order of lower bound. This prevents changes early in the document knocking later ranges out of place.
            .sorted { $0.range.lowerBound > $1.range.lowerBound }
        
        print("Replacements: \(replacements)")
        
        /// Perform replacements in source Markdown.
        replacements.forEach { text.replace(from: $0.range.lowerBound, to: $0.range.upperBound, with: $0.replacement) }
        
        print("New Text:\n\(text)")
        
        /// Finally, reformat document based on updated source Markdown.
        updateAttributes()
    }
}

extension Node {
    /// Recursive function that gathers all nodes which are marked as having changed.
    func gatherChanges() -> [Node] {
        /// include `self` if we are flagged for change
        ((_change == nil) ? [] : [self])
            /// and all changes from children
            + nodeChildren.flatMap { $0.gatherChanges() }
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
    
    /**
     Applies `style` to whole node in the context of `document`.
     Flags the `style` node as being added.
     - ported from TypeScript "complete apply"
     */
    func apply<T: Node>(style: T.Type, in document: StyledMarkdown) -> Void {
        guard has(style: style) == false else {
            /// Style is already applied, no need to continue.
            return
        }
        
        unwrap(style: style)
        
        /// construct styled node
        let styled: Node = style.init(
            dict: [
                "position": [
                    "start": [
                        "line": position.start.line,
                        "column": position.start.column,
                        "offset": position.nsRange.lowerBound,
                    ],
                    "end": [
                        "line": position.end.line,
                        "column": position.end.column,
                        "offset": position.nsRange.upperBound,
                    ],
                ],
                "type": style.type,
                "children": [],
            ],
            parent: parent /// attach node to own parent
        )!
        styled._change = .toAdd
        
        /// replace self in parent's children
        parent.children.replaceSubrange(indexInParent..<(indexInParent + 1), with: [styled])
        
        /// attach self as `styled`'s only child
        styled.children = [self]
        parent = styled
    }
    
    /**
     "Unwraps" all descendant tags with the specified `style`
     by extracting their contents into the parent node and deleting them.
     */
    func unwrap<T: Node>(style: T.Type) -> Void {
        /// Deliberately freeze a variable of known children, as this function will mutate the list.
        let frozenNodes: [Node] = nodeChildren
        
        /// head recursion
        frozenNodes.forEach { $0.unwrap(style: style) }
        
        if (_type == style.type) {
            /// update children's guardian status
            nodeChildren.forEach { $0.parent = parent }
            
            /// pass children to parent in place of self
            parent.children.replaceSubrange(indexInParent..<(indexInParent + 1), with: children)
            
            /// remove reference to parent, should be deallocated after this
            parent = nil
        }
    }
    
    /**
     Applies `style` to `range` in the context of `document`
     by splitting its contents into 3 ``Text`` nodes, with the middle one wrapped in a new `style` node.
     Flags the `style` node as being added.
     - Note: Assumes this ``Node`` has no children, i.e. it is a leaf ``Node``.
     - ported from TypeScript "partial apply"
     */
    func apply<T: Node>(style: T.Type, to range: NSRange, in document: StyledMarkdown) -> Void {
        assert(children.isEmpty, "Partial apply to node with children!")
        print("self covers \(document.text[position.nsRange.lowerBound..<position.nsRange.upperBound])")
        print("range covers \(document.text[range.lowerBound..<range.upperBound])")
        
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
        print("\(#file), \(#function), Line \(#line) \(children)")
        
        print("Partial Format Applied to: \(middle.value)")
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
        
        /// Use `OrderedSet` to avoid possibility of duplicate nodes.
        var partial: OrderedSet<Node> = []
        var complete: OrderedSet<Node> = []
        
        /// Sort nodes based on the extent of their intersection with the `range`.
        textNodes.forEach {
            /// Can append without checking for duplicates.
            /// Discard result from `append`.
            _ = $0.skewered(by: range)
                ? complete.append($0.highestSkeweredAncestor(in: range))
                : partial.append($0)
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
