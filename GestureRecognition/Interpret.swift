//
//  Interpret.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/7/21.
//

import Foundation
import PencilKit

extension PKStroke {
    /// Evaluate whether this line is fairly straight, as evaluated by the amount of "turning" done.
    /// - Parameter threshhold: the maximum allowable normalized angle (in radians).
    ///     -  Default determined via experimentation.
    /// - Returns: true if straight
    func normalizedAngleSum() -> CGFloat {
        /// fetch ~50 points from the line
        let pts: [CGPoint] = Array(stride(from: CGFloat.zero, to: CGFloat(path.count), by: CGFloat(path.count) / 50)).map {
            path.interpolatedPoint(at: $0).location
        }
        
        /// approximate the amount of "turning" the line does
        let normalizedAngleSum = (0..<(pts.count - 2)).reduce(0, {
            $0 + abs(angle(pts[$1], pts[$1 + 1], pts[$1 + 2]))
        }) / CGFloat(pts.count)
        
        return normalizedAngleSum
    }
    
    /// maximum allowable normalized angle sum for a "straight" line
    static let maxNAS: CGFloat = 0.08
    
    /// minimum allowable normalized angle sum for a "wavy" line
    static let minNAS: CGFloat = 0.15
    
    func interpret() -> PMShape? {
        let nas = normalizedAngleSum()
        
        if nas < Self.maxNAS && aspectRatio > 2 {
            /// require line to be mostly horizontal and not very wavy
            return .horizontalLine
        } else if nas > Self.minNAS {
            /// require line to be quite wavy
            return .wavyLine
        } else {
            return nil
        }
    }

    /// Ratio of bounding rectangle's width to height
    var aspectRatio: CGFloat {
        renderBounds.width / renderBounds.height
    }
}

