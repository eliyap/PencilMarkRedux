//
//  Content.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

class Content {
    /// The ``Parent``, of which this is a member of ``children``.
    /// `weak` to avoid a strong reference cycle.
    /// Optional because `weak`.
    weak var parent: Node!
    
    /// The position of the substring in the source Markdown that this Node represents.
    var position: Position
    
    /// An internal string for figuring out node type independent of class hierarchy
    var _type: String
    
    init(parent: Node?, position: Position, _type: String) {
        self.parent = parent
        self.position = position
        self._type = _type
    }
}

extension Content {
    /// index in parent's ``children`` array.
    var indexInParent: Int {
        parent.children
            .firstIndex { $0 == self }! /// force unwrap!
    }
}
