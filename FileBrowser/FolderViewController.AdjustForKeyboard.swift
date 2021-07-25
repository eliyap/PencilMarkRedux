//
//  FolderViewController.AdjustForKeyboard.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 25/7/21.
//

import UIKit

extension FolderViewController {
    /// Register for notifications
    func setupNotifications() {
        let NCD = NotificationCenter.default
        NCD.addObserver(self, selector: #selector(keyboardWillAdjust), name: UIResponder.keyboardWillShowNotification, object: nil)
        NCD.addObserver(self, selector: #selector(keyboardWillAdjust), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillAdjust(_ notification: Notification) {
        /// Adjust scroll indicator size to account for keyboard.
        guard let inset = view.edgeInset(for: notification) else { return }
        additionalSafeAreaInsets = inset
    }
}
