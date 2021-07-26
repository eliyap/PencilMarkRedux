//
//  PKStroke_Init.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import PencilKit

extension PKStroke {
    /// Initialize with two dummy control points
    init() {
        self.init(
            ink: .init(.pen),
            path: PKStrokePath(
                controlPoints: [
                    .init(at: .zero),
                    .init(at: .zero),
                ],
                creationDate: Date()
            )
        )
    }
}
