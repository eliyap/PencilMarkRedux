//
//  CanvasViewController.ObserveScroll.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 25/7/21.
//

import Combine

extension CanvasViewController {
    /// Update canvas size to match `UITextView`.
    func observeScroll() {
        let scroll: AnyCancellable = coordinator.frameC.$scrollY
            .sink { [weak self] in
                /// Reject events from own delegate
                guard self?.coordinator.scrollLead != .canvas else { return }
                
                self?.canvasView.contentOffset.y = $0
            }
        store(scroll)
    }
}

