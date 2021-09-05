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
    
    /// Set of boundaries between chunks of plain text.
    internal var boundaries: [Boundary] = []
    
    public init(_ text: String) {
        plain = text
        
        /// Perform initial tree construction.
        reparseTree()
        
        /// Hack: construct boundaries by patching an empty tree.
        var empty = Markdown()
        empty.patch(with: plain)
        boundaries = empty.boundaries
    }
    
    /// An empty document.
    fileprivate init() {
        plain = ""
        reparseTree()
    }
    
    /// Create a deep copy of the model object.
    public func deepCopy() -> Self {
        var shell = Self()
        
        /// Copy Reference Types.
        shell.plain = plain
        shell.boundaries = boundaries
        
        /// Deep copy reference types, without incurring JavaScript cost.
        shell.ast = Root(ast, parent: nil)
        
        return shell
    }
}

// MARK:- Styling Methods
extension Markdown {
    
    public enum UpdateMode {
        /// Rebuild the AST from scratch, which is expensive.
        case reparse
        
        /// Lazily adjust the existing tree, which may be more error prone.
        case patch
    }
    
    /// - Note: Choose `patch` by default, in future I may wish to revise this decision!
    public mutating func update(with new: String, mode: UpdateMode = .patch) -> Void {
        switch mode {
        case .reparse:
            reparseTree()
        case .patch:
            patch(with: new)
        }
        plain = new
    }
    
    /// Call this function to update after the text is updated.
    private mutating func reparseTree() -> Void {
        /// Parse Markdown into JavaScript MDAST.
        let dict = Parser.shared.parse(plain)
        
        /// Convert JS AST to Swift AST.
        ast = constructTree(from: dict, text: plain)
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
        
        /// Clear all attributes so that typed text is plain by default.
        string.setAttributes(`default`, range: NSMakeRange(0, string.length))
        
        /// Apply styling via AST.
        ast.style(string)
    }
}
