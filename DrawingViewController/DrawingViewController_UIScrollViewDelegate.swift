//
//  DrawingViewController_UIScrollViewDelegate.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import UIKit

extension DrawingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Pass scroll offset into Combine conduit
        coordinator.frameC.scrollY = scrollView.contentOffset.y
    }
}
