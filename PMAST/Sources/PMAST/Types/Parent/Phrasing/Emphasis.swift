//
//  Emphasis.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

public final class Emphasis: Parent, InlineJoinable {
    override class var type: String { "emphasis" }
    
    required init?(dict: [AnyHashable : Any]?, parent: Parent?) {
        super.init(dict: dict, parent: parent)
    }
    
    /// Conformance to ``InlineJoinable``, allow no-child `init`.
    init(parent: Parent?, position: Position, _type: String) {
        super.init(parent: parent, position: position, _type: _type, children: [])
    }
    
    override func getReplacement() -> [Replacement] {
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
