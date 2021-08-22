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
        diffChunks(with: text)
    }
}

extension Markdown {
    
    func diffChunks(with new: String) -> Void {
        let original = getChunks(in: plain.makeLines())
        let other = getChunks(in: new.makeLines())
        
        print("Chunks: \(original)")
        
        let diff = original.difference(from: other)
        print(diff)
        diff.print()
    }
    
    func getChunks(in lines: [SKLine]) -> [ArraySlice<SKLine>] {
        let boundaries = findBoundaries(in: lines)
        return (1..<boundaries.count).map { idx in
           lines[boundaries[idx-1]..<boundaries[idx]]
        }
    }
    
    func findBoundaries(in lines: [SKLine]) -> [Array<SKLine>.Index] {
        var boundaries: [Array<SKLine>.Index] = []
        
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

extension CollectionDifference where ChangeElement == ArraySlice<SKLine> {
    func print() -> Void {
        Swift.print("Hi!")
    }
}
