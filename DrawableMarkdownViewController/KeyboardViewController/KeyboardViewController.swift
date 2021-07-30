//
//  KeyboardViewController.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 20/7/21.
//

import UIKit
import Combine

final class KeyboardViewController: PMViewController {
    
    /// View presenting document for editing.
    let textView = PMTextView()
    
    /// Use document's undo manager instead of our own.
    override var undoManager: UndoManager! { coordinator.undoManager }
    
    /// Force unwrap container VC
    /// - Note: since coordinator is not set at ``init``, do not access it until after ``init`` is complete.
    var coordinator: DrawableMarkdownViewController { parent as! DrawableMarkdownViewController }
    
    /// CoreAnimation layer used to render rejected strokes.
    var strokeLayer: CAShapeLayer? = nil
    
    /// The last known contents of the `textView`
    var lastText: NSAttributedString
    
    init() {
        lastText = textView.attributedText
        super.init(nibName: nil, bundle: nil)
        
        view = textView
        
        /// Observe `textView` events.
        textView.delegate = self
        textView.controller = self
        
        /// Disable Scribble interactions.
        textView.addInteraction(UIScribbleInteraction(delegate: ScribbleBlocker()))
        textView.addInteraction(UIIndirectScribbleInteraction(delegate: IndirectScribbleBlocker()))
        
        setupNotifications()
    }
    
    /// Perform with with ``coordinator`` after initialization is complete.
    func coordinate(with _: DrawableMarkdownViewController) {
        /// Coordinate via `Combine` with ``coordinator``.
        observeTyping()
        observeStrokes()
        observeTouchEvents()
        observeCommands()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        /// Update `PKCanvasView` as to the size it should adopt.
        let frameWidth = view.frame.size.width
        let contentSize = textView.sizeThatFits(CGSize(width: frameWidth, height: .infinity))
        
        /**
         Make `PKCanvasView` as wide as the frame,
         and as tall as the taller of the text and the page,
         so that the user can mark anywhere on screen.
         */
        var canvasSize = CGSize(width: CGFloat.zero, height: CGFloat.zero)
        canvasSize.width = max(view.frame.width, contentSize.width)
        canvasSize.height = max(view.frame.height, contentSize.height)
        
        coordinator.frameC.contentSize = canvasSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not use")
    }
}

extension KeyboardViewController {
//    /// General way to store the current state before it is mutated.
//    func registerUndo() {
//        coordinator.assertDocumentIsValid()
//
//        let lastText = self.lastText
//
//
//        coordinator.undoManager.registerUndo(withTarget: textView) { view in
//            /// Before reversing the change, store the current state as a *redo* operation.
//            view.controller.registerUndo()
//
//            /// Freeze current selection to be restored after text is rolled back.
//            let selection: UITextRange? = view.selectedTextRange
//
//            /// Roll back document state.
//            /// Temporarily disable scrolling to stop iOS snapping the view downwards.
//            view.isScrollEnabled = false
//            view.attributedText = lastText
//            view.isScrollEnabled = true
//
//            /// Restore text selection, if text was selected.
//            if view.isFirstResponder, let selection = selection {
//                view.selectedTextRange = selection
//            }
//
//            /// Roll back model state
//            view.controller.coordinator.document!.markdown.plain = lastText.string
//            #warning("might pummel CPU with repeated AST construction")
//            view.controller.coordinator.document?.markdown.updateAttributes()
//        }
//    }
    
    @objc /// expose to #selector
    func setAttributedText(to text: NSAttributedString) -> Void {
        guard textView.attributedText != text else { return }
        
        /// Freeze known text for undo / redo operation
        let lastText = self.lastText
        undoManager.registerUndo(withTarget: self, selector: #selector(setAttributedText), object: lastText)
        
        /// Now update last known value
        self.lastText = text
        
        /// Freeze current selection to be restored after text is rolled back.
        let selection: UITextRange? = textView.selectedTextRange
        
        /// Roll back document state.
        /// Temporarily disable scrolling to stop iOS snapping the view downwards.
        textView.isScrollEnabled = false
        textView.attributedText = lastText
        textView.isScrollEnabled = true
    
        /// Restore text selection, if text was selected.
        if textView.isFirstResponder, let selection = selection {
            textView.selectedTextRange = selection
        }
        
        /// Set model state
        textView.controller.coordinator.document!.markdown.plain = text.string
        textView.controller.coordinator.document?.markdown.attributed = NSMutableAttributedString(attributedString: text)
    }
}

extension KeyboardViewController {
    /// Call when a new document is opened and the view needs to present it
    func present(topInset: CGFloat) {
        textView.attributedText = coordinator.document?.markdown.attributed
        lastText = coordinator.document!.markdown.attributed
        
        textView.contentOffset.y = -topInset /// scroll back to top, clearing the nav bar
    }
}
