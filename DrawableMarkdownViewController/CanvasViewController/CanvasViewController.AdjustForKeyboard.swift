//
//  CanvasViewController.AdjustForKeyboard.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 25/7/21.
//

import UIKit

extension CanvasViewController {
    
    /// Register for notifications
    func setupNotifications() {
        let NCD = NotificationCenter.default
        NCD.addObserver(self, selector: #selector(keyboardWillAdjust), name: UIResponder.keyboardWillShowNotification, object: nil)
        NCD.addObserver(self, selector: #selector(keyboardWillAdjust), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillAdjust(_ notification: Notification) {
        
        /// Docs: https://developer.apple.com/documentation/uikit/uiresponder/1621578-keyboardframeenduserinfokey
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardFrame.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            canvasView.scrollIndicatorInsets = .zero
        } else {
            canvasView.scrollIndicatorInsets = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom,
                right: 0
            )
        }
    }
}
