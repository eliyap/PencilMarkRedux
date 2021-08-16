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
        precondition(document?.fileURL != nil, "Edits made to nil document!")
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
            print("File URL is \(fileURL)")
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
        
        /// Disable undo / redo buttons.
        cmdC.undoStatus.send(false)
        cmdC.redoStatus.send(false)
    }
}
