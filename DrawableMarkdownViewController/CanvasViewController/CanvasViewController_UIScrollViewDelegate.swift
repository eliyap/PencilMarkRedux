//
//  CanvasViewController_UIScrollViewDelegate.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import UIKit

extension CanvasViewController: UIScrollViewDelegate {
    /**
     Before scrolling begins, check if the text view has a different position.
     If it does, defer to its position. This might happen because:
     - the user used the keyboard to navigate around the `textView`.
     - there's small glitch in the keyboard adjustment code.
     
     - Note: in my observation, this is only called when the user scrolls with a finger! It does not fire on programmatic scroll.
     */
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        /// Calculate difference in scroll positions
        guard let keyboardY = _kvc?.textView.contentOffset.y else {
            assert(false, "Unable to reference sibling!")
            return
        }
        let diff = scrollView.contentOffset.y - keyboardY
        
        /// If there is any non-trivial difference, defer to text position to prevent a visual jump
        if abs(diff) > 1 {
            print("Discrepancy in scroll position, resolving now...")
            scrollView.contentOffset.y = keyboardY
        }
    }
    
    /// Set common scroll position if this is leading.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard model.scrollLead == .canvas else { return }
        model.frameC.scrollY = scrollView.contentOffset.y
    }
}
