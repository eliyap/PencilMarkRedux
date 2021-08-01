//
//  NewDocumentURL.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 25/7/21.
//

import Foundation

/// Creates a file in the provided document with a name that does not exist.
func newURL(in folderURL: URL, base: String, suffix: String) -> URL {
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
    var count = 0
    
    func name() -> String {
        count == 0
            ? "\(base)\(suffix)"
            : "\(base) \(count)\(suffix)"
    }
    
    /// Increment count until name is unique.
    while existingNames.contains(name()) || FileManager.default.fileExists(atPath: folderURL.appendingPathComponent(name()).path) { count += 1 }
    
    return folderURL.appendingPathComponent(name())
}
