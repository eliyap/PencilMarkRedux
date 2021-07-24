//
//  _KeyboardEditorViewController_UITextViewDelegate.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 23/7/21.
//

import Foundation
import UIKit

extension _KeyboardEditorViewController: UITextViewDelegate {
    /// Update model when user types.
    func textViewDidChange(_ textView: UITextView) {
        /// Update model text, but do not rebuild AST as that operation is expensive.
        coordinator.document.text = textView.text
        
        /// Report via `Combine` that text did change.
        coordinator.document.ticker.send()
    }
}
