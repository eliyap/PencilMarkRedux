//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 22/8/21.
//

import Foundation

/**
 # Markdown Filters
 
 Various crude checks to see if some string might mean something in Markdown.
 */

extension String {
    /// Whether this string has anything besides whitespace.
    internal var isBlank: Bool {
        filter{$0.isWhitespace == false}.count == 0
    }
}

extension String {
    /// Whether this line potentially continues a Markdown block container as defined in the GFM spec:
    /// https://github.github.com/gfm
    internal var isPotentiallyContinuation: Bool {
        if isEmpty { return false }
        
        /// By #242, any leading whitespace might make this line part of an indented list: https://github.github.com/gfm/#example-242
        if first!.isWhitespace { return true }
        
        /// By #286, any list item may continue a list. https://github.github.com/gfm/#example-286
        if isOrderedListItem() || isUnorderedListItem() { return true }
        
        return false
    }
    
    /// We may assume the `String` does not begin with whitespace and is non empty.
    /// `public` to enable testing.
    public func isUnorderedListItem() -> Bool {
        /// .#259: https://github.github.com/gfm/#example-259
        /// Just a list marker by itself can signify an empty list item.
        if self.count == 1 && first!.isListMarker {
            return true
        }
        
        /// Otherwise, a `ul` list item is defined by a list marker, then at least one whitespace.
        if
            first!.isListMarker,
            /// Safety check that index is valid.
            index(after: startIndex) < endIndex,
            self[index(after: startIndex)].isWhitespace
        {
            return true
        }
        
        return false
    }
    
    /// We may assume the `String` does not begin with whitespace and is non empty.
    /// `public` to enable testing.
    public func isOrderedListItem() -> Bool {
        var numCount = 0
        var idx: Index = startIndex
        
        /// Break on > 9 numbers, or end of line when there were only numbers.
        /// > 9 numbers not valid: https://github.github.com/gfm/#ordered-list-marker
        while numCount <= 9, idx < endIndex  {
            /// Count up each number we find
            if self[idx].isNumber {
                numCount += 1
                idx = index(after: idx)
                continue
            } else {
                /// Numbers have ended, time to start next phase of checking!
                
                /// Reject anything not starting with a number
                if numCount == 0 { return false }
                
                /// `<ol>` items must end in `.` or `)`
                if self[idx] != "." && self[idx] != ")" { return false }
                
                let next = index(after: idx)
                /// .#259: https://github.github.com/gfm/#example-259
                /// Just a list marker by itself can signify an empty list item.
                if next == endIndex {
                    return true
                } else if self[next].isWhitespace {
                    return true /// If there is whitespace, it's a proper list item!
                } else {
                    return false /// Not a proper list item
                }
            }
        }
        
        return false
    }
}

fileprivate extension Character {
    /// Docs: https://github.github.com/gfm/#list-marker
    var isListMarker: Bool {
        self == "-" || self == "+" || self == "*"
    }
}
