//
//  Root.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

final class Root: Parent {
    override class var type: String { "root" }
    
    required init?(dict: [AnyHashable: Any]?, parent: Parent?) {
        if
            let dict = dict
        {
            super.init(dict: dict, parent: nil)
        } else {
            print("Failed to initialize \(Self.type)")
            return nil
        }
    }
}
