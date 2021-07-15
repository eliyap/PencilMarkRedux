//
//  Node_Equatable.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

extension Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.position == rhs.position && lhs._type == rhs._type
    }
}
