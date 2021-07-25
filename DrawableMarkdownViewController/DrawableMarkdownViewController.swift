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
    
    /// Nullable underlying model object
    private var _document: StyledMarkdownDocument?
    
    /// Non-nullable public model object
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
            _document = StyledMarkdownDocument(fileURL: fileURL)
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

// MARK:- Document Access
extension DrawableMarkdownViewController {
    
    /// Returns the underlying document, if any,
    /// or creates a new one if there isn't.
    private func getDocument() -> StyledMarkdownDocument {
        _document ?? StyledMarkdownDocument.temp
    }
    
    /// Updates the document being displayed,
    /// first closing the old document, if any.
    private func setDocument(to document: StyledMarkdownDocument) -> Void {
        
        func open(new document: StyledMarkdownDocument) {
            self._document = document
            document.open { (success) in
                self.keyboard.updateAttributedText()
            }
        }
        
        /// Close existing document, if any, then open the new one.
        if let _document = _document {
            print("Text was: " + _document.markdown.plain)
            _document.close { (success) in
                if success == false {
                    print("Failed to close document!")
                } else {
                    open(new: document)
                }
            }
        } else {
            open(new: document)
        }
    }
}

extension DrawableMarkdownViewController {
    
    /// Make sure we are not editing the temporary document.
    func assertDocumentIsValid() {
        precondition(document?.fileURL != nil, "Edits made to nil document!")
        precondition(document?.fileURL != StyledMarkdownDocument.temp.fileURL, "Edits made to placeholder document!")
    }
    
    /// Close whatever document is currently open, and open the provided URL instead
    func present(fileURL: URL?) {
        /// If URL is already open, do nothing
        guard _document?.fileURL != fileURL else { return }
        
        /// close document, if any, then open new
        if let _document = _document {
            _document.close { (success) in
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
            _document = StyledMarkdownDocument(fileURL: fileURL)
            
            /// Hide placeholder view.
            view.sendSubviewToBack(noDocument.view)
        } else {
            _document = nil
            
            /// Show placeholder view.
            view.bringSubviewToFront(noDocument.view)
        }
    }
}
