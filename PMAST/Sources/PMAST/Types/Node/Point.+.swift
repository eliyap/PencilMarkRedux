//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 23/8/21.
//

import Foundation

extension Point {
    static func +(lhs: Self, rhs: Self) -> Self {
        Point(
            column: lhs.column + rhs.column,
            line: lhs.line + rhs.line,
            offset: lhs.offset + rhs.offset
        )
    }
}
