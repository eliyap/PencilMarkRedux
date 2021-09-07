//
//  Character.isNonNewlineWhitespace.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 7/9/21.
//

import Foundation

internal extension Character {
    var isNonNewlineWhitespace: Bool {
        isWhitespace && !isNewline
    }
}
