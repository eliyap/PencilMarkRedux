//
//  Content.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

class Content {
    weak var parent: Node!
    let position: Position
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
