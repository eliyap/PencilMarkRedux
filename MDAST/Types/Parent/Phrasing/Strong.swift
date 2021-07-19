//
//  Strong.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation
import UIKit

final class Strong: Parent {
    override class var type: String { "strong" }
    
    override func style(_ string: inout NSMutableAttributedString) {
        super.style(&string)
        /// Runs the specified block for each differently formatted section of the provided range
        /// Docs: https://developer.apple.com/documentation/foundation/nsattributedstring/enumerationoptions
        string.enumerateAttribute(.font, in: position.nsRange, options: []) { font, range, _ in
            if let font = font as? UIFont {
                string.addAttribute(.font, value: font.adding(.traitBold), range: range)
            } else {
                /// `nil` indicates an unformatted string, so just apply italics to monospaced font
                string.addAttribute(.font, value: UIFont.monospacedSystemFont(ofSize: UIFont.systemFontSize, weight: .bold), range: range)
            }
        }
        
        /// Style surrounding syntax marks
        if let leading = leadingRange, let trailing = trailingRange {
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: leading)
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: trailing)
        }
    }
    
    override func getReplacement() -> [StyledMarkdown.Replacement] {
        switch _change {
        case .none:
            fatalError("Asked for replacement when self did not change!")
        case .toAdd:
            return [
                StyledMarkdown.Replacement(
                    range: NSMakeRange(position.nsRange.lowerBound, 0),
                    replacement: "**"
                ),
                StyledMarkdown.Replacement(
                    range: NSMakeRange(position.nsRange.upperBound, 0),
                    replacement: "**"
                ),
            ]
        case .toRemove:
            return [
                StyledMarkdown.Replacement(
                    range: NSMakeRange(position.nsRange.lowerBound, 2),
                    replacement: ""
                ),
                StyledMarkdown.Replacement(
                    range: NSMakeRange(position.nsRange.upperBound - 2, 2),
                    replacement: ""
                ),
            ]
        }
    }
}
