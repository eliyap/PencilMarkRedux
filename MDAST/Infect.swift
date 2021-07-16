//
//  Infect.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 16/7/21.
//

import Foundation

extension Root {
    /**
     If all of a ``parent``'s ``children`` are marked for removal, the parent should be removed also.
     For example, this allows
     - removed phrasing text to remove the surrounding marks
     - removed list items to remove the list markers
     - etc.
     
     To achieve this, we treat the `toRemove` flag like an "infection" spreading through the AST.
     A parent node is only "infected" (marked for removal) if all of its children are also.
     We can find all infections with only one reverse Breadth First Search pass on the tree.
     */
    func infect() -> Void {
        let removals: [Node] = gatherChanges()
            .filter { $0._change == .toRemove }
        
        guard removals.isEmpty == false else { return }
        let LCA: Node = removals.lowestCommonAncestor()
        
        /**
         `root` is the uppermost element in the tree that might be removed by infection.
         If LCA were removed, and it were an only child, its parent should also be removed.
         So walk up until `root` is not an only child.
         */
        var root: Node = LCA
        while root.parent != nil, root.parent.children.count == 1 {
            root = root.parent
        }
        
        /// Enqueue all descendants of ``root`` in BFS order.
        var queue: [Node] = [root]
        var index = 0
        while index < queue.count {
            queue.append(contentsOf: (queue[index] as? Parent)?.children ?? [])
            index += 1
        }
        
        /// Iterate in reverse BFS order.
        for node in queue.reversed() {
            /// Skip over leaf ``Node``s, including ``Parent``s without ``children``.
            guard
                let parent = node as? Parent,
                parent.children.count > 0
            else { continue }
            
            /// If all of the non-zero number of children set to be removed (i.e. none are not infected), set the parent for removal also
            if parent.children.filter({ $0._change != .toRemove }).count == 0 {
                parent._change = .toRemove
            }
        }
    }
}

extension Array where Element == Node {
    /// Find the Lowest Common Ancestor of a list of nodes in the same AST.
    func lowestCommonAncestor() -> Element {
        reduce(self[0]) { $0.lowestCommonAncestor(with: $1) }
    }
}

extension Node {
    /**
     All nodes in the AST have at least one common ancestor, the ``Root``.
     We want to find the common ancestor that is lowest in the tree (furthest from the ``Root``).
     */
    func lowestCommonAncestor(with other: Node) -> Node {
        /// if nodes are equal, they are their own LCAs
        if self == other { return self }
        
        let p1 = self.ancestors()
        let p2 = other.ancestors()
        
        /// Nodes should always share ``Root`` as first common ancestor.
        precondition(p1[0] == p2[0])
        
        for idx in 0..<p1.count {
            /// Move down until we find a divergence, then return the node just before the divergence.
            /// - Note: there should never be an out of bounds error, as the last element is the node itself,
            ///         and we already checked the two nodes were not equal.
            if (p1[idx] != p2[idx]) {
                return p1[idx - 1]
            }
        }
        
        fatalError("Terminated without return!")
    }
    
    /// Get an array of all ancestors starting from ``Root`` down to ``parent``.
    func ancestors() -> [Node] {
        var result: [Node] = []
        var ancestor: Node? = self
        while let a = ancestor {
            result.append(a)
            ancestor = a.parent
        }
        return result.reversed()
    }
}
