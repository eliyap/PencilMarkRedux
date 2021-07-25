//
//  CanvasViewController_PKCanvasViewDelegate.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import PencilKit

extension CanvasViewController: PKCanvasViewDelegate {
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        /// Prevent focus getting "trapped" in `UITextView` (an observed problem) by grabbing focus when pencil touches down.
        canvasView.becomeFirstResponder()
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        /// Check that there is some stroke on the canvas.
        /// This breaks an infinite loop caused by clearing the canvas below.
        guard let lastStroke = canvasView.drawing.strokes.last else {
            return
        }
        
        coordinator.strokeC.stroke = lastStroke
        
        /// erase canvas immediately
        canvasView.drawing = PKDrawing(strokes: [])
    }
}
