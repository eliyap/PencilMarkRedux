//
//  List.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

final class List: Parent {
    
    override class var type: String { "list" }
    
    let ordered: Bool?
    let start: Int?
    let spread: Bool?
    
    required init?( dict: [AnyHashable: Any]?, parent: Parent?) {
        let ordered = dict?["ordered"] as? Bool
        let start = dict?["start"] as? Int
        let spread = dict?["spread"] as? Bool
        
        self.ordered = ordered
        self.start = start
        self.spread = spread
        super.init(dict: dict, parent: parent)
    }
}