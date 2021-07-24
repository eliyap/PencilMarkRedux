//
//  _DrawableMarkdownViewController.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import Foundation
import UIKit

final class _DrawableMarkdownViewController: UIViewController {
    
    /// Folder URL for placing new documents.
    private let url: URL
    
    /// Nullable underlying model object
    private var _document: StyledMarkdownDocument?
    
    /// Non-nullable public model object
    public var document: StyledMarkdownDocument {
        get { getDocument() }
        set { setDocument(to: newValue) }
    }
    
    /// Child View Controllers
    let keyboard: TypingViewController
    
    init(url: URL) {
        self.url = url
        self.keyboard = TypingViewController()
        super.init(nibName: nil, bundle: nil)
        
        /// Add subviews into hierarchy.
        addChild(keyboard)
        keyboard.view.frame = view.frame
        view.addSubview(keyboard.view)
        keyboard.didMove(toParent: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not use")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        keyboard.view.frame = view.frame
    }
}

// MARK:- Document Access
extension _DrawableMarkdownViewController {
    
    /// Returns the underlying document, if any,
    /// or creates a new one if there isn't.
    private func getDocument() -> StyledMarkdownDocument {
        if let _document = _document {
            return _document
        } else {
            /// Create new document here.
            let data = "".data(using: .utf8)! /// Initialize with no text
            let newURL = url.appendingPathComponent("Untitled.txt") /// Default title
            try! data.write(to: newURL)
            
            print("New Document Created")
            
            _document = StyledMarkdownDocument(fileURL: newURL)
            return _document!
        }
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
            print("Text was: " + _document.text)
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
