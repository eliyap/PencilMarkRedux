//
//  CanvasView.Coordinator.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import PencilKit

extension CanvasView {
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    final class Coordinator: NSObject, PKCanvasViewDelegate {
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            /// Check that there is some stroke on the canvas.
            /// This breaks an infinite loop caused by clearing the canvas below.
            guard let lastStroke = canvasView.drawing.strokes.last else {
                return
            }
            
            /// erase canvas immediately
            canvasView.drawing = PKDrawing(strokes: [])
        }
    }
}
