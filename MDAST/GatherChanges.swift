//
//  GatherChanges.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

extension Node {
    /// Recursive function that gathers all nodes which are marked as having changed.
    func gatherChanges() -> [Node] {
        /// include `self` if we are flagged for change,
        var result: [Node] = (_change == nil)
            ? []
            : [self]
        /// and all changes from children.
        if let parent = self as? Parent {
            result += parent.children.flatMap { $0.gatherChanges() }
        }
        return result
    }
}
