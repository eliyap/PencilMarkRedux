//
//  DrawableMarkdownViewController.Toolbar.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/8/21.
//

import UIKit

extension DrawableMarkdownViewController {

    /// Height of our custom toolbar.
    var additionalToolbarHeight: CGFloat { 50 }
    
    func setToolbarInsets() -> Void {
        /// Help child views clear the toolbar.
        canvas.canvasView.verticalScrollIndicatorInsets.top = additionalToolbarHeight
        keyboard.textView.textContainerInset.top = additionalToolbarHeight
    }
    
    final class ToolbarViewController: UIViewController {
        
        typealias Coordinator = DrawableMarkdownViewController
        weak var coordinator: Coordinator!
        
        init() {
            super.init(nibName: nil, bundle: nil)
            view.backgroundColor = .green
        }
        
        func coordinate(with coordinator: Coordinator) {
            view.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                view.leftAnchor.constraint(equalTo: coordinator.view.leftAnchor),
                view.rightAnchor.constraint(equalTo: coordinator.view.rightAnchor),
                view.topAnchor.constraint(equalTo: coordinator.view.safeAreaLayoutGuide.topAnchor),
                view.heightAnchor.constraint(equalToConstant: coordinator.additionalToolbarHeight)
            ]
            NSLayoutConstraint.activate(constraints)
        }
        
        required init?(coder: NSCoder) {
            fatalError("Do Not Use")
        }
    }
}
