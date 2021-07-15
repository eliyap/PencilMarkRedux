//
//  Literal.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

class Literal: Content {
    
    class var type: String { "literal" }
    
    let value: String
    
    required init?(dict: [AnyHashable: Any]?, parent: Node?) {
        if
            let position = Position(dict: dict?["position"] as? [AnyHashable: Any]),
            let value = dict?["value"] as? String,
            let _type = dict?["type"] as? String
        {
            self.value = value
            super.init(parent: parent, position: position, _type: _type)
//            self.parent = parent
//            self.position = position
//            self._type = _type
        } else {
            print("Failed to initalize literal of type \(dict?["type"] as? String ?? "No Type")!")
            print("Dict: \(dict)")
            return nil
        }
    }
}
