//
//  DrawableMarkdownViewController.restoreState.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 14/8/21.
//

import Foundation

// MARK: - State Restoration
extension DrawableMarkdownViewController {
    /// - Note: expect that this might be called multiple times, in order to restore the state ASAP.
    func restoreState() -> Void {
        restoreDocument()
        
        /// Simply set enum, doesn't matter if this happens repeatedly.
        tool = StateModel.shared.tool
    }
    
    /// - Note: expect that this might be called multiple times, in order to restore the state ASAP.
    fileprivate func restoreDocument() {
        /// Only restore state if document is not already open.
        guard document?.fileURL == nil else { return }
        
        /// Assert control over iCloud drive
        /// If we do not do this, `UIDocument` reports a permissions failure.
        guard let iCloudURL = FileBrowserViewController.iCloudURL else { return }
        _ = try? FileManager.default.contentsOfDirectory(at: iCloudURL, includingPropertiesForKeys: .none)
        
        /// Open stored document
        present(fileURL: StateModel.shared.url)
    }
}
