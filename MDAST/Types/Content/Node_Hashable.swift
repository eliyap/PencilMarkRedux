//
//  Node_Hashable.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

extension Node: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
        hasher.combine(_type)
    }
}
