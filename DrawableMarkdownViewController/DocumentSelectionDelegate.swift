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
    func select(_ fileURL: URL, onClose: @escaping () -> ()) -> Void
    func delete(_ fileURL: URL) -> Void
}

extension DrawableMarkdownViewController: DocumentSelectionDelegate {
    /// Opens the passed file URL.
    /// - Parameters:
    ///   - fileURL: `UIDocument` URL to open
    ///   - onClose: closure to invoke when document is ``close``d
    func select(_ fileURL: URL, onClose: @escaping () -> ()) {
        present(fileURL: fileURL)
        self.onClose = onClose
    }
    
    /// Passed file URL was deleted
    func delete(_ fileURL: URL) {
        /// If document was open when deleted, close it first.
        guard fileURL == document?.fileURL else { return }
        close()
    }
}
