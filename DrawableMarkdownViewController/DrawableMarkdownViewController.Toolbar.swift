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
        private weak var coordinator: Coordinator!
        
        /// Unwrapped optional allows us to use `#selectors` in init
        public var pencilBtn: Button! = nil
        public var eraserBtn: Button! = nil
        
        init() {
            super.init(nibName: nil, bundle: nil)
            pencilBtn = makeButton(image: UIImage(named: "pencil.square"), action: #selector(setPencil))
            eraserBtn = makeButton(image: UIImage(named: "eraser.square"), action: #selector(setEraser))
            
            let stackView = UIStackView(arrangedSubviews: [
                UIView(), /// spacer view, fills space because it is first: https://developer.apple.com/documentation/uikit/uistackview/distribution/fill
                pencilBtn,
                Padding(width: 6),
                eraserBtn,
                Padding(width: 6),
            ])
            stackView.axis = .horizontal
            stackView.alignment = .center
            view = stackView
            
            view.backgroundColor = .tertiarySystemBackground
        }
        
        func highlight(tool: Tool) {
            switch tool {
            case .pencil:
                pencilBtn.toolSelected = true
                eraserBtn.toolSelected = false
            case .eraser:
                pencilBtn.toolSelected = false
                eraserBtn.toolSelected = true
            }
        }
        
        func makeButton(image: UIImage?, action: Selector) -> Button {
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
    
    /// Constant width padding view.
    final class Padding: UIView {
        init(width: CGFloat) {
            super.init(frame: CGRect(origin: .zero, size: .zero))
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        required init?(coder: NSCoder) {
            fatalError("Do Not Use")
        }
    }
}
