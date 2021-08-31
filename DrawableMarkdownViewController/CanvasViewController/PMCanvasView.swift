//
//  PMCanvasView.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 16/7/21.
//

import Foundation
import PencilKit

final class PMCanvasView: PKCanvasView {
    
    /// Contains a circle that indicates the eraser's position.
    var circleLayer: CAShapeLayer? = nil
    
    /// Tracks whether the eraser tool is currently being dragged.
    var eraserDown = false
    
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
            let touch = touches.first,
            /// a perfectly perpendicular input indicates a finger is being used
            touch.altitudeAngle != CGFloat.pi / 2
        else {
            return
        }
        
        switch delegate.coordinator.tool {
        case .eraser:
            eraserDown = true
            let location = touch.preciseLocation(in: self)
            trackCircle(location: location)
            PencilConduit.shared.eraser = location
        default:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        /// Reject end events that result from finger taps.
        guard eraserDown else { return }

        removeCircle()
        PencilConduit.shared.eraser = nil
        eraserDown = false
    }
}

// MARK: - Visual Eraser Indicator
extension PMCanvasView {

    /// Places a visual representation of the eraser under the pencil tip.
    fileprivate func trackCircle(location: CGPoint) -> Void {
        
        let cl = getOrInitCircleLayer()
        
        var location = location
        let size = PencilConduit.shared.eraserDiameter
        
        /// Center circle.
        location.x -= size / 2
        location.y -= size / 2
        
        cl.path = UIBezierPath(ovalIn: CGRect(x: location.x, y: location.y, width: size, height: size)).cgPath
        cl.fillColor = CGColor(red: 1, green: 0, blue: 0, alpha: 0.5)
    }
    
    /// Removes circle when eraser is lifted.
    fileprivate func removeCircle() -> Void {
        let cl = getOrInitCircleLayer()
        cl.path = .none
        cl.fillColor = CGColor.init(gray: .zero, alpha: .zero)
    }
    
    /// Insert layer into hierarchy if it is missing.
    /// This is here because I'm terrified of overriding the `PKCanvasView` `init`.
    fileprivate func getOrInitCircleLayer() -> CAShapeLayer {
        if circleLayer == nil {
            self.circleLayer = CAShapeLayer()
            self.layer.insertSublayer(self.circleLayer!, at: 0)
        }
        return self.circleLayer!
    }
}
