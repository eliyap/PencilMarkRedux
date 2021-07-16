//
//  CanvasViewController.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import UIKit
import PencilKit

final class CanvasViewController: UIViewController {
    let canvasView = PMCanvasView()
    
    init(coordinator: CanvasView.Coordinator) {
        super.init(nibName: nil, bundle: nil)
        self.view = canvasView
        
        /// Assign PencilKit delegate
        canvasView.delegate = coordinator
        
        /// Allows text to show through
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use")
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
