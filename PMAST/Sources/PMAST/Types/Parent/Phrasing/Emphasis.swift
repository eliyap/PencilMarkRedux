//
//  Emphasis.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation
import UIKit

public final class Emphasis: Parent, InlineJoinable {
    override class var type: String { "emphasis" }
    
    required init?(dict: [AnyHashable : Any]?, parent: Parent?, text: String) {
        super.init(dict: dict, parent: parent, text: text)
    }
    
    required init(_ node: Node, parent: Parent!) {
        super.init(node, parent: parent)
    }
    
    /// Conformance to ``InlineJoinable``, allow no-child `init`.
    init(parent: Parent?, position: Position, _type: String) {
        super.init(parent: parent, position: position, _type: _type, children: [])
    }
    
    override func style(_ string: NSMutableAttributedString) {
        super.style(string)
        /// Runs the specified block for each differently formatted section of the provided range
        /// Docs: https://developer.apple.com/documentation/foundation/nsattributedstring/enumerationoptions
        string.enumerateAttribute(.font, in: position.nsRange, options: []) { font, range, _ in
            if let font = font as? UIFont {
                string.addAttribute(.font, value: font.adding(.traitItalic), range: range)
            } else {
                /// `nil` indicates an unformatted string, so just apply plain italics to monospaced font
                let font = UIFont.preferredFont(forTextStyle: .body)
                    .adding(.traitMonoSpace)
                    .adding(.traitItalic)
                string.addAttribute(.font, value: font, range: range)
            }
        }
        
        /// Style surrounding syntax marks
        if let leading = leadingRange, let trailing = trailingRange {
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: leading)
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: trailing)
        }
    }
    
    override func getReplacement(in text: String) -> [Replacement] {
        var result: [Replacement] = []
        
        switch _leading_change {
        case .none:
            break
        case .toAdd:
            result.append(Replacement(
                range: NSMakeRange(position.nsRange.lowerBound, 0),
                replacement: "*"
            ))
        case .toRemove:
            result.append(Replacement(
                range: NSMakeRange(position.nsRange.lowerBound, 1),
                replacement: ""
            ))
        }
        
        switch _trailing_change {
        case .none:
            break
        case .toAdd:
            result.append(Replacement(
                range: NSMakeRange(position.nsRange.upperBound, 0),
                replacement: "*"
            ))
        case .toRemove:
            result.append(Replacement(
                range: NSMakeRange(position.nsRange.upperBound - 1, 1),
                replacement: ""
            ))
        }
        
        return result
    }
}
