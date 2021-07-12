//
//  MDAST.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import JavaScriptCore

final class Parser {
    
    public static let shared = Parser()
    
    let context: JSContext = JSContext()!
    let url: URL = Bundle.main.url(forResource: "main", withExtension: "js")!
    
    init() {
        context.evaluateScript(try! String(contentsOf: url), withSourceURL: url)
    }
    
    func parse(markdown: String) -> Void {
        let result = context
            .objectForKeyedSubscript("PMJS")
            .objectForKeyedSubscript("parse")
            .call(withArguments: [markdown])
        
        #warning("Unsafe Unwrap!")
        let dict = result!.toDictionary()!
        
        print(Node(dict: dict))
    }
}

class Node {
    let position: Position
    let type: String
    let children: Any
    
    static func construct(from dict: [AnyHashable: Any]?) -> Node? {
        if
            let dict = dict,
            let position = Position(dict: dict["position"] as? [AnyHashable: Any]),
            let type = dict["type"] as? String,
            let children = (dict["children"] as? [[AnyHashable: Any]])?.compactMap({ Node(dict: $0) })
        {
            switch type {
            case "heading":
                return Heading(dict: dict, position: position, type: type, children: children)
                    ?? Node(position: position, type: type, children: children) 
            case "root":
                return Node(position: position, type: type, children: children)
            default:
                return Node(position: position, type: type, children: children)
            }
        } else {
            return nil
        }
    }
    
    convenience init?(dict: [AnyHashable: Any]?) {
        if
            let dict = dict,
            let position = Position(dict: dict["position"] as? [AnyHashable: Any]),
            let type = dict["type"] as? String,
            let children = (dict["children"] as? [[AnyHashable: Any]])?.compactMap({ Node(dict: $0) })
        {
            print(dict.keys.compactMap { $0 as? String })
            print(type)
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

final class Heading: Node {
    let depth: Int
    
    init?(
        dict: [AnyHashable: Any],
        position: Position,
        type: String,
        children: Any
    ) {
        guard
            let depth = dict["depth"] as? Int
        else {
            return nil
        }
        self.depth = depth
        super.init(position: position, type: type, children: children)
    }
}

struct Position {
    let start: Point
    let end: Point

    init?(dict: [AnyHashable: Any]?) {
        guard
            let dict = dict,
            let start = Point(dict: dict["start"] as? [AnyHashable: Any]),
            let end = Point(dict: dict["end"] as? [AnyHashable: Any])
        else {
            return nil
        }
        
        self.init(start: start, end: end)
    }

    init (
        start: Point,
        end: Point
    ) {
        self.start = start
        self.end = end
    }
}

struct Point {
    let column: Int
    let line: Int
    let offset: Int
    
    init?(dict: [AnyHashable: Any]?) {
        guard
            let dict = dict,
            let column = dict["column"] as? Int,
            let line = dict["line"] as? Int,
            let offset = dict["offset"] as? Int
        else {
            return nil
        }
        
        self.init(column: column, line: line, offset: offset)
    }
    
    init (
        column: Int,
        line: Int,
        offset: Int
    ) {
        self.column = column
        self.line = line
        self.offset = offset
    }
}
