//
//  Delete.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import UIKit

final class Delete: Parent {
    override class var type: String { "delete" }
    
    override func style(_ string: inout NSMutableAttributedString) {
        super.style(&string)
        string.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: position.nsRange)
        
        /// Style surrounding syntax marks
        if let leading = leadingRange, let trailing = trailingRange {
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: leading)
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: trailing)
        }
    }
    
    override func getReplacement() -> [StyledMarkdownDocument.Replacement] {
        switch _change {
        case .none:
            fatalError("Asked for replacement when self did not change!")
        case .toAdd:
            return [
                StyledMarkdownDocument.Replacement(
                    range: NSMakeRange(position.nsRange.lowerBound, 0),
                    replacement: "~~"
                ),
                StyledMarkdownDocument.Replacement(
                    range: NSMakeRange(position.nsRange.upperBound, 0),
                    replacement: "~~"
                ),
            ]
        case .toRemove:
            return [
                StyledMarkdownDocument.Replacement(
                    range: NSMakeRange(position.nsRange.lowerBound, 2),
                    replacement: ""
                ),
                StyledMarkdownDocument.Replacement(
                    range: NSMakeRange(position.nsRange.upperBound - 2, 2),
                    replacement: ""
                ),
            ]
        }
    }
}
