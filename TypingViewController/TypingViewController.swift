//
//  TypingViewController.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 20/7/21.
//

import Foundation
import UIKit
import Combine

final class TypingViewController: PMViewController {
    
    /// View presenting document for editing.
    let textView = PMTextView()
    
    /// Use document's undo manager instead of our own.
    override var undoManager: UndoManager? { coordinator.document.undoManager }
    
    /// Force unwrap container VC
    var coordinator: DrawableMarkdownViewController { parent as! DrawableMarkdownViewController }
    
    /// CoreAnimation layer used to render rejected strokes.
    var strokeLayer: CAShapeLayer? = nil
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        view = textView
        
        /// Observe `textView` events.
        textView.delegate = self
        
        /// Disable Scribble interactions.
        textView.addInteraction(UIScribbleInteraction(delegate: ScribbleBlocker()))
        textView.addInteraction(UIIndirectScribbleInteraction(delegate: IndirectScribbleBlocker()))
    }
    
    /// Perform with with `parent` after initialization is complete
    override func viewDidLoad() {
        super.viewDidLoad()
        observeTyping()
        observeStrokes()
        observeTouchEvents(from: coordinator.frameC)
        observeCommands()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        /// Update `PKCanvasView` as to the size it should adopt to fit all this text.
        let frameWidth = view.frame.size.width
        let contentSize = textView.sizeThatFits(CGSize(width: frameWidth, height: .infinity))
        coordinator.frameC.contentSize = contentSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not use")
    }
}

extension TypingViewController {
    /// Access `coordinator` model to refresh `textView`.
    public func updateAttributedText() {
        textView.attributedText = coordinator.document.styledText
    }
}
