//
//  DrawableMarkdownViewController.Buttons.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 14/8/21.
//

import UIKit

extension DrawableMarkdownViewController {
    
    /// Add `UINavigationController` toolbar items.
    func makeButtons() {
        /// Set up bar buttons
        closeBtn = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(close))
        tutorialBtn = UIBarButtonItem(image: UIImage(systemName: "pencil.and.outline"), style: .plain, target: self, action: #selector(showTutorial))
        let undoButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.backward"), style: .plain, target: self, action: #selector(undo))
        let redoButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.forward"), style: .plain, target: self, action: #selector(redo))
        
        let buttons: [UIBarButtonItem] = [
            undoButton,
            redoButton,
            tutorialBtn,
            closeBtn,
        ]
        
        /// Reverse buttons, since they are arranged from the right edge inwards.
        navigationItem.rightBarButtonItems = buttons.reversed()
        
        /// Disable undo buttons initially.
        undoButton.isEnabled = false
        redoButton.isEnabled = false
        
        /// Observe for undo updates.
        store(cmdC.undoStatus.sink { undoButton.isEnabled = $0 })
        store(cmdC.redoStatus.sink { redoButton.isEnabled = $0 })
    }
    
    @objc
    func undo() {
        cmdC.undo.send()
    }
    
    @objc
    func redo() {
        cmdC.redo.send()
    }
}
