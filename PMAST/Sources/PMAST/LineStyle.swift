//
//  _LineStyle.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 23/7/21.
//

import Foundation
import UIKit

extension Markdown {
    #warning("Experimental")
    /// Note: view controllers should register undo before this method mutates the model.
    public mutating func apply<T: Parent>(
        lineStyle: T.Type,
        to ranges: [NSRange]
    ) -> Void {
        /// Freeze a copy of the AST before mutation.
        var backup = deepCopy()
        
        /// Reject empty ranges.
        let ranges = ranges.filter { $0.length > 0 }
        
        for range in ranges {
            /// Find which parts of the document were partially or completely intersected by this line.
            let (partial, complete) = ast.intersectingText(in: range)
            
            print("DEBUG: \(partial.count) partial, \(complete.count) complete")
            
            /// Apply changes to AST.
            partial.forEach { $0.apply(style: lineStyle, to: range, in: self) }
            complete.forEach { $0.apply(style: lineStyle, in: self) }
            consume(style: lineStyle)
            
            combine()
        }
        
        commitTreeChanges(backup: &backup)
    }
    
    /**
     Gather nodes that changed, determine what changes to the next are needed to enact those changes,
     make those replacements.
     - Important: this should be the **last** call made when mutating the document.
     */
    mutating func makeReplacements() -> Void {
        /// Figure out what replacements to make in the Markdown, in order to match the AST changes.
        let replacements = ast
            .gatherChanges()
            .flatMap { $0.getReplacement() }
            .filter(\.isNotNoOp)
            /// Sort in descending order of lower bound. This prevents changes early in the document knocking later ranges out of place.
            .sorted()
        
        guard replacements.isEmpty == false else { return }
        
        /// Check that ranges are non-overlapping.
        (1..<replacements.count).forEach { idx in
            precondition(replacements[idx - 1].range.lowerBound >= replacements[idx].range.upperBound, "Range Overlap!\n\(replacements.map(\.range))")
        }
        
        #warning("TODO: WhiteSpaceContraction")
        /**
         1. flatten replacements by combining them
         2. for each replacement, look ahead and behind.
         3. if both are whitespaces, or both are newlines, remove one. Bias to remove trailing?
         */
        
        /// Assert tree is ok.
        try! ast.linkCheck()
        
        /// Perform replacements in source Markdown.
        replacements
            .flattened()
            .forEach { plain.replace(from: $0.range.lowerBound, to: $0.range.upperBound, with: $0.replacement) }
    }
}

extension Node {
    /**
     Applies `style` to whole node in the context of `document`.
     Flags the `style` node as being added.
     - ported from TypeScript "complete apply"
     */
    func apply<T: Parent>(style: T.Type, in document: Markdown) -> Void {
        guard has(style: style) == false else {
            /// Style is already applied, no need to continue.
            return
        }
        
        if let node = self as? Parent {
            node.unwrap(style: style)
        }
        
        /// construct styled node
        let styled: Parent = style.init(
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
            parent: parent, /// attach node to own parent,
            text: "" /// NOTHING!
        )!
        styled._leading_change = .toAdd
        styled._trailing_change = .toAdd
        
        /// replace self in parent's children
        parent.children.replaceSubrange(indexInParent!..<(indexInParent! + 1), with: [styled])
        
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
    func apply<T: Parent>(style: T.Type, to range: NSRange, in document: Markdown) -> Void {
        guard has(style: style) == false else {
            /// Style is already applied, no need to continue.
            return
        }
        
        /// get range's intersection with own range
        let lowerBound = max(range.lowerBound, position.nsRange.lowerBound)
        let upperBound = min(range.upperBound, position.nsRange.upperBound)
        
        /// Construct styled node.
        /// - Note: ignore the line / column offsets, which we do not rigorously clamp!
        let styled: Parent = style.init(
            dict: [
                "position": [
                    "start": [
                        "line": position.start.line,
                        "column": position.start.column,
                        "offset": lowerBound,
                    ],
                    "end": [
                        "line": position.end.line,
                        "column": position.end.column,
                        "offset": upperBound,
                    ],
                ],
                "type": style.type,
                "children": [],
            ],
            parent: parent,
            text: "" /// NOTHING!
        )!
        
        /// Flag `style` node as newly added.
        styled._leading_change = .toAdd
        styled._trailing_change = .toAdd
        
        /// construct broken up nodes
        let (prefix, middle, suffix) = split(on: range)
        
        /// set parent
        prefix?.parent = parent
        middle.parent = styled
        suffix?.parent = parent
        
        let pieces = [prefix, styled, suffix]
            /// remove any zero width text nodes
            .compactMap { $0 }
        
        /// replace `self` with broken up nodes
        parent.children.replaceSubrange(indexInParent!..<(indexInParent!+1), with: pieces)
        
        /// release reference, should now be de-allocated
        parent = nil
    }
}

