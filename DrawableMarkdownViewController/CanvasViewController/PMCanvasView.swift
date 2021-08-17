//
//  PMCanvasView.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 16/7/21.
//

import Foundation
import PencilKit

final class PMCanvasView: PKCanvasView {
    /// Currently a no-op
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        switch touch.type {
        case .direct:
            break
        default:
            break
        }
    }
}

// MARK: - UIResponder Methods
extension PMCanvasView {
    /** - Note: does not fire on finger scroll, but does fire if finger drags when view cannot scroll */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let delegate = delegate as? CanvasViewController else {
            assert(false, "Unexpected wrong controller!")
            return
        }
        
        guard
            delegate.coordinator.tool == .eraser,
            let touch = touches.first,
            /// a perfectly perpendicular input indicates a finger is being used
            touch.altitudeAngle != CGFloat.pi / 2
        else {
            return
        }
        
        print("touch")
//        eraserActive = true
//
//        /// correct for scrolling offset before sending
//        var location = touch.preciseLocation(in: view)
//        trackCircle(location: location)
//
//        location.y -= self.contentOffset.y
//        eraserConduit.location = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        /// reject end events that result from finger taps
//        guard eraserActive else { return }
//
//        removeCircle()
//        eraserConduit.location = .none
//        eraserActive = false
    }
}
