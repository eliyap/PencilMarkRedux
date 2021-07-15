//
//  StraightLine.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/7/21.
//

import Foundation
import PencilKit

extension PKStroke {
    /// Assumes this PKStroke is a straight, horizontal line (corresponding to ``PMShape.horizontalLine``)
    /// Finds two points which form a perfectly horizontal straight line, representing an form of the ``PKStroke``'s ``path``.
    /// Does this by finding the y-"center of mass" of the line.
    func straightened() -> (leading: CGPoint, trailing: CGPoint) {
        /// the distance to step along the path
        var distance: CGFloat = 8

        var slice: PKStrokePath.InterpolatedSlice
        slice = path.interpolatedPoints(by: .distance(distance))

        /// Step along shorter and shorter distances until we get enough points
        /// number is arbitrary, we just want a good number.
        while slice.count < 16 {
            distance /= 2
            slice = path.interpolatedPoints(by: .distance(distance))
        }
        
        /// calculate the mean y-coordinate
        let points: [CGPoint] = slice.map { $0.location }
        let totalY = points.map { $0.y }.reduce(0, +)
        let meanY = totalY / CGFloat(points.count)
        
        return (
            leading: CGPoint(x: renderBounds.minX, y: meanY),
            trailing: CGPoint(x: renderBounds.maxX, y: meanY)
        )
    }
}

extension PKStrokePath.InterpolatedSlice {
    /// Counts the number of points in this interpolated slice.
    /// A more accurate alternative to ``underestimatedCount``.
    var count: Int {
        reduce(0) { count, _ in count + 1 }
    }
}
