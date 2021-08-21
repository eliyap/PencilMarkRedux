//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 21/8/21.
//

import Foundation

internal extension String {
    /// Represents one line in a larger multi lined document.
    /// Generated by method `enumerateSubstrings`.
    /// Docs: https://developer.apple.com/documentation/foundation/nsstring/1416774-enumeratesubstrings
    struct Line {
        let string: String
        let substringNsRange: NSRange
        let enclosingNsRange: NSRange
    }
    
    /// Generate ``Line`` structs.
    func makeLines() -> [Line] {
        
        var result: [Line] = []
        
        /// Docs: https://developer.apple.com/documentation/foundation/nsstring/1416774-enumeratesubstrings
        func block(substring: String?, substringRange: NSRange, enclosingRange: NSRange, stop: UnsafeMutablePointer<ObjCBool>) -> Void {
            guard let substring = substring else {
                /// Unsure what conditions generate a `nil` substring, guess we find out?
                assert(false, "Unexpected empty substring")
                return
            }
            
            /// Perform safety checks.
            precondition(substring == self[Range(substringRange, in: self)!], "Inconsistent Substring!")
            precondition(substring.filter(\.isNewline).count == 0, "Newline char found in Line!")
            
            result.append(Line(string: substring, substringNsRange: substringRange, enclosingNsRange: enclosingRange))
        }
        
        /// Invoke with block
        let nsString = NSString(string: self)
        nsString.enumerateSubstrings(in: NSMakeRange(0, nsString.length), options: .byLines, using: block)
        
        return result
    }
}

extension String {
    /// Whether this string has anything besides whitespace.
    var isBlank: Bool {
        filter{$0.isWhitespace == false}.count == 0
    }
}

extension String {
    /// Whether this line potentially continues a Markdown block container as defined in the GFM spec:
    /// https://github.github.com/gfm
    var isPotentiallyContinuation: Bool {
        if isEmpty { return false }
        
        /// By #242, any leading whitespace might make this line part of an indented list: https://github.github.com/gfm/#example-242
        if first!.isWhitespace { return true }
        
        /// By #286, any list item may continue a list. https://github.github.com/gfm/#example-286
        if isOrderedListItem() || isUnorderedListItem() { return true }
        
        return false
    }
    
    /// We may assume the `String` does not begin with whitespace and is non empty.
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

extension Character {
    /// Docs: https://github.github.com/gfm/#list-marker
    var isListMarker: Bool {
        self == "-" || self == "+" || self == "*"
    }
}
