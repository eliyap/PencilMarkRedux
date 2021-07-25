//
//  CanvasViewController_UIScrollViewDelegate.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import UIKit

extension CanvasViewController: UIScrollViewDelegate {
    /// Set common scroll position if this is leading.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard coordinator.scrollLead == .canvas else { return }
        coordinator.frameC.scrollY = scrollView.contentOffset.y
    }
}
