//
//  Node.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

class Node: Content {
    /// This ``Node``'s parent ``Node``.
    /// `weak` to avoid a strong reference cycle.
    /// Optional because ``Root`` has no parent.
    weak var parent: Node!
    
    /// The position of the substring in the source Markdown that this Node represents.
    let position: Position
    
    /// The string marking the node's class in JavaScript.
    class var type: String { "Node" }
    
    /// An internal string for figuring out node type independent of class hierarchy
    var _type: String = "Node"
    
    /// Child Nodes
    var children: [Content]
    
    required init?(dict: [AnyHashable: Any]?, parent: Node?) {
        if
            let position = Position(dict: dict?["position"] as? [AnyHashable: Any]),
            let children = dict?["children"] as? [[AnyHashable: Any]],
            let _type = dict?["type"] as? String
        {
            self.parent = parent
            self.position = position
            self._type = _type
            self.children = [] /// initialize before self is captured in closure below
            self.children = children.compactMap{ construct(from: $0, parent: self) }
        } else {
            return nil
        }
    }
    
    func walk() -> Void {
        print(Self.type)
        children.forEach {
            if let node = $0 as? Node {
                node.walk()
            } else {
                print("Non Node")
            }
        }
    }
    
    func style(_ string: inout NSMutableAttributedString) -> Void {
        children
            .compactMap { $0 as? Node }
            .forEach { $0.style(&string) }
    }
}

func construct(from dict: [AnyHashable: Any]?, parent: Node?) -> Content? {
    let type = dict?["type"] as? String
    switch type {
    case Heading.type:
        return Heading(dict: dict, parent: parent)
    case Root.type:
        return Root(dict: dict, parent: parent)
    case ThematicBreak.type:
        return ThematicBreak(dict: dict, parent: parent)
    case List.type:
        return List(dict: dict, parent: parent)
    case ListItem.type:
        return ListItem(dict: dict, parent: parent)
    case Paragraph.type:
        return Paragraph(dict: dict, parent: parent)
    case Delete.type:
        return Delete(dict: dict, parent: parent)
    case Text.type:
        return Text(dict: dict, parent: parent)
    default:
        print("Unrecognized type \(type ?? "No Type")")
        print("\(String(describing: dict?.keys))")
        return nil
    }
}

extension Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.position == rhs.position && lhs._type == rhs._type
    }
}

extension Node: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
        hasher.combine(_type)
    }
}
