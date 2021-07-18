//
//  FrameConduit.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 16/7/21.
//

import Foundation
import CoreGraphics

/// Combine conduit for passing view frame `CGRect`s between `UIKit` views.
final class FrameConduit: ObservableObject {
    /// Passes `UITextView` preferred size to `PKCanvasView`.
    @Published var contentSize: CGSize? = nil
    
    /// Passes `PKCanvasView` scroll offset to `UITextView`.
    @Published var scrollY: CGFloat = .zero
    
    /// Passes tap event locations from `CanvasView` to `UITextView`.
    @Published var tapLocation: CGPoint? = nil
}
