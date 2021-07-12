//
//  ListItem.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

class ListItem: Node {
    override class var type: String { "listItem" }
    
    let checked: Bool?
    let spread: Bool?
    
    required init?(dict: [AnyHashable: Any]?) {
        let checked = dict?["checked"] as? Bool
        let spread = dict?["spread"] as? Bool
    
        self.checked = checked
        self.spread = spread
        super.init(dict: dict)
    }
}

