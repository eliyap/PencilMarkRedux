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
    override var undoManager: UndoManager? { model.document?.undoManager }
    
    var model: DrawableMarkdownViewController.Model
    
    /// CoreAnimation layer used to render rejected strokes.
    var strokeLayer: CAShapeLayer? = nil
    
    /// Tracks whether the eraser is currently being used.
    var eraserDown = false
    
    init(model: DrawableMarkdownViewController.Model) {
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
        
        view = textView
        
        /// Attach model immediately.
        textView.fragmentModel = FragmentModel(textView: textView)
        
        /// Observe `textView` events.
        textView.delegate = self
        
        /// Disable Scribble interactions.
        textView.addInteraction(UIScribbleInteraction(delegate: ScribbleBlocker()))
        textView.addInteraction(UIIndirectScribbleInteraction(delegate: IndirectScribbleBlocker()))
        
        /// Disable editing until document is ``present``ed
        textView.isEditable = false
        
        textView.backgroundColor = .documentBackgroundColor
        
        setupNotifications()
        
        /// Coordinate via `Combine` with ``model``.
        observeTyping()
        observeStrokes()
        observeEraser()
        observeTouchEvents()
        observeCommands()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        /// Update `PKCanvasView` as to the size it should adopt.
        let frameWidth = view.frame.width
        let contentSize = textView.sizeThatFits(CGSize(width: frameWidth, height: .infinity))
        
        /**
         Make `PKCanvasView` as wide as the frame,
         and as tall as the taller of the text and the page,
         so that the user can mark anywhere on screen.
         */
        var canvasSize = CGSize(width: CGFloat.zero, height: CGFloat.zero)
        canvasSize.width = max(view.frame.width, contentSize.width)
        canvasSize.height = max(view.frame.height, contentSize.height)
        
        model.frameC.contentSize = canvasSize
        
        /// 10% is an arbitrary choice, may wish to revisit it in future.
        let horizontalPadding: CGFloat = frameWidth * 0.1
        
        /// Only adjust padding if it doesn't match. No particular reason for this.
        if textView.contentInset.left != horizontalPadding {
            textView.textContainerInset.left = horizontalPadding
            textView.textContainerInset.right = horizontalPadding
        }
        
        /// Set overscroll region
        if textView.textContainerInset.bottom != textView.frame.height / 2 {
            textView.textContainerInset.bottom = textView.frame.height / 2
        }
    }
    
    /// Make sure we are not editing the temporary document or a `nil` document.
    func assertDocumentIsValid() {
        precondition(model.document?.fileURL != nil, "Edits made to nil document!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not use")
    }
}

extension KeyboardViewController {
    /// General way to store the current state before it is mutated.
    /// - `restyle`: Whether to re-style the text after rollback.
    ///             Useful if some temporary styling had been applied to the text.
    func registerUndo(restyle: Bool = false) {
        assertDocumentIsValid()
        
        /// Register Undo Operation before affecting model object
        let currentStyledText = textView.attributedText
        textView.undoManager?.registerUndo(withTarget: textView) { [weak self] view in
            assert(self != nil, "Lost reference to controller!")
            
            /// Before reversing the change, store the current state as a *redo* operation.
            self?.registerUndo()
            
            /// Freeze current selection to be restored after text is rolled back.
            let selection: UITextRange? = view.selectedTextRange
            
            /// Roll back document state.
            /// Temporarily disable scrolling to stop iOS snapping the view downwards.
            view.isScrollEnabled = false
            view.attributedText = currentStyledText
            view.isScrollEnabled = true
        
            /// Restore text selection, if text was selected.
            if view.isFirstResponder, let selection = selection {
                view.selectedTextRange = selection
            }
            
            /// Roll back model state.
            self?.model.document?.markdown.update(with: view.text)
            
            /// Re-calculate styling if desired.
            if restyle {
                self?.styleText()
            }
            
            /// Update undo buttons.
            /// - Note: found that `textViewDidChange` and `textDidChangeNotification`
            ///         do **not** fire on Pencil changes, so we fire this manually!
            self?.updateCommandStatus()
        }
        
        /// Update undo buttons.
        /// - Note: found that `textViewDidChange` and `textDidChangeNotification`
        ///         do **not** fire on Pencil changes, so we fire this manually!
        updateCommandStatus()
    }
}

extension KeyboardViewController {
    /// Call when a new document is opened and the view needs to present it
    func present(topInset: CGFloat) {
        /// Set and style the `textView` contents.
        textView.text = model.document?.markdown.plain
        styleText()
        
        textView.contentOffset.y = -topInset /// scroll back to top, clearing the nav bar
        
        /// Enable editing
        textView.isEditable = true
    }
    
    func close() {
        /// Disallow the user from entering the text field
        textView.isEditable = false
    }
}

extension KeyboardViewController {
    
    fileprivate var paragraphStyle: NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.5
        return style
    }
    
    /// Default styling for plain text.
    var defaultAttributes: [NSAttributedString.Key: Any] {[
        /// Monospaced font to make character targetting easier.
        .font: UIFont.monospacedSystemFont(ofSize: UIFont.dynamicSize, weight: .regular),
        
        /// Dark mode sensitive primary color.
        .foregroundColor: UIColor.label,
        
        .paragraphStyle: paragraphStyle
    ]}
    
    /// Applies model styling to text, using our preferred defaults
    /// - Note: does **not** rebuild the AST!
    func styleText() {
        guard let md = model.document?.markdown else { return }
        md.setAttributes(textView.textStorage, default: defaultAttributes)
    }
}

// MARK:- Commands
extension KeyboardViewController {
    
    override var keyCommands: [UIKeyCommand]? {
        let esc = UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(escape))
        esc.discoverabilityTitle = "Stop Editing"
        return (super.keyCommands ?? []) + [
            esc,
        ]
    }
    
    @objc
    func escape() -> Void {
        /// Stop typing.
        resignFirstResponder()
        textView.endEditing(true)
    }
}
