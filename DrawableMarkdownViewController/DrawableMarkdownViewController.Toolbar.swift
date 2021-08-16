//
//  DrawableMarkdownViewController.Toolbar.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/8/21.
//

import UIKit
import SwiftUI

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
            
            /// Define a constant width padding view. Magic number.
            let padding = UIView()
            padding.widthAnchor.constraint(equalToConstant: 6).isActive = true
            
            let stackView = UIStackView(arrangedSubviews: [
                UIView(), /// spacer view, fills space because it is first: https://developer.apple.com/documentation/uikit/uistackview/distribution/fill
                makeButton(image: UIImage(named: "pencil.square"), action: #selector(setPencil)),
                makeButton(image: UIImage(named: "eraser.square"), action: #selector(setEraser)),
                padding,
            ])
            stackView.axis = .horizontal
            stackView.alignment = .center
            view = stackView
            
            view.backgroundColor = .tertiarySystemBackground
        }
        
        func makeButton(image: UIImage?, action: Selector) -> UIButton {
            let button = Button(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
            button.addTarget(self, action: action, for: .touchUpInside)
            button.setImage(image, for: .normal)
            button.tintColor = tint
            
            /// Trigger `didSet` automatically. Temp measure
            button.isEnabled = true
            
            /// Round corners on background color.
            button.layer.cornerRadius = 6
            
            let constraints = [
                button.widthAnchor.constraint(equalToConstant: 35),
                button.heightAnchor.constraint(equalToConstant: 35),
            ]
            NSLayoutConstraint.activate(constraints)
            
            return button
        }
        
        @objc
        func setPencil() {
            print("set pencil!")
        }
        
        @objc
        func setEraser() {
            print("set eraser!")
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
        
        #warning("does not relay undo / redo commands when it becomes first responder!")
        
        required init?(coder: NSCoder) {
            fatalError("Do Not Use")
        }
    }
    
    final class Button: UIButton {
        
        var toolSelected: Bool = false {
            didSet {
                backgroundColor = toolSelected
                    ? .secondarySystemFill
                    : .clear
                print("set")
            }
        }
        
        /// Source: https://stackoverflow.com/a/17602296/12395667
        override var isHighlighted: Bool {
            didSet {
                if isHighlighted {
                    backgroundColor = .secondarySystemGroupedBackground
                } else {
                    backgroundColor = toolSelected
                        ? .secondarySystemFill
                        : .clear
                }
            }
        }
    }
}
