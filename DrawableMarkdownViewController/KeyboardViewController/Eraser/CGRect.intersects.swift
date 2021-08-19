//
//  CGRect.intersects.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 19/8/21.
//

import CoreGraphics

internal extension CGRect {
    func intersects(_ circle: Circle) -> Bool {
        guard intersects(circle.bounds) else { return false }
        /// Checks if rectangle...
        
        /// Contains circle's center.
        return contains(circle.center)
            
            /// Between x-range, and within acceptable y-range.
            || ((minX <= circle.center.x && circle.center.x <= maxX) && (abs(minY - circle.center.y) <= circle.radius || abs(maxY - circle.center.y) <= circle.radius))
            
            /// Between y-range, and within acceptable x-range.
            || ((minY <= circle.center.y && circle.center.y <= maxY) && (abs(minX - circle.center.x) <= circle.radius || abs(maxX - circle.center.x) <= circle.radius))
        
            /// Within radius of each of the four corners.
            || CGPoint(x: minX, y: minY).within(circle.radius, of: circle.center)
            || CGPoint(x: minX, y: maxY).within(circle.radius, of: circle.center)
            || CGPoint(x: maxX, y: minY).within(circle.radius, of: circle.center)
            || CGPoint(x: maxX, y: maxY).within(circle.radius, of: circle.center)
    }
}
