//
//  Delete.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import UIKit

public final class Delete: Parent, InlineJoinable, Phrasing {
    
    override class var type: String { "delete" }
    
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
        string.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: position.nsRange)
        
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
                range: NSMakeRange(whitespaceContractedStart(in: text).offset, 0),
                replacement: "~~"
            ))
        case .toRemove:
            result.append(Replacement(
                range: NSMakeRange(position.nsRange.lowerBound, 2),
                replacement: ""
            ))
        }
        
        switch _trailing_change {
        case .none:
            break
        case .toAdd:
            result.append(Replacement(
                range: NSMakeRange(whitespaceContractedEnd(in: text).offset, 0),
                replacement: "~~"
            ))
        case .toRemove:
            result.append(Replacement(
                range: NSMakeRange(position.nsRange.upperBound - 2, 2),
                replacement: ""
            ))
        }
        
        return result
    }
}
