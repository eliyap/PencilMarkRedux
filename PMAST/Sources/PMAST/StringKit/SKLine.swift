//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 21/8/21.
//

import Foundation

/// Represents one line in a larger multi lined document.
/// Generated by method `enumerateSubstrings`.
/// Docs: https://developer.apple.com/documentation/foundation/nsstring/1416774-enumeratesubstrings
internal struct SKLine {
    let string: String
    let substringNsRange: NSRange
    let enclosingNsRange: NSRange
}

extension SKLine : Equatable {
    /// Compare strings by their contents only, not their ranges.
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.string == rhs.string
    }
}
