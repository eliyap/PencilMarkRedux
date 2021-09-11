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
    var column: Int
    
    /// Line in a source file (1-indexed integer).
    var line: Int
    
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
    
    /// Derive a "two dimensional" `Point` from a "one dimensional" string offset.
    init(index: String.Index, in string: String) {
        self.init(utf16Offset: index.utf16Offset(in: string), in: string)
    }
    init(utf16Offset: Int, in string: String) {
        precondition(utf16Offset >= 0, "Out of bounds!")
        precondition(utf16Offset <= string.utf16.count, "Out of bounds!")
        
        let lines = string.makeLines()
        var lineNo = lines.firstIndex { $0.enclosingNsRange.lowerBound <= utf16Offset && utf16Offset < $0.enclosingNsRange.upperBound }
        if let lineNo = lineNo {
            self.line = lineNo + 1 /// account for one-indexing
        } else {
            precondition(utf16Offset == string.utf16.count, "Failed to find line!")
            lineNo = lines.endIndex - 1
            self.line = lines.endIndex
        }
        
        self.column = utf16Offset - lines[lineNo!].enclosingNsRange.lowerBound
        self.column += 1 /// account for one-indexing
        
        self.offset = utf16Offset
    }
}

extension Point: Equatable {
    
}

extension Point: Hashable {
    
}
