//
//  CanvasViewController.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import UIKit
import PencilKit
import Combine

final class _CanvasViewController: UIViewController {
    
    let canvasView = PMCanvasView()
    let frameC: FrameConduit
    let strokeC: StrokeConduit
    weak var coordinator: DrawableMarkdownViewController!
    
    var observers = Set<AnyCancellable>()
    
    init(coordinator: DrawableMarkdownViewController, frameC: FrameConduit, strokeC: StrokeConduit) {
        self.coordinator = coordinator
        self.frameC = frameC
        self.strokeC = strokeC
        super.init(nibName: nil, bundle: nil)
        self.view = canvasView
        
        /// Assign PencilKit delegate
        canvasView.delegate = self
        
        /// Allows text to show through
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        
        /// Update canvas size to match `UITextView`.
        frameC.$contentSize
            .compactMap { $0 }
            .sink { [weak self] in
                self?.canvasView.contentSize = $0
            }
            .store(in: &observers)
        
        /// Attach gesture recognizer so we can respond to taps.
        canvasView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use")
    }
    
    override var keyCommands: [UIKeyCommand]? {
        (super.keyCommands ?? []) + [
            UIKeyCommand(input: "z", modifierFlags: [.command], action: #selector(undo))
        ]
    }

    @objc
    func undo() -> Void {
        coordinator.cmdC.undo.send()
    }
    
    deinit {
        /// clean up Combine stuff.
        observers.forEach { $0.cancel() }
        print("CanvasViewController was deinitialized")
    }
}

// MARK:- Tap Handling
extension _CanvasViewController {
    
    /// Action to perform on tap gesture.
    @objc /// expose to `#selector`
    func didTapView(_ sender: UITapGestureRecognizer) -> Void {
        frameC.tapLocation = sender.location(in: canvasView)
    }
}
