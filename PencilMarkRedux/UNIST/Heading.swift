//
//  Heading.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

final class Heading: Node {
    
    override class var type: String { "heading" }
    
    let depth: Int
    
    override init?(
        dict: [AnyHashable: Any]?
    ) {
        guard
            let depth = dict?["depth"] as? Int
        else {
            print("Failed to initialize \(Self.type)")
            return nil
        }
        self.depth = depth
        super.init(dict: dict)
    }
}

