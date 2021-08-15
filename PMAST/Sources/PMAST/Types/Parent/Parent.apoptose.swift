//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 14/8/21.
//

import Foundation

extension Parent {
    /// Similar to cell apoptosis, we destroy the node, allowing its desendants to escape.
    /// Node should be deallocated after thsi call since all references to it are destroyed.
    func apoptose() {
        children.forEach { $0.parent = parent }
        parent.children.replaceSubrange(indexInParent!..<(indexInParent! + 1), with: children)
        children = []
        parent = nil
    }
}
