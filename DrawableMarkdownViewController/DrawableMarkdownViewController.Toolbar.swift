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
    
    final class ToolbarViewController: UIHostingController<Toolbar> {
        
        typealias Coordinator = DrawableMarkdownViewController
        weak var coordinator: Coordinator!
        
        init() {
            super.init(rootView: Toolbar())
        }
        
        func coordinate(with coordinator: Coordinator) {
            view.translatesAutoresizingMaskIntoConstraints = false
            
            /**
             Constrain to
             - consume full width
             - sit at the top
             - have a fixed height
             */
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

import SwiftUI
struct Toolbar: View {
    var body: some View { Color.green }
}
