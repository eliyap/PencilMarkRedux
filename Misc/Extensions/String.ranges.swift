//
//  String.ranges.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 19/9/21.
//

import Foundation

extension StringProtocol {
    /// Find all ranges of a particular substring.
    func ranges(of substr: String) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var idx = startIndex
        while idx < index(endIndex, offsetBy: -substr.count) {
            if let range = self[idx..<index(idx, offsetBy: substr.count)].range(of: substr) {
                result.append(range)
            }
            idx = index(after: idx)
        }
        return result
    }
    
    /// Find all `NSRange`s of a particular substring.
    func nsRanges(of substr: String) -> [NSRange] {
        var result: [NSRange] = []
        var idx = startIndex
        while idx < index(endIndex, offsetBy: -substr.count) {
            if let range = self[idx..<index(idx, offsetBy: substr.count)].range(of: substr) {
                let low = range.lowerBound.utf16Offset(in: self)
                let upp = range.upperBound.utf16Offset(in: self)
                result.append(NSMakeRange(low, upp - low))
            }
            idx = index(after: idx)
        }
        return result
    }
}
