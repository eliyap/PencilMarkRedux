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
        
        closeBtn = makeButton(image: UIImage(systemName: "xmark")!, action: #selector(close))
        tutorialBtn = makeButton(image: UIImage(systemName: "pencil.and.outline")!, action: #selector(showTutorial))
        undoButton = makeButton(image: UIImage(systemName: "arrow.uturn.backward")!, action: #selector(undo))
        redoButton = makeButton(image: UIImage(systemName: "arrow.uturn.forward")!, action: #selector(redo))
            
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
    
    /// Make custom image views without padding
    /// Source: https://gist.github.com/sonnguyen0310/6720cbf39ce877c20fea1a987543fb99
    func makeButton(image: UIImage, action: Selector) -> UIBarButtonItem {
        
        let size: CGFloat = 25
        
        let view = UIButton.systemButton(with: image, target: self, action: action)
        view.frame = CGRect(x: 0.0, y: 0.0, width: size, height: size)
        
        let button = UIBarButtonItem(customView: view)
        let currWidth = button.customView?.widthAnchor.constraint(equalToConstant: size)
        currWidth?.isActive = true
        let currHeight = button.customView?.heightAnchor.constraint(equalToConstant: size)
        currHeight?.isActive = true
        
        return button
    }
}


