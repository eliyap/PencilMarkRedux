//
//  KeyboardViewController_UIScrollViewDelegate.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 25/7/21.
//

import UIKit

extension KeyboardViewController: UIScrollViewDelegate {
    /// Set common scroll position if this is leading.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard coordinator.scrollLead == .keyboard else { return }
        coordinator.frameC.scrollY = scrollView.contentOffset.y
    }
}
