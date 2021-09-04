//
//  Literal.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

public class Literal: Node {
    
    override class var type: String { "literal" }
    
    let value: String
    
    required init?(dict: [AnyHashable: Any]?, parent: Parent?, text: String) {
        if
            let position = Position(dict: dict?["position"] as? [AnyHashable: Any]),
            let value = dict?["value"] as? String,
            let _type = dict?["type"] as? String
        {
            self.value = value
            super.init(parent: parent, position: position, _type: _type)
        } else {
            print("Failed to initalize literal of type \(dict?["type"] as? String ?? "No Type")!")
            print("Dict: \(String(describing: dict))")
            return nil
        }
    }
    
    required init(_ node: Node, parent: Parent!) {
        value = (node as! Literal).value
        super.init(node, parent: parent)
    }
    
    /// Explicit member wise `init`.
    init(
        parent: Parent?,
        position: Position,
        _type: String,
        value: String
    ) {
        self.value = value
        super.init(parent: parent, position: position, _type: _type)
    }
    
    override public var description: [Event] {[
        .enter(point: position.start, type: _type),
        .contents(value),
        .exit(point: position.end, type: _type),
    ]}
}
