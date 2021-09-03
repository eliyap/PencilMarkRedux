//
//  ListItem.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation
import UIKit

public final class ListItem: Parent {
    override class var type: String { "listItem" }
    
    let checked: Bool?
    let spread: Bool?
    
    required init?(dict: [AnyHashable: Any]?, parent: Parent?, text: String) {
        let checked = dict?["checked"] as? Bool
        let spread = dict?["spread"] as? Bool
    
        self.checked = checked
        self.spread = spread
        super.init(dict: dict, parent: parent, text: text)
    }
    
    override func style(_ string: NSMutableAttributedString) {
        super.style(string)
        if let leading = leadingRange, let trailing = trailingRange {
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: leading)
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: trailing)
        }
    }
    
    override func getReplacement() -> [Replacement] {
        var result: [Replacement] = []
        
        switch _leading_change {
        case .none:
            break
        case .toAdd:
            fatalError("Not Implemented!")
        case .toRemove:
            if let leading = leadingRange, let _ = trailingRange {
                result += [Replacement(range: leading, replacement: "")]
            } else {
                print("Requested replacement on item with no children!")
                
                /// return whole range to erase everything
                return [Replacement(range: position.nsRange, replacement: "")]
            }
        }
        
        switch _trailing_change {
        case .none:
            break
        case .toAdd:
            fatalError("Not Implemented!")
        case .toRemove:
            if let _ = leadingRange, let trailing = trailingRange {
                result += [Replacement(range: trailing, replacement: "")]
            } else {
                print("Requested replacement on item with no children!")
                
                /// return whole range to erase everything
                return [Replacement(range: position.nsRange, replacement: "")]
            }
        }
        
        return result
    }
}

