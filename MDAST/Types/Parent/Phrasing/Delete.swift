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
    }
    
    override func getReplacement() -> [StyledMarkdown.Replacement] {
        switch _change {
        case .none:
            fatalError("Asked for replacement when self did not change!")
        case .toAdd:
            return [
                StyledMarkdown.Replacement(
                    range: _NSRange(location: position.nsRange.lowerBound, length: 0),
                    replacement: "~~"
                ),
                StyledMarkdown.Replacement(
                    range: _NSRange(location: position.nsRange.upperBound, length: 0),
                    replacement: "~~"
                ),
            ]
        case .toRemove:
            return [
                StyledMarkdown.Replacement(
                    range: _NSRange(location: position.nsRange.lowerBound, length: 2),
                    replacement: ""
                ),
                StyledMarkdown.Replacement(
                    range: _NSRange(location: position.nsRange.upperBound - 2, length: 2),
                    replacement: ""
                ),
            ]
        }
    }
}
