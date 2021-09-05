//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 22/8/21.
//

import Foundation

internal extension String {
    /// Generate ``Line`` structs.
    /// - Note: if the string terminates in a newline, e.g. `mytext\n`, we consider this to be 2 lines, where the second one is simply ''.
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
        
        /// Invoke with `block` as closure.
        let nsString = NSString(string: self)
        nsString.enumerateSubstrings(in: NSMakeRange(0, nsString.length), options: .byLines, using: block)
        
        /// If the document terminates with a newline, insert a zero-wdith line to validate certain assumptions in the code.
        /// Specifically, this prevents the MDAST `Root` end from sitting on the wrong line after patching.
        if last?.isNewline == true {
            result.append(Line(string: "", substringNsRange: NSMakeRange(nsString.length, 0), enclosingNsRange: NSMakeRange(nsString.length, 0)))
        }
        
        return result
    }
}
