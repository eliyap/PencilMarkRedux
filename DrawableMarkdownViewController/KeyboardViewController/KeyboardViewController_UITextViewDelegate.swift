//
//  KeyboardViewController_UITextViewDelegate.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import UIKit

extension KeyboardViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        assertDocumentIsValid()
        
        model.typingC.send(textView.text)
        model.document?.updateChangeCount(.done)
        
        /// Update undo buttons.
        updateCommandStatus()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        assertDocumentIsValid()
        
        model.typingC.send(textView.text)
        model.document?.updateChangeCount(.done)
    }
}

extension KeyboardViewController {
    /// Update undo buttons.
    func updateCommandStatus() {
        model.cmdC.undoStatus.send(textView.undoManager?.canUndo ?? true)
        model.cmdC.redoStatus.send(textView.undoManager?.canRedo ?? true)
    }
}
