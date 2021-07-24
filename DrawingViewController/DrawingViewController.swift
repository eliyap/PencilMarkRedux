//
//  DrawingViewController.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import UIKit

final class DrawingViewController: PMViewController {
    
    /// Force unwrap container VC
    /// - Note: since coordinator is not set at ``init``, do not access it until after ``init`` is complete.
    var coordinator: DrawableMarkdownViewController { parent as! DrawableMarkdownViewController }
    
    let canvasView = PMCanvasView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.view = canvasView
        
        /// Assign PencilKit delegate
        canvasView.delegate = self
        
        /// Allows text to show through
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        
        /// Attach gesture recognizer so we can respond to taps.
        canvasView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
    }
    
    /// Perform with with ``coordinator`` after initialization is complete
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Coordinate via `Combine` with ``coordinator``.
        observeSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use")
    }
}

// MARK:- Commands
extension DrawingViewController {
    @objc
    func undo() -> Void {
        coordinator.cmdC.undo.send()
    }
}

// MARK:- Tap Handling
extension DrawingViewController {
    
    /// Action to perform on tap gesture.
    @objc /// expose to `#selector`
    func didTapView(_ sender: UITapGestureRecognizer) -> Void {
        coordinator.frameC.tapLocation = sender.location(in: canvasView)
    }
}
