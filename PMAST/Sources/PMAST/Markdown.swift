//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import Foundation

/// A model object representing a simple markdown document.
public struct Markdown {
    
    /// The plain text of the Markdown.
    public var plain: String
    
    /// A Swift representation of a Unified.JS MarkDown Abstract Syntax Tree (AST).
    public internal(set) var ast: Root! = nil
    
    public init(_ text: String) {
        self.plain = text
        self.updateAttributes()
    }
}

// MARK:- Styling Methods
extension Markdown {
    /// Call this function to update after the text is updated.
    public mutating func updateAttributes() -> Void {
        /// re-formulate AST
        ast = Parser.shared.parse(markdown: plain)
    }
}
