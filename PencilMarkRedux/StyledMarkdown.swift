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
struct StyledMarkdown {
    /// tell the system we support only plain text
    static var readableContentTypes = [UTType.plainText]
    
    var text: String
    var styledText: NSMutableAttributedString
    var ast: Root
    
    /// a simple initializer that creates new, empty documents
    init(text: String = "") {
        self.text = text
        self.ast = Parser.shared.parse(markdown: text)
        self.styledText = Self.attributedText(from: text, with: ast)
    }
}

extension StyledMarkdown {
    func text(for node: Node) -> Substring {
        text[node.position.nsRange.lowerBound..<node.position.nsRange.upperBound]
    }
}

extension StyledMarkdown {
    /// Call this function to update after the text is updated.
    mutating func updateAttributes() -> Void {
        /// re-formulate AST
        ast = Parser.shared.parse(markdown: text)
        
        /// re-format string based on AST
        self.styledText = Self.attributedText(from: text, with: ast)
    }
    
    /// Uses the AST to style an attributed string
    /// - Note: make sure the passed AST matches the passed text!
    static func attributedText(from markdown: String, with ast: Root) -> NSMutableAttributedString {
        var result = NSMutableAttributedString(string: markdown)
        ast.style(&result)
        return result
    }
}