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
    
    required init?(dict: [AnyHashable: Any]?, parent: Parent?) {
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
}
