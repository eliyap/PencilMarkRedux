//
//  Change.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 23/7/21.
//

/// Represents changes we want to make to the Markdown.
enum Change {
    /// a format being added
    case toAdd
    
    /// a format being removed
    /// - Note: this does *not* mean the contents are being removed!
    case toRemove
}
