//
//  TypingViewController.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 20/7/21.
//

import Foundation
import UIKit
import Combine

final class TypingViewController: UIViewController {
    
    /// View presenting document for editing.
    private let textView = UITextView()
    
    /// Use document's undo manager instead of our own.
    override var undoManager: UndoManager? { coordinator.document.undoManager }
    
    #warning("replaced with document ticker")
    private var changeObserver = PassthroughSubject<Void, Never>()
    
    /// Combine Observers & Conduits
    private var observers = Set<AnyCancellable>()
    
    /// Force unwrap container VC
    var coordinator: _DrawableMarkdownViewController { parent as! _DrawableMarkdownViewController }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        view = textView
        
        /// Observe `textView` events.
        textView.delegate = self
        
    }
    
    /// Perform with with `parent` after initialization is complete
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Save very frequently when the user makes changes.
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not use")
    }
    
    deinit {
        /// Cancel subscriptions so that they do not leak.
        observers.forEach { $0.cancel() }
    }
}

extension TypingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        coordinator.document.text = textView.text
        coordinator.document.updateChangeCount(.done)
        changeObserver.send()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        coordinator.document.text = textView.text
        coordinator.document.updateChangeCount(.done)
        changeObserver.send()
    }
}

extension TypingViewController {
    /// Access `coordinator` model to refresh `textView`.
    func updateAttributedText() {
        textView.attributedText = coordinator.document.styledText
    }
}
