//
//  Unwrap.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

extension Node {
    /**
     "Unwraps" all descendant tags with the specified `style`
     by extracting their contents into the parent node and deleting them.
     */
    func unwrap<T: Node>(style: T.Type) -> Void {
        /// Deliberately freeze a variable of known children, as this function will mutate the list.
        let frozenNodes: [Node] = nodeChildren
        
        /// head recursion
        frozenNodes.forEach { $0.unwrap(style: style) }
        
        if (_type == style.type) {
            /// update children's guardian status
            nodeChildren.forEach { $0.parent = parent }
            
            /// pass children to parent in place of self
            parent.children.replaceSubrange(indexInParent..<(indexInParent + 1), with: children)
            
            /// remove reference to parent, should be deallocated after this
            parent = nil
        }
    }
}
