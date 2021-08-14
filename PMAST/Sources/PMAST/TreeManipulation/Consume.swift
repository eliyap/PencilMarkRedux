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
            /// Skip over already consumed elements.
            guard consumed.contains($0) == false else { return }
            
            #warning("may wish to revise this assertion when running consume after a delete, as john pointed out.")
            assert($0._type == style.type, "Mismatched type")
            
            /// Consume siblings before and after.
            _ = $0
                .consumePrev(consumed: &consumed, in: self)? /// optional chaining in case node is deleted after ejecting whitespace
                .consumeNext(consumed: &consumed, in: self)
        }
    }
}

// MARK: - Consume Guts
extension Parent {
    /// Returns itself after consuming the next element or ejecting whitespace
    func consumePrev(consumed: inout OrderedSet<Parent>, in document: Markdown) -> Self? {
        /// Check if previous sibling is a ``Parent`` of same `_type`.
        if
            let prev = prevSibling as? Parent,
            prev._type == _type
        {
            /// Head recursion: let it eat it's `prevSibling` first.
            /// If previous sibling is nothing, just exit
            guard let prev = prev.consumePrev(consumed: &consumed, in: document) else { return self }
            
            switch (prev._leading_change, prev._trailing_change) {
            
            /// Node is newly added, let us (also being added) take over.
            case (.toAdd, .toAdd):
                /// Adopt previous sibling's children.
                prev.children.forEach { $0.parent = self }
                children.insert(contentsOf: prev.children, at: 0)
                prev.children = []
                
                /// extend text range to include range of sibling
                position.start = prev.position.start
                
                /// Remove `prev` from tree. Should then be deallocated.
                consumed.append(prev)
                parent.children.remove(at: prev.indexInParent!)
                prev.parent = nil
            
            /// Node is in the process of being removed, not sure when this might happen, warn us.
            case (.toRemove, .toRemove):
                print("Encountered Removal")
                break
            
            /// Pre-existing node.
            case (.none, .none):
                /// Adopt previous sibling.
                parent.children.remove(at: prev.indexInParent!)
                prev.parent = self
                children.insert(prev, at: 0)
                
                /// Flag syntax marks for removal.
                prev._leading_change = .toRemove
                prev._trailing_change = .toRemove
                
                /// extend text range to include range of sibling
                position.start = prev.position.start
            
            case (.toAdd, .toRemove), (.toRemove, .toAdd):
                fatalError("Logical Paradox!")
                
            default:
                fatalError("Unhandled Case!")
            }
            return self
        } else {
            return contractWhitespace(for: .leading, in: document)
        }
    }
    
    /// Returns itself after consuming the previous element or ejecting whitespace
    func consumeNext(consumed: inout OrderedSet<Parent>, in document: Markdown) -> Self? {
        /// Check if next sibling is a ``Node`` of same `_type`.
        if
            let next = nextSibling as? Parent,
            next._type == _type
        {
            /// Head recursion: let it eat it's `prevSibling` first.
            guard let next = next.consumeNext(consumed: &consumed, in: document) else { return self }
            
            switch (next._leading_change, next._trailing_change) {
            
            /// Node is newly added, so simply remove it from the tree.
            case (.toAdd, .toAdd):
                /// Adopt sibling's children.
                next.children.forEach { $0.parent = self }
                children.append(contentsOf: next.children)
                next.children = []
                
                /// extend text range to include range of sibling
                position.end = next.position.end
                
                /// Remove `next` from tree. Should then be deallocated.
                consumed.append(next)
                parent.children.remove(at: next.indexInParent!)
                next.parent = nil
            
            /// Node is in the process of being removed, not sure when this might happen, warn us.
            case (.toRemove, .toRemove):
                print("Encountered Removal")
                break
            
            /// Pre-existing node.
            case (.none, .none):
                /// Adopt previous sibling.
                parent.children.remove(at: next.indexInParent!)
                next.parent = self
                children.append(next)
                
                /// Flag syntax marks for removal.
                next._leading_change = .toRemove
                next._trailing_change = .toRemove
                
                /// extend text range to include range of sibling
                position.end = next.position.end
            
            case (.toAdd, .toRemove), (.toRemove, .toAdd):
                fatalError("Logical Paradox!")
                
            default:
                fatalError("Unhandled Case!")
            }
            return self
        } else {
            return contractWhitespace(for: .trailing, in: document)
        }
    }
    
    enum Edge {
        case leading
        case trailing
    }
    
    /// Removes leading or trailing whitespace from formatted range.
    /// If nothing is left, this destroys the node, returning `nil`
    func contractWhitespace(for edge: Edge, in document: Markdown) -> Self? {
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
        
        /// if nothing is left after ejecting whitespace, remove self from tree
        if position.nsRange.length == 0 {
//            assert(_change == .toAdd, "Pre-existing zero width with Change: \(String(describing: _change)), type: \(_type)")
            
            /// remove from tree
            parent.children.replaceSubrange(indexInParent!..<(indexInParent!+1), with: children)
            children.forEach { $0.parent = parent }
            parent = nil
            
            return nil
        } else {
            return self
        }
    }
}
