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
            
        setButtons(for: traitCollection.horizontalSizeClass)
        
        /// Disable undo buttons initially.
        undoButton.isEnabled = false
        redoButton.isEnabled = false
        
        /// Observe for undo updates.
        store(model.cmdC.undoStatus.sink { [weak self] in
            self?.undoButton.isEnabled = $0
        })
        store(model.cmdC.redoStatus.sink { [weak self] in
            self?.redoButton.isEnabled = $0
        })
    }
    
    @objc
    func undo() {
        model.cmdC.undo.send()
    }
    
    @objc
    func redo() {
        model.cmdC.redo.send()
    }
    
    @objc
    func showTutorial() -> Void {
        /// Anchor popover on tutorial button.
        /// - Note: Mandatory! App will crash if not anchored properly.
        /// - Note: Set every time, otherwise bubble will be anchored in the wrong place!
        tutorial.popoverPresentationController?.barButtonItem = tutorialBtn
        tutorial.popoverPresentationController?.sourceView = self.view
        
        present(tutorial, animated: true)
    }
    
    /// Make custom image views without padding
    /// Source: https://gist.github.com/sonnguyen0310/6720cbf39ce877c20fea1a987543fb99
    func makeButton(image: UIImage, action: Selector) -> UIBarButtonItem {
        
        let imageSize: CGFloat = 20
        let buttonSize: CGFloat = 25
        
        let view = UIButton.systemButton(with: image, target: self, action: action)
        view.frame = CGRect(x: 0.0, y: 0.0, width: imageSize, height: imageSize)
        
        let button = UIBarButtonItem(customView: view)
        let currWidth = button.customView?.widthAnchor.constraint(equalToConstant: buttonSize)
        currWidth?.isActive = true
        let currHeight = button.customView?.heightAnchor.constraint(equalToConstant: buttonSize)
        currHeight?.isActive = true
        
        return button
    }
    
    /// Chooses which toolbar buttons to show based on the horizontal space available.
    func setButtons(for horizontalSizeClass: UIUserInterfaceSizeClass) -> Void {
        var buttons: [UIBarButtonItem] = []
        
        switch horizontalSizeClass {
        case .regular:
            buttons = [
                undoButton,
                redoButton,
                tutorialBtn,
                closeBtn,
            ]
        
        case .compact, .unspecified:
            buttons = [
                undoButton,
                /// redoButton, omitted, similar to GoodNotes, since it's less important
                tutorialBtn,
                /// closeBtn, omitted, since the back button pops the document, effectively closing it.
            ]
        
        @unknown default:
            assert(false, "Unrecognized size class!")
            break
        }
        
        /// Reverse buttons, since they are arranged from the right edge inwards.
        navigationItem.rightBarButtonItems = buttons.reversed()
    }
}
