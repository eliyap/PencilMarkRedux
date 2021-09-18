//
//  DrawableMarkdownViewController.Toolbar.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/8/21.
//

import UIKit
import SwiftUI

extension DrawableMarkdownViewController {

    /// Width of our custom toolbar.
    var additionalToolbarWidth: CGFloat { 50 }
    
    final class ToolbarViewController: UIViewController {
        
        typealias Coordinator = DrawableMarkdownViewController
        
        /// Unwrapped optional allows us to use `#selectors` in init
        private var pencilBtn: Button! = nil
        private var eraserBtn: Button! = nil
        private var highlighterBtn: Button! = nil
        
        private var model: DrawableMarkdownViewController.Model
        
        init(model: DrawableMarkdownViewController.Model) {
            self.model = model
            super.init(nibName: nil, bundle: nil)
            pencilBtn = makeButton(image: UIImage(named: "pencil.square"), action: #selector(setPencil))
            eraserBtn = makeButton(image: UIImage(named: "eraser.square"), action: #selector(setEraser))
            highlighterBtn = makeButton(image: UIImage(named: "highlighter.square"), action: #selector(setHighlighter))
            
            let subviews: [UIView] = [
                Padding(height: 6),
                pencilBtn,
                eraserBtn,
                highlighterBtn,
            ]
            
            let stackView = UIStackView(arrangedSubviews: subviews)
            stackView.axis = .vertical
            stackView.alignment = .center
            view = stackView
            
            /// Make toolbar clear.
            view.backgroundColor = .clear
        }
        
        /// Updates which tools are selected, which in turn should update their background colors.
        func highlight(tool: Tool) {
            switch tool {
            case .pencil:
                pencilBtn.toolSelected = true
                eraserBtn.toolSelected = false
                highlighterBtn.toolSelected = false
            case .eraser:
                pencilBtn.toolSelected = false
                eraserBtn.toolSelected = true
                highlighterBtn.toolSelected = false
            case .highlighter:
                pencilBtn.toolSelected = false
                eraserBtn.toolSelected = false
                highlighterBtn.toolSelected = true
            }
        }
        
        fileprivate func makeButton(image: UIImage?, action: Selector) -> Button {
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
            model.tool = .pencil
        }
        
        @objc
        func setEraser() {
            model.tool = .eraser
        }
        
        @objc
        func setHighlighter() {
            model.tool = .highlighter
        }
        
        func coordinate(with coordinator: Coordinator) {
            view.translatesAutoresizingMaskIntoConstraints = false
            
            /**
             Constrain to sit at the top right, and hold a fixed width.
             */
            let constraints = [
                view.rightAnchor.constraint(equalTo: coordinator.view.rightAnchor),
                view.topAnchor.constraint(equalTo: coordinator.view.safeAreaLayoutGuide.topAnchor),
                view.widthAnchor.constraint(equalToConstant: coordinator.additionalToolbarWidth)
            ]
            NSLayoutConstraint.activate(constraints)
        }
        
        #warning("does not relay undo / redo commands when it becomes first responder!")
        
        required init?(coder: NSCoder) {
            fatalError("Do Not Use")
        }
    }
    
    fileprivate final class Button: UIButton {
        
        var toolSelected: Bool = false {
            didSet {
                backgroundColor = toolSelected
                    ? .secondarySystemFill
                    : .clear
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
    fileprivate final class Padding: UIView {
        init(height: CGFloat) {
            super.init(frame: CGRect(origin: .zero, size: .zero))
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        required init?(coder: NSCoder) {
            fatalError("Do Not Use")
        }
    }
}
