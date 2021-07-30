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
    
    /// A Swift representation of a Unified.JS MarkDown Abstract Syntax Tree (AST).
    internal var ast: Root! = nil
    
    public init(_ text: String) {
        self.plain = text
        self.ast = Parser.shared.parse(markdown: text)
    }
}

// MARK:- Styling Methods
extension Markdown {
    /// Call this function to update after the text is updated.
    public mutating func updateAttributes() -> Void {
        /// re-formulate AST
        ast = Parser.shared.parse(markdown: plain)
    }
    
    /// Applies styling to the passed text, whose contents **must** be equivalent to the plain markdown!
    public func setAttributes(_ string: NSMutableAttributedString) -> Void {
        precondition(string.string == plain, "Cannot style non matching string!")
        
        /// Clear all attributes so that typed text is plain by default.
        string.setAttributes([:], range: NSMakeRange(0, string.length))
        
        /// Apply styling via AST.
        ast.style(string)
    }
}
