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

final class CanvasViewController: UIViewController {
    
    let canvasView = PMCanvasView()
    let frameC: FrameConduit
    var observers = Set<AnyCancellable>()
    
    init(coordinator: CanvasView.Coordinator, frameC: FrameConduit) {
        self.frameC = frameC
        super.init(nibName: nil, bundle: nil)
        self.view = canvasView
        
        /// Assign PencilKit delegate
        canvasView.delegate = coordinator
        
        /// Allows text to show through
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        
        /// Update canvas size to match `UITextView`.
        frameC.$contentSize
            .compactMap { $0 }
            .sink { [weak self] in
                self?.canvasView.contentSize = $0
                print("Updated to \($0)")
            }
            .store(in: &observers)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use")
    }
    
    deinit {
        /// clean up Combine stuff.
        observers.forEach { $0.cancel() }
        print("CanvasViewController was deinitialized")
    }
}

final class PMCanvasView: PKCanvasView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        switch touch.type {
        case .direct:
            print("Finger touch")
        default:
            break
        }
    }
}
