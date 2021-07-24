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
    let textView = _PMTextView()
    
    /// Use document's undo manager instead of our own.
    override var undoManager: UndoManager? { coordinator.document.undoManager }
    
    /// Force unwrap container VC
    var coordinator: _DrawableMarkdownViewController { parent as! _DrawableMarkdownViewController }
    
    /// CoreAnimation layer used to render rejected strokes.
    var strokeLayer: CAShapeLayer? = nil
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        view = textView
        
        /// Observe `textView` events.
        textView.delegate = self
        
    }
    
    /// Perform with with `parent` after initialization is complete
    override func viewDidLoad() {
        super.viewDidLoad()
        observeTyping()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not use")
    }
}

extension TypingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        coordinator.document.text = textView.text
        coordinator.document.updateChangeCount(.done)
        coordinator.document.ticker.send()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        coordinator.document.text = textView.text
        coordinator.document.updateChangeCount(.done)
        coordinator.document.ticker.send()
    }
}

extension TypingViewController {
    /// Access `coordinator` model to refresh `textView`.
    public func updateAttributedText() {
        textView.attributedText = coordinator.document.styledText
    }
}