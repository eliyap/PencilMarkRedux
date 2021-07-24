//
//  _CanvasViewController_UIScrollViewDelegate.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 23/7/21.
//

import Foundation
import UIKit

// MARK:- Scroll Event Handler
extension _CanvasViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Pass scroll offset into Combine conduit
        frameC.scrollY = scrollView.contentOffset.y
    }
}
