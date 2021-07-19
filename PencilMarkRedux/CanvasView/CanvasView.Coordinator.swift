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
        Coordinator(strokeC: strokeC, frameC: frameC, cmdC: cmdC)
    }
    
    final class Coordinator: NSObject, PKCanvasViewDelegate {
        
        let strokeC: StrokeConduit
        let frameC: FrameConduit
        let cmdC: CommandConduit
        
        init(strokeC: StrokeConduit, frameC: FrameConduit, cmdC: CommandConduit) {
            self.strokeC = strokeC
            self.frameC = frameC
            self.cmdC = cmdC
        }
        
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
            
            strokeC.stroke = lastStroke
            
            /// erase canvas immediately
            canvasView.drawing = PKDrawing(strokes: [])
        }
    }
}

// MARK:- Scroll Event Handler
extension CanvasView.Coordinator: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Pass scroll offset into Combine conduit
        frameC.scrollY = scrollView.contentOffset.y
    }
}
