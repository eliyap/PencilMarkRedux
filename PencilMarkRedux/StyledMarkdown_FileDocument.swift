//
//  StyledMarkdown_FileDocument.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation
import SwiftUI

extension StyledMarkdown: FileDocument {
    /// Loads data that has been saved previously.
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
            styledText = styledMarkdown(from: text)
            ast = Parser.shared.parse(markdown: text)
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    /// Called when the system wants to write data to disk.
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
