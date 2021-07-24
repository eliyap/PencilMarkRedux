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

final class _KeyboardEditorViewController: UIViewController {
    let textView = _PMTextView()
    let strokeC: StrokeConduit
    weak var coordinator: DrawableMarkdownViewController!
    
    /// CoreAnimation layer used to render rejected strokes.
    var strokeLayer: CAShapeLayer? = nil
    
    var observers = Set<AnyCancellable>()
    
    init(
        strokeC: StrokeConduit,
        frameC: FrameConduit,
        cmdC: CommandConduit
    ) {
        self.strokeC = strokeC
        super.init(nibName: nil, bundle: nil)
        self.view = textView
        textView.controller = self /// pass self to child
        
        textView.attributedText = coordinator.document.styledText
        
        /// Monitor typing in `UITextView`
        textView.delegate = self
        
        /// Attach various `Combine` observers.
        observeStrokes()
        observeTouchEvents(from: frameC)
        
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
                self?.coordinator.document.updateAttributes()
                
                /**
                 Setting the `attributedText` tends to move the cursor to the end of the document,
                 so store the cursor position before modifying the document, then put it right back.
                 Also temporarily disable scrolling to prevent iOS snapping view to the bottom.
                 */
                let selection = ref.textView.selectedRange
                ref.textView.isScrollEnabled = false
                print("Can undo: " + String(describing: ref.textView.undoManager?.canUndo))
                ref.textView.attributedText = self?.coordinator.document.styledText
                print("Can undo: " + String(describing: ref.textView.undoManager?.canUndo))
                ref.textView.isScrollEnabled = true
                ref.textView.selectedRange = selection
            }
            .store(in: &observers)

        cmdC.undo
            .sink { [weak self] in
                print("Can undo: " + String(describing: self?.textView.undoManager?.canUndo))
                self?.textView.undoManager?.undo()
            }
            .store(in: &observers)
        
        /// Disable Scribble interactions.
        textView.addInteraction(UIScribbleInteraction(delegate: ScribbleBlocker()))
        textView.addInteraction(UIIndirectScribbleInteraction(delegate: IndirectScribbleBlocker()))
    }
    
//    override var keyCommands: [UIKeyCommand]? {
//        (super.keyCommands ?? []) + [
//            UIKeyCommand(input: "f", modifierFlags: [.command], action: #selector(undo))
//        ]
//    }
//
//    @objc
//    func undo() -> Void {
//        print("Undoing")
//        textView.undoManager?.undo()
//    }
    
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

final class _PMTextView: UITextView {
    /// reference to parent `KeyboardEditorViewController`.
    /// **Must** be set on controller's `init`.
    unowned var controller: _KeyboardEditorViewController! = nil
}
