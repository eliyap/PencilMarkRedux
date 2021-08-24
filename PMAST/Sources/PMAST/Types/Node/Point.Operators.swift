//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 23/8/21.
//

import Foundation

/// Sometimes we use this type to offset `Point`s,
/// but we should try to be clear about which we mean.
internal typealias PointOffset = Point

internal extension Point {
    static func +(lhs: Point, rhs: PointOffset) -> Point {
        Point(
            column: lhs.column + rhs.column,
            line: lhs.line + rhs.line,
            offset: lhs.offset + rhs.offset
        )
    }
    
    static func +=( lhs: inout Point, rhs: PointOffset) -> Void {
        lhs = lhs + rhs
    }
}

internal extension Point {
    static func -(lhs: Point, rhs: PointOffset) -> Point {
        Point(
            column: lhs.column - rhs.column,
            line: lhs.line - rhs.line,
            offset: lhs.offset - rhs.offset
        )
    }
    
    static func -=( lhs: inout Point, rhs: PointOffset) -> Void {
        lhs = lhs - rhs
    }
}

internal extension PointOffset {
    static prefix func -(offset: PointOffset) -> PointOffset {
        PointOffset(column: -offset.column, line: -offset.line, offset: -offset.offset)
    }
}
