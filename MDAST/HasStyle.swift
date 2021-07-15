//
//  HasStyle.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

extension Node {
    /// Walks up the tree, looking for a node with the given type
    /// Used to check if the ``Content`` already has an ancestor of some style, and therefore does not need to be styled further.
    func has<T: Parent>(style: T.Type) -> Bool {
        var node: Node = self
        while(node._type != Root.type) {
            if node._type == style.type {
                return true
            }
            node = node.parent
        }
        return false
    }
}
