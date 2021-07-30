//
//  KeyboardViewController_UITextViewDelegate.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import UIKit

extension KeyboardViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        /// Safety checks
        guard let textView = textView as? PMTextView else { fatalError("Unexpected type!") }
        coordinator.assertDocumentIsValid()
        
        /// Freeze known text for undo / redo operation
        let lastText = self.lastText
        undoManager.registerUndo(withTarget: self, selector: #selector(setAttributedText), object: lastText)
        self.lastText = textView.attributedText /// update value for next call
        
        coordinator.document?.markdown.plain = textView.text
        coordinator.document?.updateChangeCount(.done)
        coordinator.typingC.send()
    }
    
//    func registerUndo() {
//        let attributed = coordinator.document!.markdown.attributed
//        coordinator.undoManager.registerUndo(withTarget: textView) { view in
//            view.controller.registerUndo()
//
//            /**
//             Revert document model using attributed text only,
//             - avoid consuming too much memory by retaining the whole `Markdown` object
//             */
//            view.controller.coordinator.document?.markdown.plain = attributed.string
//            view.controller.coordinator.document?.markdown.attributed = attributed
//            view.attributedText = attributed
//        }
//    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        coordinator.assertDocumentIsValid()
        
        coordinator.document?.markdown.plain = textView.text
        coordinator.document?.updateChangeCount(.done)
        coordinator.typingC.send()
    }
}
