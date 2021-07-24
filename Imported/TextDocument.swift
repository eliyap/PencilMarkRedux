//
//  TextDocument.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 23/7/21.
//

import Foundation
import OSLog
import UIKit

enum TextDocumentError: Error {
    case unableToParseText
    case unableToEncodeText
}

final class TextDocument: UIDocument {
    
    public var text = ""
    
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
        
        text = newText
    }
    
    override var localizedName: String {
        fileURL.lastPathComponent
    }
}
