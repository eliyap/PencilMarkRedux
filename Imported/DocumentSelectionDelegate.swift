//
//  DocumentSelectionDelegate.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 20/7/21.
//

import Foundation

/// Very small protocol that lets `FileBrowserViewController` set the document of the `DocumentViewController`.
protocol DocumentSelectionDelegate: AnyObject {
    func select(_ document: TextDocument) -> Void
}

extension DocumentViewController: DocumentSelectionDelegate {
    func select(_ document: TextDocument) {
        /// Update Naviagation Bar Title
        navigationItem.title = document.localizedName
        
        self.document = document
    }
}
