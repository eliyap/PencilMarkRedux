//
//  Node.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

protocol Content { }

class Node: Content {
    let position: Position
    class var type: String { "Node" }
    let children: [Content]
    
    required init?(dict: [AnyHashable: Any]?) {
        if
            let position = Position(dict: dict?["position"] as? [AnyHashable: Any]),
            let children = (dict?["children"] as? [[AnyHashable: Any]])?.compactMap({ construct(from: $0) })
        {
            self.position = position
            self.children = children
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
}

func construct(from dict: [AnyHashable: Any]?) -> Content? {
    let type = dict?["type"] as? String
    switch type {
    case Heading.type:
        return Heading(dict: dict)
    case Root.type:
        return Root(dict: dict)
    case ThematicBreak.type:
        return ThematicBreak(dict: dict)
    case List.type:
        return List(dict: dict)
    case ListItem.type:
        return ListItem(dict: dict)
    case Paragraph.type:
        return Paragraph(dict: dict)
    case Delete.type:
        return Delete(dict: dict)
    case Text.type:
        return Text(dict: dict)
    default:
        print("Unrecognized type \(type ?? "No Type")")
        print("\(String(describing: dict?.keys))")
        return nil
    }
}

class Literal: Content {
    
    class var type: String { "literal" }
    
    let text: String
    
    init?(dict: [AnyHashable: Any]?) {
        print(dict?.keys)
        guard let text = dict?["text"] as? String else {
            print("Failed to initialize \(Self.type)")
            return nil
        }
        
        self.text = text
    }
}

class Text: Node {
    override class var type: String { "text" }
}

class Delete: Node {
    override class var type: String { "delete" }
}

class Paragraph: Node {
    override class var type: String { "paragraph" }
}

class ThematicBreak: Node {
    override class var type: String { "thematicBreak" }
}

class ListItem: Node {
    override class var type: String { "listItem" }
    
    let checked: Bool?
    let spread: Bool?
    
    required init?(dict: [AnyHashable: Any]?) {
        let checked = dict?["checked"] as? Bool
        let spread = dict?["spread"] as? Bool
    
        self.checked = checked
        self.spread = spread
        super.init(dict: dict)
    }
}
