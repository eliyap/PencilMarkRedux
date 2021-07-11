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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view = canvasView
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use")
    }
}
