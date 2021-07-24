//
//  TypingViewController.ObserveCommands.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import Combine

extension TypingViewController {
    /// Listen for commands and execute them.
    func observeCommands() -> Void {
        let commands: AnyCancellable = coordinator.cmdC.undo
            .sink { [weak self] in
                print("Can undo: " + String(describing: self?.textView.undoManager?.canUndo))
                self?.textView.undoManager?.undo()
            }
        store(commands)
    }
}
