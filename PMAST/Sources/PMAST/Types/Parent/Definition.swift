//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 19/9/21.
//

import Foundation

public final class Definition: Node {
    class override var type: String { "definition" }
    
    required init?(dict: [AnyHashable: Any]?, parent: Parent?, text: String) {
        super.init(dict: dict, parent: parent, text: text)
        print(dict)
    }
    
    required init(_ node: Node, parent: Parent!) {
        super.init(node, parent: parent)
    }
}
