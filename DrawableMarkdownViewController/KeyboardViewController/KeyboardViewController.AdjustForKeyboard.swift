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
        
        NCD.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    @objc
    func keyboardWillAdjust(_ notification: Notification) {
        /// Allow `textView` to control scroll position.
        /// Is reset after keyboard finishes showing.
        coordinator.scrollLead = .keyboard
        
        guard let inset = view.bottomInset(for: notification) else { return }
        
        /// Adjust text and scrollbars to avoid keyboard frame
        textView.textContainerInset.bottom = inset
            /// include the overscroll region
            + textView.frame.height / 2
        textView.verticalScrollIndicatorInsets.bottom = inset
        
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
        
        /// Docs: https://developer.apple.com/documentation/uikit/uiresponder/1621578-keyboardframeenduserinfokey
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        /// Get keyboard height in frame.
        let keyboardScreenEndFrame = keyboardFrame.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let clearance = keyboardViewEndFrame.height - view.safeAreaInsets.bottom /// from Apple sample code
        
        /// Animation delay.
        var insetDelay: TimeInterval = 0
        
        /**
         If the text would be hidden by the keyboard, scroll it into view quickly.
         */
        if notification.name == UIResponder.keyboardDidShowNotification {
            /// Calculate how far the selected text is above the keyboard's top edge.
            let yFromTop      = textView.selectedRect.maxY - textView.contentOffset.y
            let yFromBottom   = textView.frame.height - yFromTop
            let yFromKeyboard = yFromBottom - clearance
            
            if yFromKeyboard < 0 {
                /// Adjust interval for animation
                insetDelay = 0.15
                
                UIViewPropertyAnimator(duration: insetDelay, curve: .easeInOut) {
                    self.textView.contentOffset.y -= yFromKeyboard
                }.startAnimation()
            }
        }
        
        /// Adjust Content Inset after cursor is already in view.
        /// This sidesteps the implicit scroll behaviour.
        /// Implicitly causes `textView` `selectedRange` to scroll into view.
        DispatchQueue.main.asyncAfter(deadline: .now() + insetDelay) {
            if notification.name == UIResponder.keyboardDidShowNotification {
                self.textView.contentInset.bottom = clearance
            } else {
                self.textView.contentInset.bottom = .zero
            }
        }
    }
    
    @objc /// #selector
    func fontSizeChanged(_ notification: Notification) {
        /// update styling (including font size) whenever font size changes
        styleText()
        
        textView.fragmentModel.invalidate()
    }
}

extension UITextView {
    /// Shorthard for finding the bounding rectangle around the selected text range.
    var selectedRect: CGRect {
        let rect = firstRect(for: textRange(
            from: position(from: beginningOfDocument, offset: selectedRange.lowerBound)!,
            to: position(from: beginningOfDocument, offset: selectedRange.lowerBound)!
        )!)
        
        /// Check if rectangle has valid origin.
        /// I observed that moving to the end of the document could result in a rectangle with origin (NaN, NaN)
        guard
            rect.origin.x.isInfinite == false,
            rect.origin.x.isNaN == false,
            rect.origin.y.isInfinite == false,
            rect.origin.y.isNaN == false
        else {
            print("Warning: invalid rectangle found!")
            /// In this case, simply encompass the whole document
            return firstRect(for: textRange(
                from: beginningOfDocument,
                to: endOfDocument
            )!)
        }
        return rect
    }
}
