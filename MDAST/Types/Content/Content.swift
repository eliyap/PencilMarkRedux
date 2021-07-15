//
//  Content.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

class Node {
    /// The ``Parent``, of which this is a member of ``children``.
    /// `weak` to avoid a strong reference cycle.
    /// Optional because `weak`.
    weak var parent: Parent!
    
    /// The position of the substring in the source Markdown that this Node represents.
    var position: Position
    
    /// An internal string for figuring out node type independent of class hierarchy
    var _type: String
    
    /// The string marking the node's class in JavaScript.
    class var type: String { "thematicBreak" }
    init(parent: Parent?, position: Position, _type: String) {
        self.parent = parent
        self.position = position
        self._type = _type
    }
}

extension Node {
    /// index in parent's ``children`` array.
    var indexInParent: Int {
        parent.children
            .firstIndex { $0 == self }! /// force unwrap!
    }
}
