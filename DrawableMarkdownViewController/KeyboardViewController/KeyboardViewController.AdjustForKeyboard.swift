//
//  KeyboardViewContoller.adjustForKeyboard.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 25/7/21.
//

import UIKit

// MARK:- Respond to Keyboard Appearance / Disappearance
/// Adapted from Apple's "Document Browser" Sample App.
extension KeyboardViewController {
    
    /// Register for notifications
    func setupNotifications() {
        let NCD = NotificationCenter.default
        NCD.addObserver(self, selector: #selector(keyboardWillAdjust), name: UIResponder.keyboardWillShowNotification, object: nil)
        NCD.addObserver(self, selector: #selector(keyboardWillAdjust), name: UIResponder.keyboardWillHideNotification, object: nil)
        NCD.addObserver(self, selector: #selector(keyboardDidAdjust), name: UIResponder.keyboardDidShowNotification, object: nil)
        NCD.addObserver(self, selector: #selector(keyboardDidAdjust), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillAdjust(_ notification: Notification) {
        /// Allow `textView` to control scroll position.
        /// Is reset after keyboard finishes showing.
        coordinator.scrollLead = .keyboard
        
        /// Docs: https://developer.apple.com/documentation/uikit/uiresponder/1621578-keyboardframeenduserinfokey
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardFrame.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        /// Implicitly causes `textView` `selectedRange` to scroll into view.
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom,
                right: 0
            )
        }

        /// Adjust text and scrollbars to clear keyboard, if any
        textView.scrollIndicatorInsets = textView.contentInset
        textView.textContainerInset.bottom = textView.contentInset.bottom
        
        #warning("move this to other class!")
        coordinator.canvas.canvasView.scrollIndicatorInsets = textView.contentInset
    }
    
    @objc
    func keyboardDidAdjust(_ notification: Notification) {
        /// Relinquish control of scroll position.
        /// Is set when keyboard starts showing.
        coordinator.scrollLead = .canvas
    }
}
