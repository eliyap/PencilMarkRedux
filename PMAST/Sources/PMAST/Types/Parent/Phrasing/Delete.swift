//
//  Delete.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import UIKit

public final class Delete: Parent, InlineJoinable {
    
    override class var type: String { "delete" }
    
    required init?(dict: [AnyHashable : Any]?, parent: Parent?) {
        super.init(dict: dict, parent: parent)
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
    
    override func getReplacement() -> [Replacement] {
        switch _change {
        case .none:
            fatalError("Asked for replacement when self did not change!")
        case .toAdd:
            return [
                Replacement(
                    range: NSMakeRange(position.nsRange.lowerBound, 0),
                    replacement: "~~"
                ),
                Replacement(
                    range: NSMakeRange(position.nsRange.upperBound, 0),
                    replacement: "~~"
                ),
            ]
        case .toRemove:
            return [
                Replacement(
                    range: NSMakeRange(position.nsRange.lowerBound, 2),
                    replacement: ""
                ),
                Replacement(
                    range: NSMakeRange(position.nsRange.upperBound - 2, 2),
                    replacement: ""
                ),
            ]
        }
    }
}
