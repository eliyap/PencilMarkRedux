//
//  KeyboardViewContoller.adjustForKeyboard.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 25/7/21.
//

import Foundation

// MARK:- Respond to Keyboard Appearance / Disappearance
/// Adapted from Apple's "Document Browser" Sample App.
extension KeyboardViewController {
    private func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        
        keyboardAppearObserver = notificationCenter.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil) { (notification) in
                self.adjustForKeyboard(notification: notification)
        }
        
        keyboardDisappearObserver = notificationCenter.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil) { (notification) in
                self.adjustForKeyboard(notification: notification)
        }
    }
    
    @objc
    func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo

        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardFrame.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom,
                                                 right: 0)
        }

        textView.scrollIndicatorInsets = textView.contentInset

        guard let animationDuration =
            userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
                 as? Double else {
                     fatalError("*** Unable to get the animation duration ***")
         }
         
         guard let curveInt =
            userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else {
                 fatalError("*** Unable to get the animation curve ***")
         }
         
         guard let animationCurve =
             UIView.AnimationCurve(rawValue: curveInt) else {
                 fatalError("*** Unable to parse the animation curve ***")
         }

         UIViewPropertyAnimator(duration: animationDuration, curve: animationCurve) {
             self.view.layoutIfNeeded()
            
            let selectedRange = self.textView.selectedRange
            self.textView.scrollRangeToVisible(selectedRange)
            
         }.startAnimation()
    }
}
