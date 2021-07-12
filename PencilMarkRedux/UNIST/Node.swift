//
//  Node.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

protocol Node {
    var position: Position { get }
    var type: String { get }
    var children: Any { get }
}

func construct(from dict: [AnyHashable: Any]?) -> Node? {
    if
        let dict = dict,
        let position = Position(dict: dict["position"] as? [AnyHashable: Any]),
        let type = dict["type"] as? String,
        let children = (dict["children"] as? [[AnyHashable: Any]])?.compactMap({ construct(from: $0) })
    {
        switch type {
        case "heading":
            return Heading(dict: dict, position: position, type: type, children: children)
        case "root":
            return Root(dict: dict)
        default:
            return Root(dict: dict)
        }
    } else {
        return nil
    }
}

class Root: Node {
    let position: Position
    let type: String
    let children: Any
    
    
    
    convenience init?(dict: [AnyHashable: Any]?) {
        if
            let dict = dict,
            let position = Position(dict: dict["position"] as? [AnyHashable: Any]),
            let type = dict["type"] as? String,
            let children = (dict["children"] as? [[AnyHashable: Any]])?.compactMap({ construct(from: $0) })
        {
            var keys = Set(dict.keys.compactMap { $0 as? String })
            keys.subtract(["position", "type", "children"])
            if keys.isEmpty == false  { print("Uncaught keys: \(keys) for \(type)") }
            
            self.init(position: position, type: type, children: children)
        } else {
            return nil
        }
    }
    
    init(
        position: Position,
        type: String,
        children: Any
    ) {
        self.position = position
        self.type = type
        self.children = children
    }
}
