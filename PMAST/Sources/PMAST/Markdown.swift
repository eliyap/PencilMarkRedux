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
        diff.report()
    }
    
    
}

extension ArraySlice where Element == SKLine {
    var trimmed: ArraySlice<Element> {
        var result = self
        
        /// Trim leading blank lines
        while result.first?.string.isBlank == true {
            result = result[(result.startIndex + 1)..<result.endIndex]
        }
        
        /// Trim trailing blank lines
        while result.last?.string.isBlank == true {
            result = result[result.startIndex..<(result.endIndex - 1)]
        }
        
        return result
    }
}

/// Custom debug printout.
internal extension CollectionDifference where ChangeElement == ArraySlice<SKLine> {
    
    /// Docs for `insert` and `remove`: https://developer.apple.com/documentation/swift/collectiondifference/change/insert_offset_element_associatedwith
    
    func report() -> Void {
        self.forEach { change in
            print("Chunk Change: ")
            switch change {
            case .insert(let offset, let element, let associatedWith):
                Self.report(offset: offset, element: element, associatedWith: associatedWith, symbol: "+")
            case .remove(let offset, let element, let associatedWith):
                Self.report(offset: offset, element: element, associatedWith: associatedWith, symbol: "-")
            }
        }
    }
    
    /// `offset`, `element`, `associatedWith`, from standard change parameters: https://developer.apple.com/documentation/swift/collectiondifference/change/insert_offset_element_associatedwith
    static func report(offset: Int, element: ChangeElement, associatedWith: Int?, symbol: Character) -> Void {
        (element.startIndex..<element.endIndex).forEach { idx in
            /// Format something like this:
            /// (+) 12: "new line!"
            print(
                "   ", /// padding
                "(\(symbol))",
                "\(idx)".padding(toLength: 3, withPad: " ", startingAt: 0) + ":", /// make line length uniform up to 999 lines
                "\"\(element[idx].string)\""
            )
        }
    }
}
