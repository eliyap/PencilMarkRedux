//
//  NSRange_Intersects.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

extension NSRange {
    /**
     Intersection cases
     ```
     A intersects B from the left:
     a---A
      b---B
     
     A intersects B from the right:
      a---A
     b---B
     
     A encloses B:
     a-----A
       b-B
     
     A is enclosed by B
       a-A
     b-----B
     
     always true that A>b, B>a
     ```
     */
    func intersects(with other: NSRange) -> Bool {
        return other.lowerBound < upperBound && other.upperBound > lowerBound
    }
}

extension NSRange {
    /// Assumes an intersection does exist, and finds it.
    func intersection(with other: Self) -> Self {
        let lowerBound = max(other.lowerBound, lowerBound)
        let upperBound = min(other.upperBound, upperBound)
        return NSMakeRange(lowerBound, upperBound - lowerBound)
    }
}
