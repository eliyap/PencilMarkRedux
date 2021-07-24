//
//  Text.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

final class Text: Literal {
    override class var type: String { "text" }
    
    override func getReplacement() -> [StyledMarkdownDocument.Replacement] {
        switch _change {
        case .none:
            fatalError("Replacement called when change was nil!")
        case .toAdd:
            fatalError("Not implemented!")
        case .toRemove:
            return [StyledMarkdownDocument.Replacement(range: position.nsRange, replacement: "")]
        }
    }
}
