//
//  KeyboardViewController.ObserveCommands.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import Combine

extension KeyboardViewController {
    /// Listen for commands and execute them.
    func observeCommands() -> Void {
        let undo: AnyCancellable = model.cmdC.undo
            .sink { [weak self] in
                guard self?.model.document != nil else {
                    assert(false, "Attempted to undo on nil document!")
                    return
                }
                print("Command, Can undo: " + String(describing: self?.textView.undoManager?.canUndo))
                self?.textView.undoManager?.undo()
                
                /// Update undo buttons.
                self?.updateCommandStatus()
            }
        store(undo)
        
        let redo: AnyCancellable = model.cmdC.redo
            .sink { [weak self] in
                guard self?.model.document != nil else {
                    assert(false, "Attempted to redo on nil document!")
                    return
                }
                print("Command, Can redo: " + String(describing: self?.textView.undoManager?.canRedo))
                self?.textView.undoManager?.redo()
                
                /// Update undo buttons.
                self?.updateCommandStatus()
            }
        store(redo)
    }
}
