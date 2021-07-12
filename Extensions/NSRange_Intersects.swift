//
//  NSRange_Intersects.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

extension NSRange {
    func intersects(with other: NSRange) -> Bool {
        return (other.lowerBound <= lowerBound && lowerBound <= other.upperBound) || (other.lowerBound <= upperBound && upperBound <= other.upperBound)
    }
}
