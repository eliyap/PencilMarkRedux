//
//  FileBrowserPickerDelegate.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 19/9/21.
//

import UIKit

extension FileBrowser {
/**
 - `UIDocumentPickerViewController` holds a `weak` reference to its delegate,
   so the `ViewController` holds a strong reference.
 */
final class PickerDelegate: NSObject, UIDocumentPickerDelegate {
    
    private let onSelect: ([URL]) -> ()
    
    init(onSelect: @escaping ([URL]) -> ()) {
        self.onSelect = onSelect
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        precondition(urls.count == 1, "\(urls.count) documents picked!")
        onSelect(urls)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        /// Nothing.
    }
}
}
