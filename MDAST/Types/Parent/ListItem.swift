//
//  ListItem.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

final class ListItem: Parent {
    override class var type: String { "listItem" }
    
    let checked: Bool?
    let spread: Bool?
    
    required init?(dict: [AnyHashable: Any]?, parent: Parent?) {
        let checked = dict?["checked"] as? Bool
        let spread = dict?["spread"] as? Bool
    
        self.checked = checked
        self.spread = spread
        super.init(dict: dict, parent: parent)
    }
    
    override func getReplacement() -> [StyledMarkdown.Replacement] {
        switch _change {
        case .none:
            fatalError("Replacement requested for nil change!")
        case .toAdd:
            fatalError("Not Implemented!")
        case .toRemove:
            if let leading = leadingRange, let trailing = trailingRange {
                return [
                    StyledMarkdown.Replacement(range: leading, replacement: ""),
                    StyledMarkdown.Replacement(range: trailing, replacement: ""),
                ]
            } else {
                print("Requested replacement on Heading with no children!")
                
                /// return whole range to erase everything
                return [StyledMarkdown.Replacement(range: position.nsRange, replacement: "")]
            }
        }
    }
}

