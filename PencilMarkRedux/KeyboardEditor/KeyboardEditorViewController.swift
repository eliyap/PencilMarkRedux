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
    
    init(
        coordinator: KeyboardEditorView.Coordinator,
        strokeC: StrokeConduit,
        frameC: FrameConduit
    ) {
        self.strokeC = strokeC
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.view = textView
        
        textView.attributedText = coordinator.document.styledText
        textView.delegate = coordinator
        
        /// Receive and respond to strokes from `PKCanvasView`.
        strokeC.$stroke
            .compactMap { $0 }
            .sink { [weak self] stroke in
                /// Stop keyboard editing **first**, so that the cursor is not sent to the bottom of the screen.
                self?.textView.resignFirstResponder()
                
                self?.test(stroke: stroke)
            }
            .store(in: &observers)
        
        /// Coordinate scroll position with `PKCanvasView`.
        frameC.$scrollY
            .sink { [weak self] in
                self?.textView.contentOffset.y = $0
            }
            .store(in: &observers)
        
        /// Set cursor when user taps on `PKCanvasView`.
        frameC.$tapLocation
            .compactMap { $0 }
            .sink { [weak self] in
                guard
                    let textView = self?.textView,
                    let textPosition = textView.closestPosition(to: $0)
                else {
                    print("Could not resolve text position for location \($0)")
                    self?.textView.selectedRange = NSMakeRange(0, 0)
                    return
                }
                
                /// Switch Focus to `UITextView` so that it can enable the cursor.
                textView.becomeFirstResponder()
                
                /// Set cursor position using zero length `UITextRange`.
                textView.selectedTextRange = textView.textRange(from: textPosition, to: textPosition)
            }
            .store(in: &observers)
        
        /**
         Periodically update Markdown styling by rebuilding Abstract Syntax Tree.
         However, because the user can type quickly and the MDAST is built through JavaScript, it's easy to max out the CPU this way.
         Therefore we rate limit the pace of re-rendering.
         - Note: since `textViewDidChange` is **not** called due to programatic changes,
                 updating the text here does not cause an infinite loop.
         */
        coordinator.document.ticker
            /// Rate limiter. `latest` doesn't matter since the subject is `Void`.
            /// Throttle rate is arbitrary, may want to change it in future.
            .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] in
                /// Assert `self` is actually available.
                guard let ref = self else {
                    assert(false, "Weak Self Reference returned nil!")
                    return
                }
                
                /// Rebuild AST, recalculate text styling.
                coordinator.document.updateAttributes()
                
                /**
                 Setting the `attributedText` tends to move the cursor to the end of the document,
                 so store the cursor position before modifying the document, then put it right back.
                 */
                let selection = ref.textView.selectedRange
                ref.textView.attributedText = coordinator.document.styledText
                ref.textView.selectedRange = selection
            }
            .store(in: &observers)
    }
    
    func test(stroke: PKStroke) -> Void {
        switch stroke.interpret() {
        case .horizontalLine:
            strikethrough(with: stroke)
        case .wavyLine:
            erase(along: stroke)
        case .none:
            reject(stroke: stroke)
        }
    }
    
    override func viewWillLayoutSubviews() {
        let frameWidth = view.frame.size.width
        let contentSize = textView.sizeThatFits(CGSize(width: frameWidth, height: .infinity))
        coordinator.frameC.contentSize = contentSize
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
        
        let nsRange = textView.nsRange(from: range)
        coordinator.document.apply(lineStyle: Delete.self, to: nsRange)
        textView.attributedText = coordinator.document.styledText
    }
    
    /// Erase along the provided line
    func erase(along stroke: PKStroke) -> Void {
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
        
        let nsRange = textView.nsRange(from: range)
        coordinator.document.erase(in: nsRange)
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
    /// This is here because I'm terrified of overriding the `UITextView` `init`.
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
