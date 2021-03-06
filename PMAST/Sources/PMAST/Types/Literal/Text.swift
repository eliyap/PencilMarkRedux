//
//  Text.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

public final class Text: Literal {
    override class var type: String { "text" }
    
    override func getReplacement(in text: String) -> [Replacement] {
        switch _content_change {
        case .none:
            return []
        case .toAdd:
            fatalError("Not implemented!")
        case .toRemove:
            return [Replacement(range: position.nsRange, replacement: "")]
        }
    }
}
