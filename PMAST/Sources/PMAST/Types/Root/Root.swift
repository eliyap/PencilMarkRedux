//
//  Root.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

final class Root: Parent {
    override class var type: String { "root" }
    
    required init?(dict: [AnyHashable: Any]?, parent: Parent?, text: String) {
        if
            let dict = dict
        {
            super.init(dict: dict, parent: nil, text: text)
        } else {
            print("Failed to initialize \(Self.type)")
            return nil
        }
    }
    
    required init(_ node: Node, parent: Parent!) {
        super.init(node, parent: parent)
        
        /// Assert tree is ok after deep copy.
        try! linkCheck()
    }
}

extension Root {
    /// Insert the other tree's nodes into our tree at the specified ``index``.
    func graft(_ other: Root, at index: Int) -> Void {
        /// "Adopt" tree as a child.
        children.insert(other, at: index)
        other.parent = self
        
        /// Lyse the node.
        other.apoptose()
    }
}
