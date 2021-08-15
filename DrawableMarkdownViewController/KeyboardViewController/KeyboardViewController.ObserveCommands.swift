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
        let undo: AnyCancellable = coordinator.cmdC.undo
            .sink { [weak self] in
                print("Command, Can undo: " + String(describing: self?.textView.undoManager?.canUndo))
                self?.textView.undoManager?.undo()
                
                /// Update undo buttons.
                self?.updateCommandStatus()
            }
        store(undo)
        
        let redo: AnyCancellable = coordinator.cmdC.redo
            .sink { [weak self] in
                print("Command, Can redo: " + String(describing: self?.textView.undoManager?.canRedo))
                self?.textView.undoManager?.redo()
                
                /// Update undo buttons.
                self?.updateCommandStatus()
            }
        store(redo)
    }
}
