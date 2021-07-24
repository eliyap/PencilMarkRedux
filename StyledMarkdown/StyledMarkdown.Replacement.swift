//
//  StyledMarkdown.Replacement.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

/// Represents a string replacement that needs to be made in the Markdown
extension StyledMarkdown {
    struct Replacement {
        let range: NSRange
        let replacement: String
    }
}
