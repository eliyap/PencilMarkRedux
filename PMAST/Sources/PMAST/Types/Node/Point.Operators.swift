//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 23/8/21.
//

import Foundation

public extension Point {
    static func +(lhs: Self, rhs: Self) -> Self {
        Point(
            column: lhs.column + rhs.column,
            line: lhs.line + rhs.line,
            offset: lhs.offset + rhs.offset
        )
    }
    
    static func +=( lhs: inout Self, rhs: Self) -> Void {
        lhs = lhs + rhs
    }
}

public extension Point {
    static func -(lhs: Self, rhs: Self) -> Self {
        Point(
            column: lhs.column - rhs.column,
            line: lhs.line - rhs.line,
            offset: lhs.offset - rhs.offset
        )
    }
    
    static func -=( lhs: inout Self, rhs: Self) -> Void {
        lhs = lhs - rhs
    }
}
