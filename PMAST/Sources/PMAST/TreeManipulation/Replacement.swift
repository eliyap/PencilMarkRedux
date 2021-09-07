//
//  Replacement.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 23/7/21.
//

import Foundation

/// Represents a string replacement that needs to be made in the Markdown
struct Replacement {
    let range: NSRange
    let replacement: String
}

extension Replacement {
    /// Indicates that this replacement removes or inserts something.
    var isNotNoOp: Bool {
        return range.length != 0 || replacement.isEmpty == false
    }
}

extension Replacement: Comparable {
    /**
     Sort in descending order of position.
     Sort insertions to be after deletions (an insertion has ``range`` length 0).
     
     Replacement should go:
     1. remove: (X, 2) => ""
     2. insert: (X, 0) => "~~"
     
     Then combined they are:
     - replace: (X, 2) => "~~"
     */
    static func < (lhs: Replacement, rhs: Replacement) -> Bool {
        /// First, sort by descending order of position.
        guard lhs.range.lowerBound == rhs.range.lowerBound else {
            return lhs.range.lowerBound > rhs.range.lowerBound
        }
        
        switch (lhs.range.length, rhs.range.length) {
        case (0, 0):
            assert(false, "Ambiguous Ordering of Insertion!\nLHS: \(lhs)\nRHS: \(rhs)")
            return true
        case (_, 0):
            return true
        case (0, _):
            return false
        default:
            fatalError("Overlapping Ranges!")
        }
    }
}
