//
//  StyledMarkdown.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

/**
 Based on [HWS Tutorial](https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-document-based-app-using-filedocument-and-documentgroup)
 */
struct StyledMarkdown: FileDocument {
    /// tell the system we support only plain text
    static var readableContentTypes = [UTType.plainText]
    
    var text: String
    var styledText: NSMutableAttributedString
    var ast: Root
    
    /// a simple initializer that creates new, empty documents
    init(text: String = "") {
        self.text = text
        self.styledText = styledMarkdown(from: text)
        self.ast = Parser.shared.parse(markdown: text)
    }

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

extension StyledMarkdown {
    func text(for node: Node) -> Substring {
        text[node.position.nsRange.lowerBound..<node.position.nsRange.upperBound]
    }
}
