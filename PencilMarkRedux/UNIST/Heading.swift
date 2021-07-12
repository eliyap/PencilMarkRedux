//
//  Heading.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

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

