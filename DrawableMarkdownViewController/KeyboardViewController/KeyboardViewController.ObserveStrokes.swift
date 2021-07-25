//
//  KeyboardEditorViewController_StrokeHandling.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 18/7/21.
//

import PencilKit
import PMAST

// MARK:- Stroke Handling
extension KeyboardViewController {
    
    /// Run at `init` to start `Combine` sink.
    func observeStrokes() -> Void {
        /// Receive and respond to strokes from `PKCanvasView`.
        let strokes = coordinator.strokeC.$stroke
            .compactMap { $0 }
            .sink { [weak self] stroke in
                /// Stop keyboard editing **first**, so that the cursor is not sent to the bottom of the screen.
                self?.textView.resignFirstResponder()
                
                self?.handle(stroke)
            }
        store(strokes)
    }
    
    func handle(_ stroke: PKStroke) -> Void {
        switch stroke.interpret() {
        case .horizontalLine:
            strikethrough(with: stroke)
        case .wavyLine:
            erase(along: stroke)
        case .none:
            reject(stroke: stroke)
        }
    }
    
    /**
     Executes a strikethrough using the provided stroke,
     which is assumed to have been recognized as a horizontal line.
     */
    func strikethrough(with stroke: PKStroke) -> Void {
        coordinator.assertDocumentIsValid()
        
        /// Get a straightened version of the stroke.
        let (leading, trailing) = stroke.straightened()
        
        guard
            let uiStart = textView.closestPosition(to: leading),
            let uiEnd = textView.closestPosition(to: trailing),
            let range = textView.textRange(from: uiStart, to: uiEnd)
        else {
            print("Could not get path bounds!")
            return
        }
        
        registerUndo() /// register before model changes
        
        /// Update model, then report update, then update view.
        let nsRange = textView.nsRange(from: range)
        coordinator.document?.markdown.apply(lineStyle: Delete.self, to: nsRange)
        coordinator.document?.updateChangeCount(.done)
        textView.attributedText = coordinator.document?.markdown.attributed
    }
    
    /// Erase along the provided line
    func erase(along stroke: PKStroke) -> Void {
        coordinator.assertDocumentIsValid()
        
        /// Use the same straightened version of a stroke as ``strikethrough``.
        let (leading, trailing) = stroke.straightened()
        
        guard
            let uiStart = textView.closestPosition(to: leading),
            let uiEnd = textView.closestPosition(to: trailing),
            let range = textView.textRange(from: uiStart, to: uiEnd)
        else {
            print("Could not get path bounds!")
            return
        }
        
        registerUndo() /// register before model changes
        
        /// Update model, then report update, then update view.
        let nsRange = textView.nsRange(from: range)
        coordinator.document?.markdown.erase(to: nsRange)
        coordinator.document?.updateChangeCount(.done)
        textView.attributedText = coordinator.document?.markdown.attributed
    }
    
    /// Animates a rejected stroke as red and fading out, to indicate that to the user that it was not recognized.
    func reject(stroke: PKStroke) -> Void {
        let strokeLayer = getOrInitStrokeLayer()
        
        strokeLayer.path = stroke.path.asPath.cgPath
        
        /// Set up fade animation to complete translucency.
        let fade = CABasicAnimation(keyPath: "opacity")
        (fade.fromValue, fade.toValue, fade.duration) = (1, 0, 1)
        strokeLayer.add(fade, forKey: "opacity")
        
        /**
         Set the final value so that it sticks after the animation ends.
         Docs: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/CreatingBasicAnimations/CreatingBasicAnimations.html
         */
        strokeLayer.opacity = 0
    }
}

// MARK:- Stroke Reject Layer Guts
extension KeyboardViewController {
    /// Insert layer into hierarchy if it is missing.
    /// This is here because I'm terrified of overriding the `UITextView` `init`.
    func getOrInitStrokeLayer() -> CAShapeLayer {
        if strokeLayer == nil {
            self.strokeLayer = CAShapeLayer()
            
            /// set a translucent red stroke
            self.strokeLayer!.lineWidth = 2.0
            self.strokeLayer!.strokeColor = CGColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            self.strokeLayer!.fillColor = CGColor.init(gray: .zero, alpha: .zero)
            
            self.view.layer.insertSublayer(self.strokeLayer!, at: 0)
        }
        return self.strokeLayer!
    }
}

