//
//  List.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

public final class List: Parent, ContainerBlock {
    
    override class var type: String { "list" }
    
    let ordered: Bool?
    let start: Int?
    let spread: Bool?
    
    required init?(dict: [AnyHashable: Any]?, parent: Parent?, text: String) {
        let ordered = dict?["ordered"] as? Bool
        let start = dict?["start"] as? Int
        let spread = dict?["spread"] as? Bool
        
        self.ordered = ordered
        self.start = start
        self.spread = spread
        super.init(dict: dict, parent: parent, text: text)
    }
    
    required init(_ node: Node, parent: Parent!) {
        let list = (node as! List)
        self.ordered = list.ordered
        self.start = list.start
        self.spread = list.spread
        super.init(node, parent: parent)
    }
}
