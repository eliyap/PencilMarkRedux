//
//  CanvasViewController.ObserveSize.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import Combine

extension CanvasViewController {
    /// Update canvas size to match `UITextView`.
    func observeSize() {
        let size: AnyCancellable = coordinator.frameC.$contentSize
            .compactMap { $0 }
            .sink { [weak self] in
                self?.canvasView.contentSize = $0
            }
        store(size)
    }
}
