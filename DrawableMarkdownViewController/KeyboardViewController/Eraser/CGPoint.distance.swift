//
//  CGPoint.distance.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 19/8/21.
//

import CoreGraphics

internal extension CGPoint {
    func within(_ threshold: CGFloat, of other: CGPoint) -> Bool {
        distance(to: other) <= threshold
    }
    
    func distance(to other: CGPoint) -> CGFloat {
        sqrt(pow(x - other.x, 2) + pow(y - other.y, 2))
    }
}
