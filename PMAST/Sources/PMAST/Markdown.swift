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
    
    public mutating func updateTree(with text: String) -> Void {
        
    }
}

extension Markdown {
    func getChunks() {
        
    }
    
    func getBoundaries() -> [Array<String.Line>.Index] {
        let lines = plain.makeLines()
        var boundaries: [Array<String.Line>.Index] = []
        
        (lines.startIndex..<lines.endIndex).forEach { idx in
            let line = lines[idx]
            
            /// Skip blank lines,
            guard line.string.isBlank == false else { return }
            
            /// Check if preceding line (if any) is blank,
            /// and that the line could not be continuing a block (besides a fenced code block).
            if idx == 0 || (lines[idx - 1].string.isBlank && (line.string.isPotentiallyContinuation == false)) {
                boundaries.append(idx + 1) /// adjust for 1 indexing
            }
        }
        
        print("Found \(boundaries)")
        print("Actual \(ast.children.map(\.position.start.line))")
        
        
        /// Cap the document at both ends.
        return [0] + boundaries + [lines.endIndex]
    }
}
