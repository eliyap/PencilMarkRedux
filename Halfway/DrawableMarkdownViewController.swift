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
    let keyboard: _KeyboardEditorViewController
    let canvas: _CanvasViewController
    
    /// Nullable underlying model object
    private var _document: StyledMarkdownDocument?
    
    /// Non-nullable public model object
    public var document: StyledMarkdownDocument {
        get { getDocument() }
        set { setDocument(to: newValue) }
    }
    
    init(url: URL) {
        self.url = url
        self.keyboard = _KeyboardEditorViewController(strokeC: strokeC, frameC: frameC, cmdC: cmdC)
        self.canvas = _CanvasViewController(frameC: frameC, strokeC: strokeC)
        super.init(nibName: nil, bundle: nil)
        keyboard.coordinator = self /// *must* set implicitly unwrapped `self` immediately
        canvas.coordinator = self /// *must* set implicitly unwrapped `self` immediately
        
        /// Add subviews into hierarchy.
        addChild(keyboard)
        keyboard.view.frame = view.frame
        view.addSubview(keyboard.view)
        keyboard.didMove(toParent: self)
        
        addChild(canvas)
        canvas.view.frame = view.frame
        view.addSubview(canvas.view)
        canvas.didMove(toParent: self)
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
                #warning("Set Document Here")
//                self.textView.text = self.document.text
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
