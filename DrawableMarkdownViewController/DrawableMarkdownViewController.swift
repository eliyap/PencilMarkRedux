//
//  DrawableMarkdownViewController.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import Foundation
import UIKit
import Combine

final class DrawableMarkdownViewController: PMViewController {
    
    /// Model object
    public var document: StyledMarkdownDocument?
    
    /// Child View Controllers
    let keyboard: KeyboardViewController
    let drawing: CanvasViewController
    let noDocument: NoDocumentHost
    
    /// Combine Conduits
    let strokeC = StrokeConduit()
    let frameC = FrameConduit()
    let cmdC = CommandConduit()
    let typingC = PassthroughSubject<Void, Never>()
    
    init(fileURL: URL?) {
        if let fileURL = fileURL {
            document = StyledMarkdownDocument(fileURL: fileURL)
        }
        self.keyboard = KeyboardViewController()
        self.drawing = CanvasViewController()
        self.noDocument = NoDocumentHost()
        super.init(nibName: nil, bundle: nil)
        
        /// Add subviews into hierarchy.
        adopt(keyboard)
        keyboard.coordinate(with: self) /// call after `init` and `adopt` are complete
        adopt(drawing)
        drawing.coordinate(with: self) /// call after `init` and `adopt` are complete
        adopt(noDocument)
        
        drawing.view.translatesAutoresizingMaskIntoConstraints = false
        keyboard.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.bringSubviewToFront(drawing.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not use")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeTyping()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        keyboard.view.frame = view.frame
        drawing.view.frame = view.frame
        noDocument.view.frame = view.frame
    }
}

extension DrawableMarkdownViewController {
    
    /// Make sure we are not editing the temporary document or a `nil` document.
    func assertDocumentIsValid() {
        precondition(document?.fileURL != nil, "Edits made to nil document!")
        precondition(document?.fileURL != StyledMarkdownDocument.temp.fileURL, "Edits made to placeholder document!")
    }
    
    /// Close whatever document is currently open, and open the provided URL instead
    func present(fileURL: URL?) {
        /// If URL is already open, do nothing
        guard document?.fileURL != fileURL else { return }
        
        /// close document, if any, then open new
        if let document = document {
            document.close { (success) in
                guard success else {
                    assert(false, "Failed to close document!")
                    return
                }
                self.open(fileURL: fileURL)
            }
        } else {
            self.open(fileURL: fileURL)
        }
    }
    
    /// Open new document, if any
    private func open(fileURL: URL?) {
        if let fileURL = fileURL {
            document = StyledMarkdownDocument(fileURL: fileURL)
            document?.open { (success) in
                guard success else {
                    assert(false, "Failed to open document!")
                    return
                }
                
                /// Hide placeholder view.
                self.view.sendSubviewToBack(self.noDocument.view)
                
                self.keyboard.textView.attributedText = self.document?.markdown.attributed
                print(self.document?.markdown.plain)
            }
        } else {
            document = nil
            
            /// Show placeholder view.
            view.bringSubviewToFront(noDocument.view)
        }
        
        /// Update Navigation Bar Title
        navigationItem.title = document?.localizedName ?? ""
    }
}
