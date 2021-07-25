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
            textView.textContainerInset = .zero
        } else {
            textView.textContainerInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom,
                right: 0
            )
        }

        /// Adjust text and scrollbars to clear keyboard, if any
        textView.scrollIndicatorInsets = textView.textContainerInset
                
        #warning("move this to other class!")
        coordinator.canvas.canvasView.scrollIndicatorInsets = textView.textContainerInset
        
        /**
         Note to `self`: do not set `contentInset` here!
         - in my testing, setting `contentInset` causes an automatic scroll, which cannot be disabled, and cannot be monitored.
         - this is very bad because it throws the Keybaord and Canvas views out of alignment in a way that we cannot fix, causing a massive view "jump"!
         */
    }
    
    @objc
    func keyboardDidAdjust(_ notification: Notification) {
        defer {
            /// Relinquish control of scroll position.
            /// Is set when keyboard starts showing.
            coordinator.scrollLead = .canvas
        }
        
        /**
         If the text would be hidden by the keyboard, scroll it into view quickly.
         */
        if notification.name == UIResponder.keyboardDidShowNotification {
            /// Docs: https://developer.apple.com/documentation/uikit/uiresponder/1621578-keyboardframeenduserinfokey
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

            let keyboardScreenEndFrame = keyboardFrame.cgRectValue
            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
            let clearance = keyboardViewEndFrame.height - view.safeAreaInsets.bottom /// from Apple sample code
            
            /// Calculate how far the selected text is above the keyboard's top edge.
            let yFromTop      = textView.selectedRect.maxY - textView.contentOffset.y
            let yFromBottom   = textView.frame.height - yFromTop
            let yFromKeyboard = yFromBottom - clearance
            
            if yFromKeyboard < 0 {
                UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
                    self.textView.contentOffset.y -= yFromKeyboard
                }.startAnimation()
            }
        }
    }
}

extension UITextView {
    /// Shorthard for finding the bounding rectangle around the selected text range.
    var selectedRect: CGRect {
        firstRect(for: textRange(
            from: position(from: beginningOfDocument, offset: selectedRange.lowerBound)!,
            to: position(from: beginningOfDocument, offset: selectedRange.lowerBound)!
        )!)
    }
}
