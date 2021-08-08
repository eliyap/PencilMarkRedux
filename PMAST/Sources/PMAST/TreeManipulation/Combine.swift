//
//  Combine.swift
//  
//
//  Created by Secret Asian Man Dev on 8/8/21.
//

import Foundation

extension Markdown {
    func combine() -> Void {
        /// flags whether we detected combinable elements
        var tripped: Bool = false
        
        /// Walk tree
        ast.join(tripped: &tripped)
        try! ast.linkCheck() /// make sure tree manipulations work ok
        
        /// If a join was executed, check recursively for more.
        if tripped { combine() }
    }
}

extension Parent {
    func join(tripped: inout Bool) -> Void {
        /// If tripped, skip through
        guard tripped == false else { return }
        
        children.forEach { (node) in
            /**
             Conditions:
             Node is inline joinable, and would end up adjacent to a node
             of same type after removal.
             */
            guard
                node._change != .toRemove,
                let node = node as? InlineJoinable,
                let nnrs = node.nextNonRemovedSibling,
                nnrs._type == node._type
            else { return }
            tripped = true
            
            /// Create new element to contain the joined contents.
            let umbrella: InlineJoinable = Swift.type(of: node).init(parent: node.parent, position: Position(start: node.position.start, end: nnrs.position.end), _type: node._type)
            umbrella._change = .toAdd
            
            if let p = umbrella as? Parent {
                let startIdx: Int = node.indexInParent! /// freeze start index, before it gets mutated by moving stuff
                
                /// Adopt all children in from `node` to `nnrs`, inclusive.
                let range: ClosedRange<Int> = node.indexInParent!...nnrs.indexInParent!
                node.parent.children[range]
                    .forEach { $0.parent = p }
                p.children.append(contentsOf: node.parent.children[range])
                node.parent.children.removeSubrange(range)
                node.parent.children.insert(umbrella, at: startIdx)
            }
            
            /// Remove `node` and `nnrs`.
            [node, nnrs].forEach { (n) in
                switch n._change {
                case .toAdd:
                    /// Remove node from tree, should then be de-allocated.
                    if let p = n as? Parent {
                        let u = umbrella as! Parent
                        u.children.remove(at: 0)
                        u.children.insert(contentsOf: p.children, at: 0)
                        p.children.forEach { $0.parent = u }
                        p.children = []
                        p.parent = nil
                    } else {
                        /// - Warning: not a well tested code path!
                        n._change = .none
                    }
                case .none:
                    n._change = .toRemove
                case .toRemove:
                    fatalError("Node should not be marked as removed!")
                }
            }
        }
        
        /// Call recursively on all children
        nodeChildren.forEach { $0.join(tripped: &tripped) }
    }
}
