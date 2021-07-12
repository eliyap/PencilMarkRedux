//
//  StyledMarkdown.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

/**
 Based on [HWS Tutorial](https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-document-based-app-using-filedocument-and-documentgroup)
 */
struct StyledMarkdown {
    /// tell the system we support only plain text
    static var readableContentTypes = [UTType.plainText]
    
    var text: String
    var styledText: NSMutableAttributedString
    var ast: Root
    
    /// a simple initializer that creates new, empty documents
    init(text: String = "") {
        self.text = text
        self.styledText = styledMarkdown(from: text)
        self.ast = Parser.shared.parse(markdown: text)
    }
}

extension StyledMarkdown {
    func text(for node: Node) -> Substring {
        text[node.position.nsRange.lowerBound..<node.position.nsRange.upperBound]
    }
}

