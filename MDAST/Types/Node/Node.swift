//
//  Node.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

class Parent: Node {
        
    override class var type: String { "Node" }
        
    /// An internal, transient marker signalling that this tag is part of a modification we want to make
    var _change: StyledMarkdown.Change? = nil
    
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
            print("Dict: \(dict)")
            return nil
        }
    }
    
    func walk() -> Void {
        print(Self.type)
        children.forEach {
            if let node = $0 as? Parent {
                node.walk()
            } else {
                print("Non Node")
            }
        }
    }
    
    /// Applies an initial styling.
    func style(_ string: inout NSMutableAttributedString) -> Void {
        children
            .compactMap { $0 as? Parent }
            .forEach { $0.style(&string) }
    }
    
    /// The text replacements that need to happen when this part of the tree is changed.
    func getReplacement() -> [StyledMarkdown.Replacement] {
        return [] /// override to replace this
    }
}

// MARK:- Convenience Methods
extension Parent {
    /// Children that are of the ``Node`` type.
    var nodeChildren: [Parent] {
        children.compactMap { $0 as? Parent }
    }
    
    
}
