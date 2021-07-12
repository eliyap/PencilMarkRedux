//
//  Root.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

class Root: Node {
    override class var type: String { "root" }
    
    override init?(dict: [AnyHashable: Any]?) {
        if
            let dict = dict
        {
            super.init(dict: dict)
        } else {
            print("Failed to initialize \(Self.type)")
            return nil
        }
    }
}
