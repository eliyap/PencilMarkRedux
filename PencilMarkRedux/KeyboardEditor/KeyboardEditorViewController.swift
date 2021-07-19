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
    var strokeLayer: CAShapeLayer? = nil
    
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
        
        observeStrokes()
        
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

