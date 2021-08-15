//
//  KeyboardViewController_UITextViewDelegate.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import UIKit

extension KeyboardViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        coordinator.assertDocumentIsValid()
        
        coordinator.document?.markdown.plain = textView.text
        coordinator.document?.updateChangeCount(.done)
        coordinator.typingC.send()
        
        /// Update undo buttons.
        updateCommandStatus()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        coordinator.assertDocumentIsValid()
        
        coordinator.document?.markdown.plain = textView.text
        coordinator.document?.updateChangeCount(.done)
        coordinator.typingC.send()
    }
}

extension KeyboardViewController {
    /// Update undo buttons.
    func updateCommandStatus() {
        coordinator.cmdC.undoStatus.send(textView.undoManager?.canUndo ?? true)
        coordinator.cmdC.redoStatus.send(textView.undoManager?.canRedo ?? true)
    }
}
