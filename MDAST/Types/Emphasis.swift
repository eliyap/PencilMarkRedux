//
//  Emphasis.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation
import UIKit

final class Emphasis: Node {
    override class var type: String { "emphasis" }
    
    override func style(_ string: inout NSMutableAttributedString) {
        super.style(&string)
        /// Runs the specified block for each differently formatted section of the provided range
        /// Docs: https://developer.apple.com/documentation/foundation/nsattributedstring/enumerationoptions
        string.enumerateAttribute(.font, in: position.nsRange, options: []) { font, range, _ in
            if let font = font as? UIFont {
                string.addAttribute(.font, value: font.adding(.traitItalic), range: range)
            } else {
                /// `nil` indicates an unformatted string, so just apply plain italics
                string.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize), range: range)
            }
        }
    }
    
    override func getReplacement() -> [StyledMarkdown.Replacement] {
        switch _change {
        case .none:
            fatalError("Asked for replacement when self did not change!")
        case .toAdd:
            return [
                StyledMarkdown.Replacement(
                    range: _NSRange(location: position.nsRange.lowerBound, length: 0),
                    replacement: "*"
                ),
                StyledMarkdown.Replacement(
                    range: _NSRange(location: position.nsRange.upperBound, length: 0),
                    replacement: "*"
                ),
            ]
        case .toRemove:
            return [
                StyledMarkdown.Replacement(
                    range: _NSRange(location: position.nsRange.lowerBound, length: 1),
                    replacement: ""
                ),
                StyledMarkdown.Replacement(
                    range: _NSRange(location: position.nsRange.upperBound - 1, length: 1),
                    replacement: ""
                ),
            ]
        }
    }
}
