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
        
        let config = UIImage.SymbolConfiguration(pointSize: 10)
        
        closeBtn = UIBarButtonItem(
            image: UIImage(
                systemName: "xmark",
                withConfiguration: config
            ),
            style: .plain,
            target: self,
            action: #selector(close))
        
        tutorialBtn = UIBarButtonItem(
            image: UIImage(
                systemName: "pencil.and.outline",
                withConfiguration: config
            ),
            style: .plain,
            target: self,
            action: #selector(showTutorial)
        )
        
        undoButton = UIBarButtonItem(
            image: UIImage(
                systemName: "arrow.uturn.backward",
                withConfiguration: config
            ),
            style: .plain,
            target: self,
            action: #selector(undo)
        )
        
        redoButton = UIBarButtonItem(
            image: UIImage(
                systemName: "arrow.uturn.forward",
                withConfiguration: config
            ),
            style: .plain,
            target: self,
            action: #selector(redo)
        )
        
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
        store(cmdC.undoStatus.sink { [weak self] in
            self?.undoButton.isEnabled = $0
        })
        store(cmdC.redoStatus.sink { [weak self] in
            self?.redoButton.isEnabled = $0
        })
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
