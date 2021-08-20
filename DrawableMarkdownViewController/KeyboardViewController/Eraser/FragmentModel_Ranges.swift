//
//  FragmentModel_Ranges.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 19/8/21.
//

import Foundation

extension FragmentModel {
    public func getMergedRanges() -> [NSRange] {
        merge(getStyledRanges())
    }
    
    /// Find all styled ranges in fragments.
    private func getStyledRanges() -> [NSRange] {
        fragments
            .map { $0.styledRanges }
            .reduce([], +)
    }
    
    /// A mutable analogue to `NSRange`.
    fileprivate struct MutableRange {
        var lowerBound: Int
        var upperBound: Int
        var length: Int { upperBound - lowerBound }
        
        /// Creates an identical `NSRange`.
        var nsRange: NSRange { NSMakeRange(lowerBound, length) }
    }
    
    /// Merge the passed **non-overlapping** `ranges` where possible.
    /// Result is sorted in ascending order.
    private func merge(_ ranges: [NSRange]) -> [NSRange] {
        guard ranges.isEmpty == false else { return [] }
        
        let ranges = ranges.sorted { $0.lowerBound < $1.lowerBound }
        
        var result: [NSRange] = []
        
        var temp = MutableRange(lowerBound: ranges[0].lowerBound, upperBound: ranges[0].upperBound)
        for range in ranges[1...] {
            switch (temp.upperBound, range.lowerBound) {
            case let (x, y) where x == y:
                /// Ranges are contiguous, so merge them by bumping the bounds.
                temp.upperBound = range.upperBound
            
            case let (x, y) where x < y:
                /// Ranges are non-contiguous, so break away to make a new range.
                result.append(temp.nsRange)
                temp = MutableRange(lowerBound: range.lowerBound, upperBound: range.upperBound)
            
            case let (x, y) where x > y:
                fatalError("Overlapping Ranges \(temp) and \(range)")
            
            default:
                fatalError("Impossible Case!")
            }
        }
        
        /// Insert final range.
        result.append(temp.nsRange)
        
        return result
    }
}
