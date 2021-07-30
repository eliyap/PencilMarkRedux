//
//  CanvasViewController.UndoManager.swift
//  CanvasViewController.UndoManager
//
//  Created by Secret Asian Man Dev on 30/7/21.
//

import Foundation

/// Custom UndoManager allows us to intercept and execute `undo` and `redo`,
/// particularly when performed using the 3 finger swipe gesture.
extension CanvasViewController {
    final class UndoManager: Foundation.UndoManager {
        
        /// Offer ability to reference parent
        /// - Note: not set at ``init``, do not access it until after ``init`` is complete.
        weak var  controller: CanvasViewController! = nil

        /// Reference `textView` for undo / redo status.
        /// Default to ``true`` in case something goes wrong so that it doesn't break.
        override var canUndo: Bool { controller?.coordinator.keyboard.textView.undoManager?.canUndo ?? true }
        override var canRedo: Bool { controller?.coordinator.keyboard.textView.undoManager?.canRedo ?? true }
        
        override func undo() {
            super.undo()
            controller.undo()
        }
        
        override func redo() {
            super.redo()
            controller.redo()
        }
    }
}
