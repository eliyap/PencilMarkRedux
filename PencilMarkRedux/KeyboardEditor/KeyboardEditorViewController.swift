//
//  KeyboardEditorViewController.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import UIKit
import Combine
import PencilKit

final class KeyboardEditorViewController: UIViewController {
    let textView = UITextView()
    let strokeC: StrokeConduit
    let coordinator: KeyboardEditorView.Coordinator
    
    /// CoreAnimation layer used to render rejected strokes.
    private var strokeLayer: CAShapeLayer? = nil
    
    var observers = Set<AnyCancellable>()
    
    init(coordinator: KeyboardEditorView.Coordinator, strokeC: StrokeConduit) {
        self.strokeC = strokeC
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.view = textView
        
        textView.attributedText = coordinator.document.styledText
        textView.delegate = coordinator
        
        strokeC.$stroke
            .compactMap { $0 }
            .sink { [weak self] stroke in
                self?.test(stroke: stroke)
            }.store(in: &observers)
    }
    
    func test(stroke: PKStroke) -> Void {
        switch stroke.interpret() {
        case .horizontalLine:
            strikethrough(with: stroke)
        case .wavyLine:
            print("Not Implemented!")
            break
        case .none:
            reject(stroke: stroke)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        /// Cancel Combine subscriptions to avoid memory leaks
        observers.forEach{ $0.cancel() }
        
        print("KeyboardEditorViewController de-initialized")
    }
}

// MARK:- Stroke Handling
extension KeyboardEditorViewController {
    /**
     Executes a strikethrough using the provided stroke,
     which is assumed to have been recognized as a horizontal line.
     */
    func strikethrough(with stroke: PKStroke) -> Void {
        let (leading, trailing) = stroke.straightened()
        guard
            let uiStart = textView.closestPosition(to: leading),
            let uiEnd = textView.closestPosition(to: trailing),
            let range = textView.textRange(from: uiStart, to: uiEnd)
        else {
            print("Could not get path bounds!")
            return
        }
        
        let nsRange = textView.nsRange(from: range)
        coordinator.document.apply(lineStyle: Delete.self, to: nsRange)
        textView.attributedText = coordinator.document.styledText
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
extension KeyboardEditorViewController {
    /// Insert layer into hierarchy if it is missing.
    /// This is here because I'm terrified of overriding the `PKCanvasView` `init`.
    fileprivate func getOrInitStrokeLayer() -> CAShapeLayer {
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
