//
//  DrawableMarkdownViewController.Toolbar.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/8/21.
//

import UIKit

extension DrawableMarkdownViewController {

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
                view.heightAnchor.constraint(equalToConstant: 50)
            ]
            coordinator.keyboard.textView.textContainerInset.top = 50
            coordinator.canvas.canvasView.verticalScrollIndicatorInsets.top = 50
            NSLayoutConstraint.activate(constraints)
        }
        
        required init?(coder: NSCoder) {
            fatalError("Do Not Use")
        }
    }
}
