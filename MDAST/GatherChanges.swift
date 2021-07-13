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
        /// include `self` if we are flagged for change
        ((_change == nil) ? [] : [self])
            /// and all changes from children
            + nodeChildren.flatMap { $0.gatherChanges() }
    }
}
