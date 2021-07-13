//
//  Content_Equatable.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

extension Content: Equatable {
    static func == (lhs: Content, rhs: Content) -> Bool {
        lhs.position == rhs.position && lhs._type == rhs._type
    }
}
