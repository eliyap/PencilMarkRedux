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

    /// File URL of the open document.
    private let url: URL
    
    let strokeC = StrokeConduit()
    let frameC = FrameConduit()
//    let cmdC = CommandConduit()
//    let document: StyledMarkdown
    
    /// Nullable underlying model object
    private var _document: TextDocument?
    
    /// Non-nullable public model object
    public var document: TextDocument {
        get { getDocument() }
        set { setDocument(to: newValue) }
    }
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not use")
    }
    
    /// Returns the underlying document, if any,
    /// or creates a new one if there isn't.
    private func getDocument() -> TextDocument {
        if let _document = _document {
            return _document
        } else {
            /// Create new document here.
            let data = "".data(using: .utf8)! /// Initialize with no text
            let newURL = url.appendingPathComponent("Untitled.txt") /// Default title
            try! data.write(to: newURL)
            
            print("New Document Created")
            
            _document = TextDocument(fileURL: newURL)
            return _document!
        }
    }
    
    /// Updates the document being displayed,
    /// first closing the old document, if any.
    private func setDocument(to document: TextDocument) -> Void {
        
        func open(new document: TextDocument) {
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
