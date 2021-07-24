//
//  TypingViewController_UITextViewDelegate.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import UIKit

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
