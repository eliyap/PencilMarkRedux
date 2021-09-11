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
    
    /**
     Note: `undo()` doesn't always work, so `textViewDidChange` may not be updated.
     This is an additional place to intercept key commands.
     Additionally, it seems that `undo` is updated _before_ we check, helping us obtain an up-to-date status!
     */
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        /// Must `super`, otherwise this eats the keystrokes!
        super.pressesBegan(presses, with: event)
        
        if (presses.contains(where: \.isCmdZ)) {
            updateCommandStatus()
        } else if (presses.contains(where: \.isShiftCmdZ)) {
            updateCommandStatus()
        }
    }
}

/// Check for specific key combinations.
fileprivate extension UIPress {
    var isCmdZ: Bool {
        guard let key = key else { return false }
        return key.modifierFlags == [.command] && key.characters == "z"
    }
    
    var isShiftCmdZ: Bool {
        guard let key = key else { return false }
        return key.modifierFlags == [.shift, .command] && key.characters == "z"
    }
}

extension KeyboardViewController {
    /// Update undo buttons.
    func updateCommandStatus() {
        model.cmdC.undoStatus.send(textView.undoManager?.canUndo ?? true)
        model.cmdC.redoStatus.send(textView.undoManager?.canRedo ?? true)
    }
}
