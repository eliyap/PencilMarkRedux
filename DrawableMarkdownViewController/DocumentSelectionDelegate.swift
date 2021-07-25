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
    func select(_ fileURL: URL) -> Void
}

extension DrawableMarkdownViewController: DocumentSelectionDelegate {
    func select(_ fileURL: URL) {
        present(fileURL: fileURL)
    }
}
