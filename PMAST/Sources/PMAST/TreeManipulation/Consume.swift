//
//  Consume.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation
import OrderedCollections

extension Markdown {
    /// Joins adjacent ``Parent``s of the same type into a single ``Parent``.
    /// - does this by having one ``Parent`` "consume" its sibling.
    /// - Parameter style: the type of ``Parent`` formatting being applied.
    func consume<T: Parent>(style: T.Type) -> Void {
        /// Only examine nodes that were recently added.
        let flagged: [Parent] = ast.gatherChanges()
            .filter { $0._leading_change == .toAdd || $0._trailing_change == .toAdd || $0._content_change == .toAdd }
            .compactMap { $0 as? Parent }
        
        /// Track nodes that were removed.
        var consumed: OrderedSet<Parent> = []
        
        flagged.forEach {
            /// Consume siblings before and after, expanding range to accomodate their descendants.
            guard consumed.contains($0) == false else { return }
            $0.position.start = $0.consumePrev(consumed: &consumed, in: self)
            
            guard consumed.contains($0) == false else { return }
            $0.position.end = $0.consumeNext(consumed: &consumed, in: self)
        }
    }
}

// MARK: - Consume Guts
extension Parent {
    /// Returns itself after consuming the next element or ejecting whitespace
    func consumePrev(consumed: inout OrderedSet<Parent>, in document: Markdown) -> Point {
        /// Check if previous sibling is a ``Parent`` of same `_type`.
        if
            let prev = prevSibling as? Parent,
            prev._type == _type
        {
            /// Recursion: let sibling eat it's `prevSibling` also.
            let edge = prev.consumePrev(consumed: &consumed, in: document)
            
            switch (prev._leading_change, prev._trailing_change) {
            /// Node was newly added, simply remove it from the tree.
            case (.toAdd, .toAdd):
                /// Signal that this node should be skipped
                consumed.append(prev)
                
                prev.apoptose()
            
            /// Node is in the process of being removed, not sure when this might happen, warn us.
            case (.toRemove, .toRemove):
                print("Encountered Removal")
                break
            
            /// Pre-existing node.
            case (.none, .none):
                /// Flag syntax marks for removal.
                prev._leading_change = .toRemove
                prev._trailing_change = .toRemove
            
            case (.toAdd, .toRemove), (.toRemove, .toAdd):
                fatalError("Logical Paradox!")
                
            default:
                fatalError("Unhandled Case!")
            }
            
            return edge
        } else {
            return contractWhitespace(for: .leading, in: document, consumed: &consumed)
        }
    }
    
    /// Returns itself after consuming the previous element or ejecting whitespace
    func consumeNext(consumed: inout OrderedSet<Parent>, in document: Markdown) -> Point {
        /// Check if next sibling is a ``Node`` of same `_type`.
        if
            let next = nextSibling as? Parent,
            next._type == _type
        {
            /// Recursion: let sibling eat it's `nextSibling` also.
            let edge = next.consumeNext(consumed: &consumed, in: document)
            
            switch (next._leading_change, next._trailing_change) {
            /// Node is newly added, so simply remove it from the tree.
            case (.toAdd, .toAdd):
                /// Signal that this node should be skipped
                consumed.append(next)
                
                next.apoptose()
            
            /// Node is in the process of being removed, not sure when this might happen, warn us.
            case (.toRemove, .toRemove):
                print("Encountered Removal")
                break
            
            /// Pre-existing node.
            case (.none, .none):
                /// Flag syntax marks for removal.
                next._leading_change = .toRemove
                next._trailing_change = .toRemove
                
            case (.toAdd, .toRemove), (.toRemove, .toAdd):
                fatalError("Logical Paradox!")
                
            default:
                fatalError("Unhandled Case!")
            }
            
            return edge
        } else {
            return contractWhitespace(for: .trailing, in: document, consumed: &consumed)
        }
    }
    
    enum Edge {
        case leading
        case trailing
    }
    
    /// Removes leading or trailing whitespace from formatted range.
    /// If nothing is left, this destroys the node, returning `nil`
    func contractWhitespace(for edge: Edge, in document: Markdown, consumed: inout OrderedSet<Parent>) -> Point {
        switch edge {
        case .leading:
            while
                position.nsRange.length > 0,
                /// for historical reasons, we need to get the Unicode Scalar instead.
                let firstCharScalar: UnicodeScalar = document.plain[position.nsRange].first?.unicodeScalars.first,
                CharacterSet.whitespaces.contains(firstCharScalar)
            {
                /// if we find a whitespace character, trim it from our range
                position.start.offset += 1
            }
        case .trailing:
            while
                position.nsRange.length > 0,
                /// for historical reasons, we need to get the Unicode Scalar instead.
                let lastCharScalar: UnicodeScalar = document.plain[position.nsRange].last?.unicodeScalars.first,
                CharacterSet.whitespaces.contains(lastCharScalar)
            {
                /// if we find a whitespace character, trim it from our range
                position.end.offset -= 1
            }
        }
        
        /// if nothing is left after ejecting whitespace, remove `self` from tree
        if position.nsRange.length == 0 {
            self.apoptose()
            consumed.append(self)
            
            /// Since length is zero, ``end`` == ``start``, so we can return either
            return position.start
        } else {
            /// Return appropriate edge's position.
            switch edge {
            case .leading:
                return position.start
            case .trailing:
                return position.end
            }
        }
    }
}
