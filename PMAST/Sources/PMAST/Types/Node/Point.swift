//
//  Point.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

/**
 Reflects a UNIST Point.
 */
public struct Point {
    
    /// Column in a source file (1-indexed integer).
    let column: Int
    
    /// Line in a source file (1-indexed integer).
    let line: Int
    
    /// Character in a source file (0-indexed integer).
    var offset: Int
    
    init?(dict: [AnyHashable: Any]?) {
        guard
            let dict = dict,
            let column = dict["column"] as? Int,
            let line = dict["line"] as? Int,
            let offset = dict["offset"] as? Int
        else {
            print("Failed to initialize Point")
            return nil
        }
        
        self.init(column: column, line: line, offset: offset)
    }
    
    init (
        column: Int,
        line: Int,
        offset: Int
    ) {
        self.column = column
        self.line = line
        self.offset = offset
    }
}

extension Point: Equatable {
    
}

extension Point: Hashable {
    
}
