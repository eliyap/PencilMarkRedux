//
//  Path_BezierCurve.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/7/21.
//

import SwiftUI

internal extension Path {
    /**
     Creates a Bezier Curve SwiftUI `Path` that passes through the provided `vertices`.
     Backs the transformation from `PKStrokePath` to SwiftUI `Path`.
     https://www.particleincell.com/2012/bezier-splines/
     Ported to Swift by Elijah Yap, based on https://www.particleincell.com/wp-content/uploads/2012/06/circles.svg
     */
    init(with vertices: [CGPoint]) {
        /// Computes control points `p1` and `p2` for `x` and `y` direction.
        let px = computeControlPoints(knots: vertices.map{ $0.x })
        let py = computeControlPoints(knots: vertices.map{ $0.y })
        
        /// Updates path settings.
        self.init { path in
            path.move(to: vertices[0])
            
            /// short circuit an empty list (for very short lines)
            guard !(px.p1.isEmpty || px.p2.isEmpty || py.p1.isEmpty || py.p2.isEmpty) else {
                return
            }
            
            for i in 0..<(vertices.count-1) {
                path.addCurve(
                    to: vertices[i+1],
                    control1: CGPoint(x: px.p1[i], y: py.p1[i]),
                    control2: CGPoint(x: px.p2[i], y: py.p2[i])
                )
            }
        }
    }
}

/**
 Computes control points given `knots`, this is the brain of the operation.
 https://www.particleincell.com/2012/bezier-splines/
 Ported to Swift by Elijah Yap, based on https://www.particleincell.com/wp-content/uploads/2012/06/circles.svg
 */
fileprivate func computeControlPoints(knots: [CGFloat]) -> (p1: [CGFloat], p2: [CGFloat]) {
    let n = knots.count - 1
    guard n > 1 else {
        return ([], [])
    }
    
    var p1 = [CGFloat](repeating: .zero, count: n)
    var p2 = [CGFloat](repeating: .zero, count: n)
    
    /*rhs vector*/
    var a = [CGFloat](repeating: .zero, count: n)
    var b = [CGFloat](repeating: .zero, count: n)
    var c = [CGFloat](repeating: .zero, count: n)
    var r = [CGFloat](repeating: .zero, count: n)
    
    /*left most segment*/
    a[0] = 0
    b[0] = 2
    c[0] = 1
    r[0] = knots[0] + 2 * knots[1]
    
    /*internal segments*/
    for i in (1..<(n-1)) {
        a[i] = 1
        b[i] = 4
        c[i] = 1
        r[i] = 4 * knots[i] + 2 * knots[i+1]
    }
            
    /*right segment*/
    a[n-1] = 2
    b[n-1] = 7
    c[n-1] = 0
    r[n-1] = 8 * knots[n-1] + knots[n]
    
    /*solves Ax=b with the Thomas algorithm (from Wikipedia)*/
    for i in (1..<n) {
        let m = a[i] / b[i-1]
        b[i] = b[i] - m * c[i-1]
        r[i] = r[i] - m*r[i-1]
    }
 
    p1[n-1] = r[n-1] / b[n-1];
    for i in stride(from: n-2, through: 0, by: -1) {
        p1[i] = (r[i] - c[i] * p1[i+1]) / b[i]
    }
        
    /*we have p1, now compute p2*/
    for i in 0..<(n-1) {
        p2[i] = 2 * knots[i+1] - p1[i+1]
    }
    
    p2[n-1] = 0.5 * (knots[n] + p1[n-1])
    
    return (p1: p1, p2: p2)
}

