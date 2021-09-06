//
//  String_Subscript.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

/// define accessor via int
extension String {
    subscript(idx: Int) -> Index {
        get {
            index(startIndex, offsetBy: idx)
        }
    }
    
    subscript(range: Range<Int>) -> Substring {
        get {
            self[self[range.lowerBound]..<self[range.upperBound]]
        }
    }
    
    mutating func replace<T: StringProtocol>(from start: Int, to end: Int, with replacement: T) -> Void {
        let utf16start: UTF16View.Index = utf16.index(utf16.startIndex, offsetBy: start)
        let strStart = utf16start.samePosition(in: self)!
        
        let utf16end: UTF16View.Index = utf16.index(utf16.startIndex, offsetBy: end)
        let strEnd = utf16end.samePosition(in: self)!
        
        replaceSubrange(strStart..<strEnd, with: replacement)
    }
}

extension String {
    subscript(range: NSRange) -> Substring {
        get {
            self[self[range.lowerBound]..<self[range.upperBound]]
        }
    }
}
