//
//  Consume.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation
import OrderedCollections

extension StyledMarkdown {
    /// Joins adjacent nodes of the same type into a single node.
    /// - does this by having one node "consume" its sibling.
    /// - Parameter style: the type of node which was formatted
    func consume<T: Node>(style: T.Type) -> Void {
        /// only examine nodes that were recently added
        let flagged = ast.gatherChanges()
            .filter { $0._change == .toAdd }
        
        /// track nodes that were removed
        var consumed: OrderedSet<Node> = []
        flagged.forEach {
            /// skip over already consumed elements
            guard consumed.contains($0) == false else { return }
            
            #warning("may wish to revise this assertion when running consume after a delete, as john pointed out.")
            assert($0._type == style.type, "Mismatched type")
            
            $0.consumePrev(consumed: &consumed)
            $0.consumeNext(consumed: &consumed)
        }
    }
}

// MARK:- Consume Guts
extension Node {
    var prevSibling: Content? {
        self.indexInParent - 1 >= 0
            ? parent.children[self.indexInParent - 1]
            : nil
    }
    
    var nextSibling: Content? {
        self.indexInParent + 1 < parent.children.count
            ? parent.children[self.indexInParent + 1]
            : nil
    }
    
    func consumePrev(consumed: inout OrderedSet<Node>) -> Void {
        /// Check if previous sibling is a ``Node`` of same `_type`.
        if
            let prev = prevSibling as? Node,
            prev._type == _type
        {
            /// Head recursion: let it eat it's `prevSibling` first.
            prev.consumePrev(consumed: &consumed)
            
            switch prev._change {
            
            /// Node is newly added, let us (also being added) take over.
            case .toAdd:
                /// Adopt previous sibling's children.
                prev.children.forEach { $0.parent = self }
                children.insert(contentsOf: prev.children, at: 0)
                prev.children = []
                
                /// extend text range to include range of sibling
                position.start = prev.position.start
                
                /// Remove `prev` from tree. Should then be deallocated.
                consumed.append(prev)
                parent.children.remove(at: prev.indexInParent)
                prev.parent = nil
            
            /// Node is in the process of being removed, not sure when this might happen, warn us.
            case .toRemove:
                print("Encountered Removal")
                break
            
            /// Pre-existing node.
            case .none:
                /// Adopt previous sibling.
                parent.children.remove(at: prev.indexInParent)
                prev.parent = self
                children.insert(prev, at: 0)
                
                /// Flag syntax marks for removal.
                prev._change = .toRemove
                
                /// extend text range to include range of sibling
                position.start = prev.position.start
            }
        } else {
            #warning("TODO: port eject whitespace")
        }
    }
    
    func consumeNext(consumed: inout OrderedSet<Node>) -> Void {
        /// Check if next sibling is a ``Node`` of same `_type`.
        if
            let next = nextSibling as? Node,
            next._type == _type
        {
            /// Head recursion: let it eat it's `prevSibling` first.
            next.consumeNext(consumed: &consumed)
            
            switch next._change {
            
            /// Node is newly added, let us (also being added) take over.
            case .toAdd:
                /// Adopt previous sibling's children.
                next.children.forEach { $0.parent = self }
                children.append(contentsOf: next.children)
                next.children = []
                
                /// extend text range to include range of sibling
                position.end = next.position.end
                
                /// Remove `prev` from tree. Should then be deallocated.
                consumed.append(next)
                parent.children.remove(at: next.indexInParent)
                next.parent = nil
            
            /// Node is in the process of being removed, not sure when this might happen, warn us.
            case .toRemove:
                print("Encountered Removal")
                break
            
            /// Pre-existing node.
            case .none:
                /// Adopt previous sibling.
                parent.children.remove(at: next.indexInParent)
                next.parent = self
                children.append(next)
                
                /// Flag syntax marks for removal.
                next._change = .toRemove
                
                /// extend text range to include range of sibling
                position.end = next.position.end
            }
        } else {
            #warning("TODO: port eject whitespace")
        }
    }
}
