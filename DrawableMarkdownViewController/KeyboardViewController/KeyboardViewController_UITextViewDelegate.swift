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
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        coordinator.assertDocumentIsValid()
        
        coordinator.document?.markdown.plain = textView.text
        coordinator.document?.updateChangeCount(.done)
        coordinator.typingC.send()
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        /// Ignore selection changes made by code, including those sent via touch events.
        guard programmaticTextSelection == false else { return }
        
//        coordinator.canvas.canvasView.contentOffset.y = 0
//        coordinator.scrollLead = .keyboard
//        coordinator.frameC.scrollY = textView.contentOffset.y
//        coordinator.scrollLead = .canvas
        print("Selection Changed")
    }
}
