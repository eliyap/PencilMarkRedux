//
//  DocumentSelectionDelegate.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 20/7/21.
//

import Foundation
import UIKit

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

/// Very small protocol that lets `FileBrowserViewController` set the document of the `DocumentViewController`.
protocol _DocumentSelectionDelegate: AnyObject {
    associatedtype Document: UIDocument
    func select(_ document: Document) -> Void
}

//extension _DocumentViewController: _DocumentSelectionDelegate {
//    typealias Document = StyledMarkdownDocument
//    func select(_ document: StyledMarkdownDocument) {
//        /// Update Naviagation Bar Title
//        navigationItem.title = document.localizedName
//
//        self.document = document
//    }
//}

extension _DrawableMarkdownViewController: _DocumentSelectionDelegate {
    func select(_ document: StyledMarkdownDocument) {
        /// Update Naviagation Bar Title
        navigationItem.title = document.localizedName

        self.document = document
    }
}
