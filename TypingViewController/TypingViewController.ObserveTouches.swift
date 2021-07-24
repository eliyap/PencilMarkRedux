//
//  TypingViewController.ObserveTouches.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import Foundation
import Combine

extension TypingViewController {
    /// Attach `Combine` sinks to events from `frameC`.
    func observeTouchEvents() -> Void {
        /// Coordinate scroll position with `PKCanvasView`.
        let scroll: AnyCancellable = coordinator.frameC.$scrollY
            .sink { [weak self] in
                self?.textView.contentOffset.y = $0
            }
        store(scroll)
        
        /// Set cursor when user taps on `PKCanvasView`.
        let tap: AnyCancellable = coordinator.frameC.$tapLocation
            .compactMap { $0 }
            .sink { [weak self] in
                guard
                    let textView = self?.textView,
                    let textPosition = textView.closestPosition(to: $0)
                else {
                    print("Could not resolve text position for location \($0)")
                    self?.textView.selectedRange = NSMakeRange(0, 0)
                    return
                }
                
                /// Switch Focus to `UITextView` so that it can enable the cursor.
                textView.becomeFirstResponder()
                
                /// Set cursor position using zero length `UITextRange`.
                textView.selectedTextRange = textView.textRange(from: textPosition, to: textPosition)
            }
        store(tap)
    }
}
