//
//  Parent.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

public class Parent: Node {
        
    override class var type: String { "Parent" }
        
    /// Child Nodes
    var children: [Node]
    
    required init?(dict: [AnyHashable: Any]?, parent: Parent?, text: String) {
        if
            let position = Position(dict: dict?["position"] as? [AnyHashable: Any]),
            let children = dict?["children"] as? [[AnyHashable: Any]],
            let _type = dict?["type"] as? String
        {
            
            self.children = [] /// initialize before self is captured in closure below
            super.init(parent: parent, position: position, _type: _type)
            self.children = children.compactMap{ construct(from: $0, parent: self, text: text) }
        } else {
            print("Failed to initalize node of type \(dict?["type"] as? String ?? "No Type")!")
            print("Dict: \(String(describing: dict))")
            return nil
        }
    }
    
    required init(_ node: Node) {
        /// Call deep copy on each of `children`.
        /// * Note: very cool that Swift compiler can guarantee existence of `init(Node)` signature due to `required` keyword!
        children = (node as! Parent).children.map {
            Swift.type(of: $0).init($0)
        }
        super.init(node)
    }
    
    /// Explicit member wise `init`.
    init(
        parent: Parent?,
        position: Position,
        _type: String,
        children: [Node]
    ) {
        self.children = children
        super.init(parent: parent, position: position, _type: _type)
    }
    
    /// Allows this node to style the passed Attributed String.
    /// Makes the markdown more visually appealing.
    override func style(_ string: NSMutableAttributedString) -> Void {
        super.style(string)
        /// Recursively let each child apply their own styles.
        children.forEach { $0.style(string) }
    }
    
    override func gatherChanges() -> [Node] {
        /// Include changes from children as well using recursive call.
        return super.gatherChanges() + children.flatMap { $0.gatherChanges() }
    }
    
    /// Include ``children``'s descriptions.
    public override var description: [Event] {
        [.enter(point: position.start, type: _type)]
            + childDescriptions
            + [.exit(point: position.end, type: _type)]
    }
    
    /// Join ``children``'s descriptions.
    internal var childDescriptions: [Event] {
        children.flatMap(\.description)
    }
    
    /// Also increment ``children``.
    override func offsetPosition(by point: Point) {
        super.offsetPosition(by: point)
        children.forEach { $0.offsetPosition(by: point) }
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
