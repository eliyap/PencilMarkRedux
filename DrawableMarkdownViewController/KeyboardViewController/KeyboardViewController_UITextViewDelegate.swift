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
}
