//
//  CGRect.clipped.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 5/9/21.
//

import CoreGraphics

extension CGRect {
    /**
     If ``CGRect`` is taller than `maxHeight`, chop off the top part,
     moving the top edge downwards.
     */
    func clipped(to maxHeight: CGFloat) -> Self {
        let heightDiff = max(0, height - maxHeight)
        return CGRect(
            x: origin.x,
            y: origin.y + heightDiff,
            width: width,
            height: height - heightDiff
        )
    }
}
