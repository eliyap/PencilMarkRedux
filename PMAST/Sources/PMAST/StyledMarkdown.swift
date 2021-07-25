//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import UIKit

public struct StyledMarkdown {
    
    public var text: String
    public var styledText: NSMutableAttributedString
    internal var ast: Root! = nil
    
    public init(_ text: String) {
        self.text = text
        self.ast = Parser.shared.parse(markdown: text)
        styledText = Self.attributedText(from: text, with: ast)
    }
}

// MARK:- Styling Methods
extension StyledMarkdown {
    /// Call this function to update after the text is updated.
    public mutating func updateAttributes() -> Void {
        /// re-formulate AST
        ast = Parser.shared.parse(markdown: text)
        
        /// re-format string based on AST
        styledText = Self.attributedText(from: text, with: ast)
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
