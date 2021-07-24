//
//  StyledMarkdownDocument.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 23/7/21.
//

import Foundation
import UIKit
import Combine

final class StyledMarkdownDocument: UIDocument {
    
    /// Document description attributes.
    /// Nullable so that we can override init
    public var text: String = ""
    public var styledText = NSMutableAttributedString(string: "", attributes: nil)
    public var ast: Root! = nil

    /// `Combine` event pipeline that fires when the *user* changes the `UITextView`.
    var ticker = PassthroughSubject<Void, Never>()
    
    override init(fileURL url: URL) {
        super.init(fileURL: url)
    }
    
    // MARK:- UIDocument Methods
    override func contents(forType typeName: String) throws -> Any {
        
        guard let data = text.data(using: .utf8) else {
            throw TextDocumentError.unableToEncodeText
        }
        
        return data as Any
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        
        guard let data = contents as? Data else {
            /// This would be a developer error.
            fatalError("*** \(contents) is not an instance of NSData. ***")
        }
        
        guard let newText = String(data: data, encoding: .utf8) else {
            throw TextDocumentError.unableToParseText
        }
        
        /// Set a style loaded value.
        text = newText
        ast = Parser.shared.parse(markdown: text)
        styledText = Self.attributedText(from: text, with: ast)
    }
    
    override var localizedName: String {
        fileURL.lastPathComponent
    }
}

// MARK:- Styling Methods
extension StyledMarkdownDocument {
    /// Call this function to update after the text is updated.
    func updateAttributes() -> Void {
        /// re-formulate AST
        ast = Parser.shared.parse(markdown: text)
        
        /// re-format string based on AST
        styledText = Self.attributedText(from: text, with: ast)
    }
    
    /// Uses the AST to style an attributed string
    /// - Note: make sure the passed AST matches the passed text!
    static func attributedText(from markdown: String, with ast: Root) -> NSMutableAttributedString {
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
