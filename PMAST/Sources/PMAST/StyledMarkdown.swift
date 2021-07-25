//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import UIKit

/// A model object representing a simple markdown document.
public struct Markdown {
    
    /// The plain text of the Markdown.
    public var plain: String
    
    /// A pretty styled version of the Markdown.
    public var styledText: NSMutableAttributedString
    internal var ast: Root! = nil
    
    public init(_ text: String) {
        self.plain = text
        self.ast = Parser.shared.parse(markdown: text)
        styledText = Self.attributedText(from: text, with: ast)
    }
}

// MARK:- Styling Methods
extension Markdown {
    /// Call this function to update after the text is updated.
    public mutating func updateAttributes() -> Void {
        /// re-formulate AST
        ast = Parser.shared.parse(markdown: plain)
        
        /// re-format string based on AST
        styledText = Self.attributedText(from: plain, with: ast)
    }
    
    /// Uses the AST to style an attributed string
    /// - Note: make sure the passed AST matches the passed text!
    internal static func attributedText(from markdown: String, with ast: Root) -> NSMutableAttributedString {
        var result = NSMutableAttributedString(
            string: markdown, attributes: [
                /// set font to monospace by default
                .font: UIFont.monospacedSystemFont(ofSize: UIFont.systemFontSize, weight: .regular)
            ]
        )
        ast.style(&result)
        return result
    }
}
