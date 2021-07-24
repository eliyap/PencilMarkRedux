//
//  Change.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 23/7/21.
//

import Foundation

extension StyledMarkdownDocument {
    /// Represents changes we want to make to the Markdown.
    enum Change {
        /// a format being added
        case toAdd
        
        /// a format being removed
        case toRemove
    }
}
