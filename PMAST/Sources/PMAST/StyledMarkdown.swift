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
    
    /// A cached copy of the JavaScript MDAST.
    /// Allows us to restore the Swift MDAST after ``ast`` has been modified,
    /// in the event that we want to revert changes, especially duing chunk diffing. constructTree(from: Parser.shared.parse(text))
    internal private(set) var dict: [AnyHashable: Any]! = nil
    
    public init(_ text: String) {
        self.plain = text
        self.ast = constructTree(from: Parser.shared.parse(text))
    }
}

// MARK:- Styling Methods
extension Markdown {
    /// Call this function to update after the text is updated.
    public mutating func reconstructTree() -> Void {
        /// re-formulate AST
        ast = constructTree(from: Parser.shared.parse(plain))
    }
    
    /// Applies styling to the passed text, whose contents **must** be equivalent to the plain markdown!
    /// - Parameters:
    ///   - string: Attributed String with plain text equal to ``plain``.
    ///   - default: Attributes to apply to normal text by default. Defaults to no attributes.
    /// - Returns: `Void`, but mutates the passed `string` to apply styles.
    public func setAttributes(_ string: NSMutableAttributedString, default: [NSAttributedString.Key:Any] = [:]) -> Void {
        guard string.string == plain else {
            /// John encountered a crash while typing quickly, it seems that the model fell out of sync with the view's text.
            /// For now, we will simply refuse to style non-matching text.
            #warning("Todo, log warning about bad string!")
            assert(false, "Cannot style non matching string!")
            return
        }
        precondition(string.string == plain, "Cannot style non matching string!")
        
        /// Clear all attributes so that typed text is plain by default.
        string.setAttributes(`default`, range: NSMakeRange(0, string.length))
        
        /// Apply styling via AST.
        ast.style(string)
    }
}
