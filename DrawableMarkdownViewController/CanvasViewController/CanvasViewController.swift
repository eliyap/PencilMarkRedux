//
//  CanvasViewController.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import UIKit
import PencilKit

final class CanvasViewController: PMViewController {
    
    let model: DrawableMarkdownViewController.Model
    
    let canvasView = PMCanvasView()

    /// Custom `UndoManager`.
    private let _undoManager = CanvasViewControllerUndoManager()
    override var undoManager: UndoManager? { _undoManager }
    
    /// Unavoidable reference to sibling view controller. Avoid use as much as possible.
    internal private(set) weak var _kvc: KeyboardViewController?
    
    init(model: DrawableMarkdownViewController.Model, _kvc: KeyboardViewController) {
        self.model = model
        self._kvc = _kvc
        super.init(nibName: nil, bundle: nil)
        _undoManager.controller = self /// immediately attach to child
        
        self.view = canvasView
        
        /**
         Permits finger to be used for drawing.
         Enable **only** for Simulator screenshots on iPad!
         - Note: this causes an index crash due to the way I draw bezier splines, and MUST NOT be shipped!
         */
//        canvasView.drawingPolicy = .anyInput
        
        /// Assign PencilKit delegate
        canvasView.delegate = self
        
        /// Allows text to show through
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        
        /// Attach gesture recognizer so we can respond to taps.
        canvasView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
        
        /// Allow scrolling even when content is too small
        canvasView.alwaysBounceVertical = true
        
        /// Setup notifications
        setupNotifications()
    }
    
    /// Perform with with ``coordinator`` after initialization is complete.
    func coordinate(with _: DrawableMarkdownViewController) {
        /// Coordinate via `Combine` with ``coordinator``.
        observeSize()
        observeScroll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Content Size: \(canvasView.contentSize)")
    }
    
    /// Update appearance of tool.
    public func set(tool: Tool) -> Void {
        canvasView.tool = tool.inkingTool
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use")
    }
}

// MARK:- Commands
extension CanvasViewController {
    
    override var keyCommands: [UIKeyCommand]? {
        (super.keyCommands ?? []) + [
            UIKeyCommand(input: "z", modifierFlags: [.command], action: #selector(undo)),
            UIKeyCommand(input: "z", modifierFlags: [.shift, .command], action: #selector(redo)),
        ]
    }
    
    @objc
    func undo() -> Void {
        model.cmdC.undo.send()
    }
    
    @objc
    func redo() -> Void {
        model.cmdC.redo.send()
    }
}

// MARK:- Tap Handling
extension CanvasViewController {
    
    /// Action to perform on tap gesture.
    @objc /// expose to `#selector`
    func didTapView(_ sender: UITapGestureRecognizer) -> Void {
        model.frameC.tapLocation = sender.location(in: canvasView)
    }
}

extension CanvasViewController {
    /// Call when a new document is opened and the view needs to present it
    func present(topInset: CGFloat) {
        canvasView.contentOffset.y = -topInset /// scroll back to top, clearing the nav bar
    }
}
