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
    let canvasView = PKCanvasView()
    
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
