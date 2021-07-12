//
//  Point.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

struct Point {
    let column: Int
    let line: Int
    let offset: Int
    
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
