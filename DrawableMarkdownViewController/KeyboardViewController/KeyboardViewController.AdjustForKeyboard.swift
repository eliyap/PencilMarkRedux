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
        NCD.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NCD.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func adjustForKeyboard(_ notification: Notification) {
        let userInfo = notification.userInfo
        
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
        coordinator.canvas.canvasView.scrollIndicatorInsets = textView.contentInset
        
//        guard let animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
//            fatalError("*** Unable to get the animation duration ***")
//        }
//
//        guard let curveInt = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else {
//            fatalError("*** Unable to get the animation curve ***")
//        }
//
//        guard let animationCurve = UIView.AnimationCurve(rawValue: curveInt) else {
//            fatalError("*** Unable to parse the animation curve ***")
//        }
//
//        /// Animate scroll to selected range.
//        UIViewPropertyAnimator(duration: animationDuration, curve: animationCurve) {
//            self.view.layoutIfNeeded()
//
//            let selectedRange = self.textView.selectedRange
//            self.textView.scrollRangeToVisible(selectedRange)
//
//        }.startAnimation()
    }
}
