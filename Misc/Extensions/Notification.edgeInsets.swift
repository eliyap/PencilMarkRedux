//
//  Notification.edgeInsets.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 25/7/21.
//

import UIKit

extension UIView {
    /**
     Given a keyboard will show/hide notification, get the edge insets to avoid the keyboard frame.
     */
    func edgeInset(for keyboardNotification: Notification) -> UIEdgeInsets? {
        /// Docs: https://developer.apple.com/documentation/uikit/uiresponder/1621578-keyboardframeenduserinfokey
        guard
            let keyboardFrame = keyboardNotification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return nil }

        let keyboardScreenEndFrame = keyboardFrame.cgRectValue
        let keyboardViewEndFrame = self.convert(keyboardScreenEndFrame, from: self.window)

        if keyboardNotification.name == UIResponder.keyboardWillHideNotification {
            return .zero
        } else {
            return UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardViewEndFrame.height - self.safeAreaInsets.bottom,
                right: 0
            )
        }
    }
}
