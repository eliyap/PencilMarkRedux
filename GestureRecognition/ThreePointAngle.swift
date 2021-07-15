//
//  ThreePointAngle.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/7/21.
//

import SwiftUI

/// Represents a directed vector from one 2D point to another
struct Vector {
    
    let x: CGFloat
    let y: CGFloat
    
    init(from a: CGPoint, to b: CGPoint) {
        x = b.x - a.x
        y = b.y - a.y
    }
    
    /// Eulerian Distance
    var length: CGFloat {
        sqrt(x * x + y * y)
    }
    
    /// standard dot product
    func dot(with other: Vector) -> CGFloat {
        x * other.x + y * other.y
    }
}

/// Given a triangle formed by points ABC, returns pi - the internal angle at B (or the external angle - pi).
func angle(_ a: CGPoint, _ b: CGPoint, _ c: CGPoint) -> CGFloat {
    let ab = Vector(from: a, to: b)
    let bc = Vector(from: b, to: c)
    return acos(ab.dot(with: bc) / (ab.length * bc.length))
}

