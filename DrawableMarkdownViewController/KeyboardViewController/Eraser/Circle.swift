//
//  Circle.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 19/8/21.
//

import CoreGraphics

struct Circle {
    let center: CGPoint
    let radius: CGFloat
    
    var bounds: CGRect {
        CGRect(origin: CGPoint(x: center.x - radius, y: center.y - radius), size: CGSize(width: 2 * radius, height: 2 * radius))
    }
}
