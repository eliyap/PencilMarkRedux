//
//  StrokeConduit.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import PencilKit

/// Combine conduit for passing `PKStroke`s between `UIKit` views.
final class PencilConduit: ObservableObject {
    
    static let shared = PencilConduit()
    
    @Published var stroke: PKStroke? = nil
}
