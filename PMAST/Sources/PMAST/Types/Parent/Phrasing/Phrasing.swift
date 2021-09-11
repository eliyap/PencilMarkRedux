//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 11/9/21.
//

import Foundation

/// Effectively a mixin.
protocol Phrasing: Parent {
    func whitespaceContractedEnd(in text: String) -> Point
}

extension Phrasing {
    /// In the event of an error, return this offset.
    /// Typically, both start and end will return the same offset, yielding a blank range.
    var defaultOffset: Point { position.start }
    
    func whitespaceContractedStart(in text: String) -> Point {
        let rangeEnd = text.index(from: position.end.offset)
        var strIdx: String.Index = text.index(from: position.start.offset)
        
        /// Flags that our contents are pure whitespace.
        var isBlank = false
        
        while text[strIdx].isWhitespace {
            strIdx = text.index(after: strIdx)
            guard strIdx != rangeEnd else {
                isBlank = true
                break
            }
        }
        
        guard isBlank == false else {
            return defaultOffset
        }
        
        return Point(index: strIdx, in: text)
    }
    
    func whitespaceContractedEnd(in text: String) -> Point {
        let rangeStart = text.index(from: position.start.offset)
        var strIdx: String.Index = text.index(from: position.end.offset)
        
        /// Flags that our contents are pure whitespace.
        var isBlank = false
        
        repeat {
            strIdx = text.index(before: strIdx)
            guard strIdx != rangeStart else {
                isBlank = true
                break
            }
        } while text[strIdx].isWhitespace
        
        guard isBlank == false else {
            return defaultOffset
        }
        
        /// Step forwards to get the "past the end" index.
        strIdx = text.index(after: strIdx)
        
        return Point(index: strIdx, in: text)
    }
}
