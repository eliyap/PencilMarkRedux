//
//  NewDocumentURL.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 25/7/21.
//

import Foundation

/// Creates a file in the provided document with a name that does not exist.
func newDocumentURL(in folderURL: URL) -> URL {
    /// Existing files / folders
    var existing: [URL] = []
    if let contents = try? FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil) {
        existing = contents
    } else {
        assert(false, "Could not resolve contents in folder!")
    }
    
    /// Get file / folder names
    let existingNames = existing.map { $0.lastPathComponent }
    
    /// Construct a name
    let base = "Untitled"
    var count = 0
    let suffix = ".txt"
    
    func name() -> String {
        count == 0
            ? "\(base)\(suffix)"
            : "\(base)-\(count)\(suffix)"
    }
    
    /// Increment count until name is unique.
    while existingNames.contains(name()) { count += 1 }
    
    return folderURL.appendingPathComponent(name())
}
