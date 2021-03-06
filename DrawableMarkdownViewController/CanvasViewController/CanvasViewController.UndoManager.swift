//
//  CanvasViewController.UndoManager.swift
//  CanvasViewController.UndoManager
//
//  Created by Secret Asian Man Dev on 30/7/21.
//

import Foundation

final class CanvasViewControllerUndoManager: Foundation.UndoManager {
    
    /// Offer ability to reference parent
    /// - Note: not set at ``init``, do not access it until after ``init`` is complete.
    weak var  controller: CanvasViewController! = nil

    /// Reference `textView` for undo / redo status.
    /// Default to ``true`` in case something goes wrong so that it doesn't break.
    override var canUndo: Bool { controller?._kvc?.textView.undoManager?.canUndo ?? true }
    override var canRedo: Bool { controller?._kvc?.textView.undoManager?.canRedo ?? true }
    
    override func undo() {
        super.undo()
        controller.undo()
    }
    
    override func redo() {
        super.redo()
        controller.redo()
    }
}
