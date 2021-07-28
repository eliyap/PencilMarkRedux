//
//  PKStrokePoint_Init.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import PencilKit

extension PKStrokePoint {
    
    /// stroke size, must be non-zero
    private static let size = CGSize(width: 3, height: 3)
    
    /**
     Quick and dirty initializer.
     Uses some plausible values for fields I don't really care about.
     */
    init(at location: CGPoint) {
        self.init(
            location: location,
            timeOffset: .zero,
            size: Self.size,
            opacity: 1,
            force: 1,
            azimuth: .zero,
            altitude: .zero
        )
    }
}

