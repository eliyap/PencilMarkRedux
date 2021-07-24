//
//  DrawableMarkdownViewController.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 23/7/21.
//

import Foundation
import UIKit
import Combine

final class DrawableMarkdownViewController: UIViewController {

    /// Folder URL for temporary documents.
    private let url: URL
    
    /// Conduit Objects.
    let strokeC = StrokeConduit()
    let frameC = FrameConduit()
    let cmdC = CommandConduit()
    
    /// Child View Controllers
    var keyboard: _KeyboardEditorViewController! = nil
    var canvas: _CanvasViewController! = nil
    
    /// Nullable underlying model object
    private var _document: StyledMarkdownDocument?
    
    /// Non-nullable public model object
    public var document: StyledMarkdownDocument {
        get { getDocument() }
        set { setDocument(to: newValue) }
    }
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        
        /// Immediately fix implicitly unwrapped `nil`s.
        self.canvas = _CanvasViewController(coordinator: self, frameC: frameC, strokeC: strokeC)
        self.keyboard = _KeyboardEditorViewController(coordinator: self, strokeC: strokeC, frameC: frameC, cmdC: cmdC)
        
        /// Add subviews into hierarchy.
        adopt(keyboard)
        adopt(canvas)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("canvas: \(canvas != nil)")
        print("keyboard: \(keyboard != nil)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not use")
    }
}

// MARK:- Document Access
extension DrawableMarkdownViewController {
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
                guard success else {
                    assert(false, "Failed to open document!")
                    return
                }
                self.keyboard.textView.attributedText = self.document.styledText
                print("Opened text \(document.text)")
            }
        }
        
        /// Close existing document, if any, then open the new one.
        if let _document = _document {
            print("Text was: " + _document.text)
            _document.close { (success) in
                print("called")
                guard success else {
                    assert(false, "Failed to close document!")
                }
                open(new: document)
            }
        } else {
            open(new: document)
        }
    }
}
