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
        replaceSubrange(index(startIndex, offsetBy: start)..<index(startIndex, offsetBy: end), with: replacement)
    }
}

extension String {
    subscript(range: NSRange) -> Substring {
        get {
            self[self[range.lowerBound]..<self[range.upperBound]]
        }
    }
}
