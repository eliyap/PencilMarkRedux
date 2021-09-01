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
    
    /// Conduit for pencil strokes.
    @Published var stroke: PKStroke? = nil
    
    /// Conduit for eraser points.
    @Published var location: (CGPoint?, Tool)? = nil
    
    /// Eraser diameter.
    var eraserDiameter: CGFloat = 20
}
