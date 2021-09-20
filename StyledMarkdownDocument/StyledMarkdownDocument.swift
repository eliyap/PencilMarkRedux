//
//  StyledMarkdownDocument.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 23/7/21.
//

import UIKit
import PMAST

final class StyledMarkdownDocument: UIDocument, MockableDocument {
    
    /// Custom Markdown Model Object
    public var markdown = Markdown("")

    public var errors = Set<DocumentError>()
    
    override init(fileURL url: URL) {
        super.init(fileURL: url)
    }
    
    // MARK:- UIDocument Methods
    override func contents(forType typeName: String) throws -> Any {
        
        guard let data = markdown.plain.data(using: .utf8) else {
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
        markdown = Markdown(newText)
    }
    
    override func handleError(_ error: Error, userInteractionPermitted: Bool) {
        super.handleError(error, userInteractionPermitted: userInteractionPermitted)
        switch (error as NSError).code {
        case NSFileReadNoSuchFileError:
            errors.insert(.noSuchFile)
        default:
            SMDocument.log("""
                UIDocument Error
                - Description: \(error.localizedDescription)
                - Code: \((error as NSError).code)
                """)
            errors.insert(.other)
        }
    }
    
    override var localizedName: String {
        fileURL.lastPathComponent
    }
}
