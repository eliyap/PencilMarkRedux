//
//  Literal.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

class Literal: Content {
    
    /// This ``Literal``'s parent ``Node``.
    /// `weak` to avoid a strong reference cycle.
    /// Optional because `weak`.
    weak var parent: Node!
    
    /// The position of the substring in the source Markdown that this Node represents.
    let position: Position
    
    class var type: String { "literal" }
    
    let value: String
    
    /// An internal string for figuring out node type independent of class hierarchy
    var _type: String = "Node"
    
    
    required init?(dict: [AnyHashable: Any]?, parent: Node?) {
        if
            let position = Position(dict: dict?["position"] as? [AnyHashable: Any]),
            let value = dict?["value"] as? String,
            let _type = dict?["type"] as? String
        {
            self.parent = parent
            self.position = position
            self.value = value
            self._type = _type
        } else {
            print("Failed to initalize literal of type \(dict?["type"] as? String ?? "No Type")!")
            print("Dict: \(dict)")
            return nil
        }
    }
}
