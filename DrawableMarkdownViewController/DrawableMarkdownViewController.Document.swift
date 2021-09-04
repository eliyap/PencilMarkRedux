//
//  DrawableMarkdownViewController.Document.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 14/8/21.
//

import Foundation
import CoreGraphics

// MARK: - Document Methods
extension DrawableMarkdownViewController {
    
    /// Make sure we are not editing the temporary document or a `nil` document.
    func assertDocumentIsValid() {
        precondition(model.document?.fileURL != nil, "Edits made to nil document!")
    }
    
    /// Close whatever document is currently open, and open the provided URL instead
    func present(fileURL: URL?, onClose: @escaping () -> ()) {
        /// If URL is already open, do nothing
        guard model.document?.fileURL != fileURL else { return }
        
        /// Stop interaction with the document
        keyboard.resignFirstResponder()
        canvas.resignFirstResponder()
        keyboard.textView.endEditing(true)
        
        /// Close document, if any, then open new.
        if model.document != nil {
            /// `closeCurrentDocument` clears `onClose`, so only re-equip it on completion.
            closeCurrentDocument(then: { [weak self] in
                self?.open(fileURL: fileURL)
                self?.onClose = onClose
            })
        } else {
            self.open(fileURL: fileURL)
            self.onClose = onClose
        }
    }
    
    /// Open new document, if any
    fileprivate func open(fileURL: URL?) {
        if let fileURL = fileURL {
            print("File URL is \(fileURL)")
            model.document = StyledMarkdownDocument(fileURL: fileURL)
            model.document?.open { (success) in
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
            model.document = nil
            
            /// Show placeholder view.
            view.bringSubviewToFront(noDocument.view)
        }
        
        /// Update Navigation Bar Title
        navigationItem.title = model.document?.localizedName ?? ""
    }
    
    @objc
    func close() {
        guard model.document != nil else { return }
        
        /// Show placeholder view.
        self.view.bringSubviewToFront(self.noDocument.view)
        
        /// Disable editing
        keyboard.close()
        
        /// Update Navigation Bar Title
        navigationItem.title = ""
        
        closeCurrentDocument(then: { /* nothing */})
    }
    
    /// Close the current document. Only if successful, perform action.
    fileprivate func closeCurrentDocument(then action: @escaping () -> ()) -> Void {
        model.document?.close { (success) in
            guard success else {
                assert(false, "Failed to save document!")
                return
            }
            
            print("closed")
            self.model.document = nil
            self.onClose() /// invoke passed closure
            self.onClose = {} /// reset to do nothing
            
            action()
        }
        
        /// Disable undo / redo buttons.
        model.cmdC.undoStatus.send(false)
        model.cmdC.redoStatus.send(false)
    }
}
