//
//  Parent.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

class Parent: Node {
        
    override class var type: String { "Node" }
        
    /// Child Nodes
    var children: [Node]
    
    required init?(dict: [AnyHashable: Any]?, parent: Parent?) {
        if
            let position = Position(dict: dict?["position"] as? [AnyHashable: Any]),
            let children = dict?["children"] as? [[AnyHashable: Any]],
            let _type = dict?["type"] as? String
        {
            
            self.children = [] /// initialize before self is captured in closure below
            super.init(parent: parent, position: position, _type: _type)
            self.children = children.compactMap{ construct(from: $0, parent: self) }
        } else {
            print("Failed to initalize node of type \(dict?["type"] as? String ?? "No Type")!")
            print("Dict: \(String(describing: dict))")
            return nil
        }
    }
    
    /// Allows this node to style the passed Attributed String.
    /// Makes the markdown more visually appealing.
    override func style(_ string: inout NSMutableAttributedString) -> Void {
        super.style(&string)
        /// Recursively let each child apply their own styles.
        children.forEach { $0.style(&string) }
    }
    
    override func gatherChanges() -> [Node] {
        /// Include changes from children as well using recursive call.
        return super.gatherChanges() + children.flatMap { $0.gatherChanges() }
    }
}

// MARK:- Convenience Methods
extension Parent {
    /// Children that are of the ``Node`` type.
    var nodeChildren: [Parent] {
        children.compactMap { $0 as? Parent }
    }
}

extension Parent {
    /// range up to the range of the first child
    var leadingRange: NSRange? {
        if let firstChild = children.first {
            let lowerBound = position.start.offset
            let upperBound = firstChild.position.start.offset
            return NSMakeRange(lowerBound, upperBound - lowerBound)
        } else {
            return nil
        }
    }
    
    /// range from the end of the last child
    var trailingRange: NSRange? {
        if let lastChild = children.last {
            let lowerBound = lastChild.position.end.offset
            let upperBound = position.end.offset
            return NSMakeRange(lowerBound, upperBound - lowerBound)
        } else {
            return nil
        }
    }
}
