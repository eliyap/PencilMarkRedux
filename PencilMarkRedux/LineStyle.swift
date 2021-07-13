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

extension Content {
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
        
        if let node = self as? Node {
            node.unwrap(style: style)
        }
        
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
}
extension Text {
    /**
     Applies `style` to `range` in the context of `document`
     by splitting its contents into 3 ``Text`` nodes, with the middle one wrapped in a new `style` node.
     Flags the `style` node as being added.
     - Note: Assumes this ``Node`` has no children, i.e. it is a leaf ``Node``.
     - ported from TypeScript "partial apply"
     */
    func apply<T: Node>(style: T.Type, to range: NSRange, in document: StyledMarkdown) -> Void {
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
            parent: parent
        )!
        styled._change = .toAdd
        
        /// get range's intersection with own range
        let lowerBound = max(range.lowerBound, position.nsRange.lowerBound)
        let upperBound = min(range.upperBound, position.nsRange.upperBound)
        let intersection = _NSRange(location: lowerBound, length: upperBound - lowerBound)
        
        /// construct broken up nodes
        let (prefix, middle, suffix) = split(on: intersection, with: styled)
        
        /// replace `self` with broken up nodes
        parent.children.replaceSubrange(indexInParent..<(indexInParent+1), with: [prefix, styled, suffix])
        
        /// release reference, should now be de-allocated
        parent = nil
        
        print("Partial Format Applied to: \(middle.value)")
    }
}


extension Content {
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
                "value": "", /// NOTHING!
            ],
            parent: parent
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
                "value": "", /// NOTHING!
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
                "value": "", /// NOTHING!
            ],
            parent: parent
        )!
        
        return (
            prefix,
            middle,
            suffix
        )
    }
}
