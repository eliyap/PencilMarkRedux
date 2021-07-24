//
//  DocumentViewController.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 20/7/21.
//

import Foundation
import UIKit
import Combine

final class DocumentViewController: UIViewController {
    
    /// File URL of the open document.
    private let url: URL
    
    /// View presenting document for editing.
    private let textView = UITextView()
    
    /// Nullable underlying model object
    private var _document: TextDocument?
    
    /// Use document's undo manager instead of our own.
    override var undoManager: UndoManager? { document.undoManager }
    
    private var changeObserver = PassthroughSubject<Void, Never>()
    private var observers = Set<AnyCancellable>()
    
    /// Non-nullable public model object
    public var document: TextDocument {
        get { getDocument() }
        set { setDocument(to: newValue) }
    }
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        
        view = textView
        
        /// Observe `textView` events.
        textView.delegate = self
        
        document.open { (success) in
            self.textView.text = self.document.text
        }
        
        /// Save very frequently when the user makes changes.
        let period = 0.5
        changeObserver
            .throttle(for: .seconds(period), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] in
                if let document = self?.document {
                    document.save(to: document.fileURL, for: .forOverwriting) { (success) in
                        if success == false {
                            print("Failed to save!")
                        }
                    }
                }
            }
            .store(in: &observers)
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
                self.textView.text = self.document.text
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
    
    required init?(coder: NSCoder) {
        fatalError("Do Not use")
    }
    
    deinit {
        /// Cancel subscriptions so that they do not leak.
        observers.forEach { $0.cancel() }
    }
}

extension DocumentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        document.text = textView.text
        document.updateChangeCount(.done)
        changeObserver.send()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        document.text = textView.text
        document.updateChangeCount(.done)
        changeObserver.send()
    }
}
