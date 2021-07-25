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
    let drawing: DrawingViewController
    
    /// Combine Conduits
    let strokeC = StrokeConduit()
    let frameC = FrameConduit()
    let cmdC = CommandConduit()
    let typingC = PassthroughSubject<Void, Never>()
    
    init(url: URL) {
        self.url = url
        self.keyboard = TypingViewController()
        self.drawing = DrawingViewController()
        super.init(nibName: nil, bundle: nil)
        
        /// Add subviews into hierarchy.
        adopt(keyboard)
        keyboard.coordinate(with: self) /// call after `init` and `adopt` are complete
        adopt(drawing)
        drawing.coordinate(with: self) /// call after `init` and `adopt` are complete
        
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

import SwiftUI

final class NoDocumentHost: UIHostingController<NoDocumentView> {
    init() {
        super.init(rootView: NoDocumentView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use")
    }
}

/// Placeholder view showing that we could not access iCloud.
struct NoDocumentView: View {
    var body: some View {
        VStack {
            SwiftUI.Image(systemName: "doc.text.magnifyingglass")
                .font(.largeTitle)
            SwiftUI.Text("No Document Open")
        }
            .foregroundColor(.secondary)
    }
}
