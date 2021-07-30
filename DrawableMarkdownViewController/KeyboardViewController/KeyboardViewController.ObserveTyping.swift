//
//  KeyboardViewController.ObserveTyping.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import Foundation

extension KeyboardViewController {
    
    /// How long to wait between saving operations.
    static let period = 0.5
    
    /**
     Periodically update Markdown styling by rebuilding Abstract Syntax Tree.
     However, because the user can type quickly and the MDAST is built through JavaScript, it's easy to max out the CPU this way.
     Therefore we rate limit the pace of re-rendering.
     - Note: since `textViewDidChange` is **not** called due to programatic changes,
             updating the text here does not cause an infinite loop.
     */
    func observeTyping() {
        let typing = coordinator.typingC
            /// Rate limiter. `latest` doesn't matter since the subject is `Void`.
            /// Throttle rate is arbitrary, may want to change it in future.
            .throttle(for: .seconds(Self.period), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] in
                /// Assert `self` is actually available.
                guard let ref = self else {
                    assert(false, "Weak Self Reference returned nil!")
                    return
                }
                
                /// Rebuild AST, recalculate text styling.
                self?.coordinator.document?.markdown.updateAttributes()
                
                /**
                 Setting the `attributedText` tends to move the cursor to the end of the document,
                 so store the cursor position before modifying the document, then put it right back.
                 Also temporarily disable scrolling to prevent iOS snapping view to the bottom.
                 */
                
                let before: Bool? = ref.textView.undoManager?.canUndo

                /// - Note: setting `textView.attributedText` wipes the `undoManager`,
                /// which is very bad, but calling `setAttributes` does not!
                self?.coordinator.document!.markdown.setAttributes(ref.textView.textStorage)
                let after: Bool? = ref.textView.undoManager?.canUndo
                if before != after { print("Before \(before), After \(after)")}
                
            }
        self.store(typing)
    }
}
