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

    override var restorationIdentifier: String? {
        get { "DrawableMarkdownViewController" }
        set { assert(false, "Restoration ID set to \(newValue ?? "")") }
    }
    
    /// Model object
    public var document: StyledMarkdownDocument?
    
    /// Child View Controllers
    let keyboard: KeyboardViewController
    let canvas: CanvasViewController
    let noDocument: NoDocumentHost
    
    /// Combine Conduits
    let strokeC = StrokeConduit()
    let frameC = FrameConduit()
    let cmdC = CommandConduit()
    let typingC = PassthroughSubject<Void, Never>()
    
    /// Controls which view gets to set the scroll position
    enum ScrollLead { case keyboard, canvas }
    var scrollLead = ScrollLead.canvas
    
    /// Action to perform when document is closed
    var onClose: () -> () = {} /// does nothing by default
    
    init(fileURL: URL?) {
        if let fileURL = fileURL {
            document = StyledMarkdownDocument(fileURL: fileURL)
        }
        self.keyboard = KeyboardViewController()
        self.canvas = CanvasViewController()
        self.noDocument = NoDocumentHost()
        super.init(nibName: nil, bundle: nil)
        
        /// Add subviews into hierarchy.
        adopt(keyboard)
        keyboard.coordinate(with: self) /// call after `init` and `adopt` are complete
        adopt(canvas)
        canvas.coordinate(with: self) /// call after `init` and `adopt` are complete
        adopt(noDocument)
        
        canvas.view.translatesAutoresizingMaskIntoConstraints = false
        keyboard.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.bringSubviewToFront(canvas.view)
        
        let closeBtn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        navigationItem.rightBarButtonItems = [closeBtn]
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
        canvas.view.frame = view.frame
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
        
        /// Stop interaction with the document
        keyboard.resignFirstResponder()
        canvas.resignFirstResponder()
        keyboard.textView.endEditing(true)
        
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
                
                /// Determine `UIScrollView` preferred inset, which is different from the nav bar height
                /// Docs: https://developer.apple.com/documentation/uikit/uiscrollview/2902259-adjustedcontentinset
                let topInset: CGFloat = self.keyboard.textView.adjustedContentInset.top
                
                self.keyboard.present(topInset: topInset)
                self.canvas.present(topInset: topInset)
            }
        } else {
            document = nil
            
            /// Show placeholder view.
            view.bringSubviewToFront(noDocument.view)
        }
        
        /// Update Navigation Bar Title
        navigationItem.title = document?.localizedName ?? ""
    }
    
    @objc
    func close() {
        guard document != nil else { return }
        
        /// Show placeholder view.
        self.view.bringSubviewToFront(self.noDocument.view)
        
        /// Disable editing
        keyboard.close()
        
        /// Update Navigation Bar Title
        navigationItem.title = ""
        
        document?.close { (success) in
            guard success else {
                assert(false, "Failed to save document!")
                return
            }
            
            print("closed")
            self.document = nil
            self.onClose() /// invoke passed closure
            self.onClose = {} /// reset to do nothing
        }
    }
}
