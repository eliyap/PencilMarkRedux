//
//  PKStrokePath_Path.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/7/21.
//

import PencilKit
import SwiftUI

internal extension PKStrokePath {
    /// convert `PKStroke` to  identical looking SwiftUI `Path` composed of Bezier Curves
    var asPath: Path {
        Path(with: interpolatedPts)
    }
}

fileprivate extension PKStrokePath {
    
    var interpolatedPts: [CGPoint] {
        var pts: [CGPoint] = []
        var distance: CGFloat = 64
        /// if you get fewer than the about half the spline points, halve the distance and try again
        while pts.count < endIndex / 2 {
            pts = interpolatedPoints(by: .distance(distance))
                .map{$0.location}
            distance /= 2
        }
        return pts
    }
}
